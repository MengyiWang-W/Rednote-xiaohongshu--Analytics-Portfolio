-- Database & Star Schema Creation
/*
Group 20 — IDS521 Final Project
Rednote Chicago Restaurant BI Analytics System

Includes:
1. Database schema creation
2. Data validation & referential integrity
3. Data cleaning & category standardization
4. OLAP enhancement
5. SSRS dashboard queries
6. Parameterized reporting

Note:
DELETE / reload controls are commented out for governance safety.
*/
USE IDS521_Final;
CREATE TABLE dbo.DimDate (
    full_date DATE,
    date_id INT,
    year INT,
    month INT,
    day INT,
    weekday_num INT,
    is_weekend INT
);

CREATE TABLE dbo.DimRestaurant (
    restaurant_id NVARCHAR(50),
    restaurant_name NVARCHAR(100),
    cuisine_type NVARCHAR(50),
    restaurant_popularity INT,
    novelty_score INT,
    price_avg DECIMAL(10,2) NULL,
    price_level NVARCHAR(50)
);

CREATE TABLE dbo.FactPosts (
    post_id NVARCHAR(50),
    restaurant_id NVARCHAR(50),
    emotion_category NVARCHAR(50),
    has_price INT,
    has_info_gap INT,
    content_length INT,
    photo_quality_score INT,
    structured_content_flag INT,
    image_count INT,
    follower_count INT,
    like_count INT,
    save_count INT,
    comment_count INT,
    date_id INT
);
-- Data Validation + Referential Integrity
select count(*) from dbo.DimDate;
select count(*) from dbo.DimRestaurant;
select count(*) from dbo.FactPosts;

select * from dbo.DimDate;
select * from dbo.DimRestaurant;
select * from dbo.FactPosts;

SELECT cuisine_type, COUNT(*) AS restaurant_count
FROM DimRestaurant
GROUP BY cuisine_type
ORDER BY restaurant_count DESC;

SELECT COUNT(*) AS unmatched_restaurant
FROM dbo.FactPosts f
LEFT JOIN dbo.DimRestaurant r
  ON f.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;

SELECT COUNT(*) AS unmatched_date
FROM dbo.FactPosts f
LEFT JOIN dbo.DimDate d
  ON f.date_id = d.date_id
WHERE d.date_id IS NULL;

SELECT
  COUNT(*) AS fact_rows,
  COUNT(DISTINCT post_id) AS unique_posts,
  COUNT(DISTINCT restaurant_id) AS restaurants_in_fact,
  COUNT(DISTINCT date_id) AS dates_in_fact
FROM dbo.FactPosts;

SELECT DISTINCT f.date_id
FROM dbo.FactPosts f
LEFT JOIN dbo.DimDate d
ON f.date_id = d.date_id
WHERE d.date_id IS NULL;

--Data Cleaning & Category Standardization
UPDATE DimRestaurant
SET cuisine_type =
CASE
    WHEN cuisine_type IN ('Vietnam',' Vietnam','Vietnamese') THEN 'Vietnamese'
    WHEN cuisine_type IN ('America','American') THEN 'American'
    WHEN cuisine_type = 'unknown' THEN 'Unclassified'
    WHEN cuisine_type = 'Thailand' THEN 'Thai'
    WHEN cuisine_type = 'Mexico' THEN 'Mexican'
    ELSE cuisine_type
END;

--Time Dimension Enhancement for OLAP
INSERT INTO dbo.DimDate
(full_date, date_id, year, month, day, weekday_num, is_weekend)
VALUES
('2021-06-02', 20210602, 2021, 6, 2, 2, 0);

ALTER TABLE dbo.DimDate
ADD month_key INT;

UPDATE dbo.DimDate
SET month_key = year * 100 + month;

SELECT date_id, COUNT(*) AS cnt
FROM dbo.DimDate
GROUP BY date_id
HAVING COUNT(*) > 1;

--ETL Governance & Reload Control
-- Delete from dbo.DimDate;
-- Delete  from dbo.DimRestaurant;
-- Delete  from dbo.FactPosts;

--SSRS QUERIES

--Report1  Market Category Performance Dashboard
-- 1A Cuisine Market Dominance
SELECT 
    r.cuisine_type,

    COUNT(f.post_id) AS post_count,
    COUNT(DISTINCT r.restaurant_id) AS restaurant_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(f.like_count), 2) AS avg_likes_per_post,
    ROUND(AVG(f.save_count), 2) AS avg_saves_per_post,
    ROUND(AVG(f.comment_count), 2) AS avg_comments_per_post,

    ROUND(
        AVG(f.like_count + f.save_count + 4 * f.comment_count), 2
    ) AS avg_weighted_engagement,

    SUM(f.like_count + f.save_count + 4 * f.comment_count) AS total_weighted_engagement,
   CASE
    
     WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
        THEN 'Strong'
     
     WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
        THEN 'Acceptable'
    
    ELSE 'Weak'
