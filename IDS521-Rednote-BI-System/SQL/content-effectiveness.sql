--structured_content_flag
SELECT 
    CASE
        WHEN f.structured_content_flag = 1 THEN 'Structured'
        ELSE 'Non-Structured'
    END AS structured_content_type,

    COUNT(f.post_id) AS post_count,
    SUM(f.like_count) AS total_likes,
    SUM(f.save_count) AS total_saves,
    SUM(f.comment_count) AS total_comments,

    ROUND(AVG(CAST(f.like_count AS FLOAT)), 2) AS avg_likes_per_post,
    ROUND(AVG(CAST(f.save_count AS FLOAT)), 2) AS avg_saves_per_post,
    ROUND(AVG(CAST(f.comment_count AS FLOAT)), 2) AS avg_comments_per_post,

    ROUND(
        AVG(CAST(f.like_count + f.save_count + 4 * f.comment_count AS FLOAT)), 
        2
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
        WHEN f.structured_content_flag = 1 THEN 'Structured'
        ELSE 'Non-Structured'
    END
ORDER BY avg_weighted_engagement DESC;

--content_length
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
        WHEN f.content_length<300 THEN 'Short'
        WHEN f.content_length between 300 and 600  THEN 'Medium'
        ELSE 'Long'
    END 

ORDER BY avg_weighted_engagement DESC;