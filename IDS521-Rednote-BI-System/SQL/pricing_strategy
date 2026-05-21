--price level  parameterized dashboard
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

--price segment
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

--has price 
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