END AS kpi_status

FROM FactPosts f
JOIN DimRestaurant r
    ON f.restaurant_id = r.restaurant_id

WHERE r.cuisine_type IS NOT NULL
  AND LTRIM(RTRIM(r.cuisine_type)) <> ''
  AND r.cuisine_type = @CuisineType

GROUP BY r.cuisine_type
ORDER BY avg_weighted_engagement DESC;

-- 1B Cuisine Engagement Efficiency
SELECT 
    r.cuisine_type,

    COUNT(f.post_id) AS post_count,
    COUNT(DISTINCT r.restaurant_id) AS restaurant_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(f.like_count), 2) AS avg_likes_per_post,
    ROUND(AVG(f.save_count), 2) AS avg_saves_per_post,
    ROUND(AVG(f.comment_count), 2) AS avg_comments_per_post,

    ROUND(
        AVG(f.like_count + f.save_count + 4 * f.comment_count), 2
    ) AS avg_weighted_engagement,

    CASE
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'
        
      ELSE 'Weak'
    END AS kpi_status,
    SUM(
        f.like_count + f.save_count + 4 * f.comment_count
    ) AS total_weighted_engagement

FROM FactPosts f
JOIN DimRestaurant r
    ON f.restaurant_id = r.restaurant_id

WHERE r.cuisine_type IS NOT NULL
  AND LTRIM(RTRIM(r.cuisine_type)) <> ''

GROUP BY r.cuisine_type

ORDER BY total_weighted_engagement DESC;

-- 1C Cuisine Engagement Efficiency
SELECT TOP 5
    r.cuisine_type,

    COUNT(f.post_id) AS post_count,
    COUNT(DISTINCT r.restaurant_id) AS restaurant_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(f.like_count), 2) AS avg_likes_per_post,
    ROUND(AVG(f.save_count), 2) AS avg_saves_per_post,
    ROUND(AVG(f.comment_count), 2) AS avg_comments_per_post,

    ROUND(
        AVG(f.like_count + f.save_count + 4 * f.comment_count), 2
    ) AS avg_weighted_engagement,

    SUM(f.like_count + f.save_count + 4 * f.comment_count) AS total_weighted_engagement,
   CASE
    
     WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
        THEN 'Strong'
     
     WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
        THEN 'Acceptable'
    
    ELSE 'Weak'
END AS kpi_status

FROM FactPosts f
JOIN DimRestaurant r
    ON f.restaurant_id = r.restaurant_id

WHERE r.cuisine_type IS NOT NULL
  AND LTRIM(RTRIM(r.cuisine_type)) <> ''
 
GROUP BY r.cuisine_type
ORDER BY avg_weighted_engagement DESC;

-- Report 2: Pricing Strategy
-- 2A Price Level Performance
SELECT 
    d.price_level,

    COUNT(f.post_id) AS post_count,
    COUNT(DISTINCT d.restaurant_id) AS restaurant_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(f.like_count), 2) AS avg_likes_per_post,
    ROUND(AVG(f.save_count), 2) AS avg_saves_per_post,
    ROUND(AVG(f.comment_count), 2) AS avg_comments_per_post,

    ROUND(
        AVG(f.like_count + f.save_count + f.comment_count * 4), 2
    ) AS avg_weighted_engagement,

     CASE
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'
        
        ELSE 'Weak'
    
    END AS kpi_status

FROM FactPosts f
JOIN DimRestaurant d
    ON f.restaurant_id = d.restaurant_id

WHERE d.price_level IS NOT NULL
  AND LTRIM(RTRIM(d.price_level)) <> ' '
  AND LOWER(d.price_level) <> 'unknown'
GROUP BY d.price_level
ORDER BY avg_weighted_engagement DESC;

-- 2B Premium vs Budget
SELECT 
    CASE 
        WHEN d.price_level IN ('high', 'medium') THEN 'Premium'
        WHEN d.price_level = 'low' THEN 'Budget'
    END AS price_segment,

    COUNT(f.post_id) AS post_count,
    COUNT(DISTINCT d.restaurant_id) AS restaurant_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(f.like_count), 2) AS avg_likes_per_post,
    ROUND(AVG(f.save_count), 2) AS avg_saves_per_post,
    ROUND(AVG(f.comment_count), 2) AS avg_comments_per_post,

    ROUND(
        AVG(f.like_count + f.save_count + 4 * f.comment_count), 2
    ) AS avg_weighted_engagement,

     CASE
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'
        
        ELSE 'Weak'
    
    END AS kpi_status

