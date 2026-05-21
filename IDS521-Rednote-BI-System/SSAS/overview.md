# Objective

Build a multidimensional analytical cube for strategic restaurant intelligence.

# Cube Components:

Measures:Like Count | Save Count | Comment Count | Weighted Engagement | Post Count

Dimensions: Date | Restaurant | Cuisine | Price

This cube structure transforms warehouse data into multidimensional strategic intelligence.

“The SSAS cube supports hierarchical time analysis (Year → Month → Day), enabling trend decomposition of engagement metrics over time and supporting restaurant-level performance analytics.”

# HOW OLAP SCHEMA WORKS

OLAP Operational Demonstration

This multidimensional schema enables:

Slice: Engagement by cuisine type

Dice: Medium-price Italian posts on weekends

Drill Down: Year → Month → Day

Roll Up: Individual posts → Category portfolio

Strategic Value: The schema transforms flat post data into decision-ready multidimensional intelligence.

# KPI 1 — Weighted Engagement Performance

Value: (Like Count + Save Count + 4 × Comment Count) / Post Count

Goal: 800

Status: Strong / Acceptable / Weak

Trend: Directional comparative trend based on weighted engagement category movement across hierarchical dimensions.

# KPI 2 — Save Efficiency Trend

Value: Save Count / Post Count

Goal: 350

Status: Strong / Acceptable / Weak

Business Value: KPI transforms raw metrics into interpretable business quality signals.


# SSAS Browser Demonstration

The browser interface validates that the cube can operationally answer business questions through real-time multidimensional exploration.

Example:
•	Filter by Cuisine Type 
•	Compare Price Level 
•	Drill into Date hierarchy 
•	Evaluate KPI status 

Strategic Function

This allows decision-makers to move from raw SQL querying to executive-style analytical navigation.
