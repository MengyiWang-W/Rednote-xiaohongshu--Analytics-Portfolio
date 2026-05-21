--is weekend
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

--weekday
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