FROM FactPosts f
JOIN DimRestaurant d
    ON f.restaurant_id = d.restaurant_id

WHERE d.price_level IS NOT NULL
  AND LOWER(d.price_level) <> 'unknown'

GROUP BY 
    CASE 
        WHEN d.price_level IN ('high', 'medium') THEN 'Premium'
        WHEN d.price_level = 'low' THEN 'Budget'
    END

ORDER BY avg_weighted_engagement DESC;

-- 2C Price Transparency
Select 
  f.has_price,
  Count(f.post_id) as post_counts,
  Count(f.restaurant_id) as restaurant_counts,
  Sum(f.like_count) as total_likes,
  Sum(f.save_count) as total_saves,
  Sum(f.comment_count) as total_comments,
  Round(avg(cast(f.like_count as float)),2) as avg_likes_per_post,
  Round(avg(cast(f.save_count as float)),2) as avg_saves_per_post,
  Round(avg(cast(f.comment_count as float)),2) as avg_comments_per_post,
  Round(avg(cast(f.like_count+ f.save_count+4* f.comment_count as float)),2) as avg_weighted_engagement,
     CASE
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'
        
        ELSE 'Weak'
    
    END AS kpi_status

From FactPosts f
Group by f.has_price;

-- 2D Parameterized Price Level Query
SELECT 
    d.price_level,

    COUNT(f.post_id) AS post_count,
    COUNT(DISTINCT d.restaurant_id) AS restaurant_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(f.like_count), 2) AS avg_likes_per_post,
    ROUND(AVG(f.save_count), 2) AS avg_saves_per_post,
    ROUND(AVG(f.comment_count), 2) AS avg_comments_per_post,

    ROUND(
        AVG(f.like_count + f.save_count + f.comment_count * 4), 2
    ) AS avg_weighted_engagement,

     CASE
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'
        
        WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'
        
        ELSE 'Weak'
    
    END AS kpi_status

FROM FactPosts f
JOIN DimRestaurant d
    ON f.restaurant_id = d.restaurant_id

WHERE d.price_level IS NOT NULL
  AND LTRIM(RTRIM(d.price_level)) <> ' '
  AND LOWER(d.price_level) <> 'unknown'
  AND d.price_level = @PriceLevel
GROUP BY d.price_level
ORDER BY avg_weighted_engagement DESC;

