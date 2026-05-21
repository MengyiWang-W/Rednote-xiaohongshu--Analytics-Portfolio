--image_count
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

--photo_quality_score
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