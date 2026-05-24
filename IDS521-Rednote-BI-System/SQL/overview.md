# Full SQL Technical Infrastructure

# Purpose

This appendix summarizes the core SQL technical infrastructure used to build, validate, clean, and optimize the Rednote Chicago restaurant intelligence system. It demonstrates that the project is supported not only by dashboards and business insights, but also by reproducible database engineering, warehouse governance, and OLAP-ready analytical design.

# Core SQL Infrastructure Included

# 1. Database & Star Schema Creation

The project warehouse was built using SQL Server relational architecture with three primary components:

DimDate — Time intelligence and temporal hierarchy 

DimRestaurant — Cuisine, pricing, and restaurant segmentation 

FactPosts — Engagement fact table for post-level analytics 

## Core Functions:

CREATE TABLE 

Relational schema design 

Fact / Dimension separation 

Warehouse deployment for SSIS + SSAS + SSRS integration 

## Technical Significance

This structure enabled multidimensional business analysis across:

Market Intelligence 

Pricing Strategy 

Content Effectiveness 

Visual ROI 

Posting Schedule 

# 2. Data Validation & Referential Integrity

Validation queries were used to confirm:

Correct row counts across all tables 

Fact-to-dimension relationship integrity 

No unmatched restaurant keys 

No unmatched date keys 

Duplicate date prevention 

## Representative Validation:

COUNT(*) row checks 

LEFT JOIN unmatched key detection 

Duplicate date checks 

## Expected Final Integrity:

FactPosts ≈ 96 rows 

DimRestaurant ≈ 83 rows 

DimDate ≈ 1593 rows 

## Technical Significance:

These controls ensured that ETL outputs were analytically reliable before cube deployment and dashboard generation.

# 3. Data Cleaning & Category Standardization

## SQL update logic standardized inconsistent categorical values such as:

Vietnam / Vietnamese → Vietnamese 

America / American → American 

Thailand → Thai 

Mexico → Mexican 

unknown → Unclassified 

## Business Importance

Without taxonomy normalization:

Category fragmentation increases 

Market intelligence becomes distorted 

Strategic recommendations weaken 

## Strategic Significance

This process improved segmentation accuracy and strengthened downstream cuisine strategy analysis.

# 4. Time Dimension Enhancement for OLAP

## Additional time intelligence was added using:

month_key 

Year / Month / Day hierarchy preparation 

## Purpose:

SSAS hierarchy 

Monthly rollups 

Trend analysis 

Posting schedule intelligence 

## Technical Significance

This transformed DimDate from a flat lookup table into an OLAP-compatible time dimension.

# 5. ETL Governance & Reload Control

Optional reset SQL was used during SSIS reruns to prevent duplicate warehouse loads:

DELETE FROM dbo.FactPosts;

DELETE FROM dbo.DimRestaurant;

DELETE FROM dbo.DimDate;

## Governance Purpose

This ensured clean ETL reruns, no duplicate append errors and stable warehouse state during testing. 

## Technical Significance: 

Demonstrates operational awareness of real-world data pipeline governance.

## Full SQL Script Submission

The complete technical SQL package (Group20_FullSQL.sql) includes:

CREATE DATABASE 

CREATE TABLE 

INSERT / Load logic 

UPDATE / Cleaning 

Validation queries 

SSRS report dataset queries 

Parameterized report queries 

Business intelligence query library 

## Final Technical Significance

This appendix confirms that the project is supported by:

Database Engineering

Data Validation

Cleaning & Standardization

Warehouse Governance

OLAP Readiness

Reproducible BI Infrastructure

Final Technical Positioning

Raw Social Data 
→ 

Structured SQL Warehouse 
→ 

Validated Analytical Database 
→ 

OLAP Intelligence 
→ 

Strategic Decision System


