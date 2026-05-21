-- parameterized dashboard
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

-- cuisine performance by market dominance
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

-- cuisine performance by efficiency 
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