# Rednote Restaurant Analytics

End-to-end restaurant content analytics project based on Xiaohongshu (Rednote) restaurant post data.

This project simulates a real-world analytics workflow including:

- Data ingestion and cleaning

- Data validation and quality checks

- Feature engineering

- Exploratory data analysis (EDA)

- BI-ready dataset preparation

- SSIS / SSAS / SSRS integration support

---

# Project Overview

The goal of this project is to analyze how different restaurant content characteristics relate to user engagement on Xiaohongshu (Rednote).

The pipeline transforms raw restaurant post data into analytics-ready and BI-ready datasets for downstream reporting and dashboard development.

---

# Project Structure

```text
Rednote-Restaurant-Analytics/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── notebooks/
│   ├── pipeline.py
│   └── eda.py
│
├── src/
│   ├── data_cleaning.py
│   ├── validation.py
│   ├── feature_engineering.py
│   ├── eda_analysis.py
│   └── bi_export.py
│
├── outputs/
│
├── requirements.txt
├── .gitignore
└── README.md

```
---

# Analytics Workflow
1. Data Cleaning

The pipeline performs:

Raw Excel ingestion

Invalid row removal

Index resetting

Data standardization

Initial preprocessing

2. Data Validation

Validation checks include:

Missing column validation

Data type validation

Numeric range validation

Duplicate detection

Consistency checks

Datetime validation

3. Feature Engineering

Engineered features include:

price_avg

price_level

engagement_score

like_rate

save_rate

comment_rate

content_length_bucket

image_count_bucket

image_density

weekday

is_weekend

The pipeline also generates BI-ready identifiers:

post_id

restaurant_id

for downstream SSIS / SSAS star schema integration.

---

# Exploratory Data Analysis (EDA)

The project includes:

Univariate Analysis

Examples:

Price transparency vs engagement

Content length vs engagement

Novelty score vs engagement

Image count vs engagement

Interaction Analysis

Examples:

Content length × image count

Novelty score × restaurant popularity

Structured content × content length

EDA outputs are exported as CSV and Excel files for dashboarding and reporting.

---
# Example Insights

Feature	Value	         Avg Engagement

novelty_score	           3	3.38

image_count_bucket	   small	2.88

content_length_bucket	long	2.61

---
# Technologies Used
Python

Pandas

Jupyter Notebook

Excel

SQL Server

SSIS

SSAS

SSRS

---
# Running the Project
Install dependencies

```
pip install -r requirements.txt

```

Run data pipeline

```
python notebooks/pipeline.py
```

Run EDA analysis

```
python notebooks/eda.py
```
---
# Future Improvements

Potential future extensions include:

Predictive engagement modeling

Time-series analysis

Sentiment analysis

Automated dashboard generation

Recommendation systems

Machine learning classification models

---
# Notes

This repository is intended for analytics portfolio and educational purposes.

Large generated outputs and temporary files are excluded using .gitignore.
