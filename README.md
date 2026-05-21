# Rednote Restaurant Content Analytics Pipeline

This project analyzes Xiaohongshu / Rednote restaurant posts to understand which content features are associated with higher engagement.

## Project Goal
Identify how content format, price transparency, posting time, image volume, novelty, and restaurant popularity relate to user engagement.

## Pipeline
1. Load raw restaurant post data
2. Clean and standardize fields
3. Validate schema, missing values, duplicates, and numeric ranges
4. Engineer content and engagement features
5. Generate univariate and interaction-level EDA summaries
6. Export cleaned and feature-ready datasets for BI modeling

## Key Features
- price_avg
- price_level
- content_length_bucket
- image_count_bucket
- engagement_score
- like_rate
- save_rate
- comment_rate
- is_weekend
- restaurant_id
- post_id

## Example Findings
- Long-form content showed higher average engagement than short or medium content.
- Smaller image-count groups performed better in this dataset.
- Weekend posts did not outperform weekday posts in the current sample.
- Some interaction groups, such as short content with medium image volume, showed strong engagement but require caution due to small sample size.

## Business Use
The processed dataset can support:
- content strategy analysis
- restaurant post performance comparison
- BI dashboarding
- SSIS / SSAS / SSRS star schema modeling