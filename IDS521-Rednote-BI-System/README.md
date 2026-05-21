# IDS521 Rednote BI System

This repository reorganizes my IDS521 final project into a structured business intelligence portfolio.

The project builds an end-to-end BI workflow for Rednote restaurant content analytics using SQL Server, SSIS, SSAS, and SSRS.

## BI Pipeline

```text
Rednote Raw Data
        ↓
SSIS ETL Pipeline
        ↓
SQL Server Data Warehouse
        ↓
SSAS Cube
        ↓
SSAS KPI Layer
        ↓
SSRS Dashboards

```

## Project Structure
IDS521-Rednote-BI-System/
├── docs/
│   └── system flow.png
├── final_report/
├── SQL/
│   ├── Full SQLQuery.sql
│   ├── cuisine_performance.sql
│   ├── pricing_strategy.sql
│   ├── content_effectiveness.sql
│   ├── creative_roi.sql
│   ├── posting_schedule.sql
│   └── overview.md
├── SSIS/
│   ├── screenshots/
│   └── overview.md
├── SSAS/
│   ├── screenshots/
│   └── overview.md
├── SSRS/
│   ├── screenshots/
│   └── overview.md
├── src/
│   └── bi_export.py
├── README.md
└── .gitignore

## Business Objective

The objective of this BI system is to transform Rednote restaurant post data into a structured reporting system that supports business questions around:

cuisine market performance
pricing strategy
content effectiveness
creative ROI
posting schedule analysis
engagement KPI monitoring

## SQL Server Data Warehouse

The warehouse was designed using a star schema structure:

FactPosts: post-level engagement fact table
DimRestaurant: restaurant, cuisine, pricing, and popularity attributes
DimDate: date hierarchy for time-based reporting

Core SQL scripts are stored in the SQL/ folder.

## SSIS ETL Pipeline

SSIS was used to load CSV-based analytics outputs into SQL Server warehouse tables.

Main ETL steps:

Import CSV files using Flat File Source
Standardize data types using Data Conversion
Load DimDate
Load DimRestaurant
Load FactPosts
Validate warehouse row counts

## SSAS Cube and KPI Layer

SSAS was used to create an OLAP cube for multidimensional engagement analysis.

The cube supports analysis across:

cuisine type
pricing level
restaurant popularity
posting date
content structure
engagement metrics

The KPI layer evaluates weighted engagement performance using status categories such as Strong, Acceptable, and Weak.

## SSRS Dashboards

SSRS reports translate SQL and cube outputs into business-facing dashboards.

Dashboard themes include:

Market Intelligence
Pricing Strategy
Content Effectiveness
Creative ROI
Posting Schedule

Parameterized reports allow users to filter dashboards by business dimensions such as cuisine type or price level.

## KPI Logic

The core engagement KPI is based on weighted engagement:

Weighted Engagement = Like Count + Save Count + 4 × Comment Count

This gives higher weight to comments because comments usually represent deeper user interaction than likes or saves.

## Repository Purpose

This repository is intended to demonstrate:

SQL Server data warehouse design
SSIS ETL workflow
SSAS cube and KPI modeling
SSRS dashboard reporting
BI project documentation
business insight generation from social content data