-- Report 3: Content Effectiveness
-- 3A Caption Length
SELECT 
    CASE 
        WHEN f.content_length<300 THEN 'Short'
        WHEN f.content_length between 300 and 600  THEN 'Medium'
        ELSE 'Long'
    END AS content_length_tier,
    COUNT(f.post_id) AS post_count,
    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,
    ROUND(AVG(CONVERT(FLOAT, f.like_count)), 2) AS avg_likes_per_post,
    ROUND(AVG(CONVERT(FLOAT, f.save_count)), 2) AS avg_saves_per_post,
	ROUND(AVG(CONVERT(FLOAT, f.comment_count)), 2) AS avg_comments_per_post,
	ROUND(AVG(CONVERT(FLOAT, f.like_count + f.save_count + 4 * f.comment_count)),2) AS avg_weighted_engagement,
    CASE      
        WHEN ROUND(AVG(CONVERT(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'    
        WHEN ROUND(AVG(CONVERT(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'      
        ELSE 'Weak'
    END AS kpi_status

FROM FactPosts f

GROUP BY 
CASE 
        WHEN f.content_length<300 THEN 'Short'
        WHEN f.content_length between 300 and 600  THEN 'Medium'
        ELSE 'Long'
    END 

ORDER BY avg_weighted_engagement DESC;

-- 3B Structured vs Non-Structured
SELECT 
    CASE
        WHEN f.structured_content_flag = 1 THEN 'Structured'
        ELSE 'Non-Structured'
    END AS structured_content_type,

    COUNT(f.post_id) AS post_count,
    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(CONVERT(f.like_count AS FLOAT)), 2) AS avg_likes_per_post,
    ROUND(AVG(CONVERT(f.save_count AS FLOAT)), 2) AS avg_saves_per_post,
    ROUND(AVG(CONVERT(f.comment_count AS FLOAT)), 2) AS avg_comments_per_post,

    ROUND(
        AVG(CONVERT(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 
        2
    ) AS avg_weighted_engagement,

    CASE      
        WHEN ROUND(AVG(CONVERT(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'    
        WHEN ROUND(AVG(CONVERT(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'      
        ELSE 'Weak'
    END AS kpi_status

FROM FactPosts f
GROUP BY 
    CASE
        WHEN f.structured_content_flag = 1 THEN 'Structured'
        ELSE 'Non-Structured'
    END
ORDER BY avg_weighted_engagement DESC;

-- Report 4: Creative ROI
-- 4A Image Volume
SELECT 
    CASE 
        WHEN f.image_count BETWEEN 0 AND 6 THEN 'Low Image Volume'
        WHEN f.image_count BETWEEN 7 AND 12 THEN 'Medium Image Volume'
        ELSE 'High Image Volume'
    END AS image_volume_tier,

    COUNT(f.post_id) AS post_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(CAST(f.like_count AS FLOAT)), 2) AS avg_likes_per_post,
    ROUND(AVG(CAST(f.save_count AS FLOAT)), 2) AS avg_saves_per_post,
    ROUND(AVG(CAST(f.comment_count AS FLOAT)), 2) AS avg_comments_per_post,
    ROUND(
        AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2
    ) AS avg_weighted_engagement,

    CASE      
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'    
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'      
        
       ELSE 'Weak'
    
    END AS kpi_status


FROM FactPosts f
GROUP BY 
    CASE 
        WHEN f.image_count BETWEEN 0 AND 6 THEN 'Low Image Volume'
        WHEN f.image_count BETWEEN 7 AND 12 THEN 'Medium Image Volume'
        ELSE 'High Image Volume'
    END

ORDER BY avg_weighted_engagement DESC;

-- 4B Photo Quality
SELECT 
    CASE 
        WHEN f.photo_quality_score=1 THEN 'Low photo quality'
        WHEN f.photo_quality_score=2 THEN 'Medium photo quality'
        ELSE 'High photo quality'
    END AS photo_quality_tier,

    COUNT(f.post_id) AS post_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(CAST(f.like_count AS FLOAT)), 2) AS avg_likes_per_post,
    ROUND(AVG(CAST(f.save_count AS FLOAT)), 2) AS avg_saves_per_post,
    ROUND(AVG(CAST(f.comment_count AS FLOAT)), 2) AS avg_comments_per_post,

    ROUND(
        AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2
    ) AS avg_weighted_engagement,
    CASE           
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'    
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'      
       ELSE 'Weak'
    END AS kpi_status

FROM FactPosts f

GROUP BY 
CASE 
      WHEN f.photo_quality_score=1 THEN 'Low photo quality'
        WHEN f.photo_quality_score=2 THEN 'Medium photo quality'
        ELSE 'High photo quality'
    END 

ORDER BY avg_weighted_engagement DESC;

-- Report 5: Posting Schedule
-- 5A Weekend vs Weekday
SELECT 
    CASE
 
      WHEN is_weekend = 1 THEN 'Weekend'
 
      ELSE 'Weekday'

    END AS day_type,
    COUNT(f.post_id) AS post_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(CAST(f.like_count AS FLOAT)), 2) AS avg_likes_per_post,
    ROUND(AVG(CAST(f.save_count AS FLOAT)), 2) AS avg_saves_per_post,
    ROUND(AVG(CAST(f.comment_count AS FLOAT)), 2) AS avg_comments_per_post,

    ROUND(
        AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2
    ) AS avg_weighted_engagement,

    
    CASE      
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'    
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'      
        
       ELSE 'Weak'
    
    END AS kpi_status


FROM FactPosts f
JOIN DimDate d
    ON f.date_id = d.date_id

GROUP BY d.is_weekend
ORDER BY avg_weighted_engagement DESC;

-- 5B Weekday Performance
SELECT 
    CASE 
        WHEN d.weekday_num = 0 THEN 'Monday'
        WHEN d.weekday_num = 1 THEN 'Tuesday'
        WHEN d.weekday_num = 2 THEN 'Wednesday'
        WHEN d.weekday_num = 3 THEN 'Thursday'
        WHEN d.weekday_num = 4 THEN 'Friday'
        WHEN d.weekday_num = 5 THEN 'Saturday'
        ELSE 'Sunday'
    END AS weekday_name,

    COUNT(f.post_id) AS post_count,

    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,
    ROUND(AVG(CAST(f.like_count AS FLOAT)), 2) AS avg_likes_per_post,
    ROUND(AVG(CAST(f.save_count AS FLOAT)), 2) AS avg_saves_per_post,
    ROUND(AVG(CAST(f.comment_count AS FLOAT)), 2) AS avg_comments_per_post,
    ROUND(
        AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2
    ) AS avg_weighted_engagement,

    
    CASE      
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 1200 
            THEN 'Strong'    
        
       WHEN ROUND(AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 2) >= 600 
            THEN 'Acceptable'      
        
       ELSE 'Weak'
    
    END AS kpi_status


FROM FactPosts f
JOIN DimDate d
    ON f.date_id = d.date_id

GROUP BY d.weekday_num

ORDER BY avg_weighted_engagement DESC;

