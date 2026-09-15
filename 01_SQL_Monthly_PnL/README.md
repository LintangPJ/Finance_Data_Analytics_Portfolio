# Day 7: Week 1 Mini Project, Monthly P&L Report

## Overview
I took a raw daily transactions table (`daily_sales`) and wrote a SQL script to turn it into a clean, ready-to-use Monthly Profit and Loss statement.

## How it works
1. **`monthly_base` (Aggregation Layer):** Groups the raw daily rows into monthly buckets using conditional aggregation.
2. **`monthly_calc` (Logic Layer):** Calculates Gross Profit and EBIT. Uses `NULLIF()` for the profit margins to prevent divide-by-zero errors.
3. **`monthly_mom` (Trend Layer):** Uses the `LAG()` window function to track how EBIT changes from month to month.
4. **`FINAL SELECT` & `UNION ALL` (Presentation Layer):** Formats the numbers and adds a summary row for Q1 2024.
