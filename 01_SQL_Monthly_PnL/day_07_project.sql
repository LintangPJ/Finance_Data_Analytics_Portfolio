-- ============================================
-- Monthly P&L Report
-- Source: daily_sales
-- Covers: Jan–Mar 2024
-- Author: Lintang Permata Jati
-- Built: Day 7 of 30-Day Finance Data Analyst
-- ============================================

-- CTE 1: monthly_base
WITH
monthly_base AS (
    SELECT 
        strftime('%Y-%m', transaction_date) AS month,
        SUM(CASE WHEN category = 'Revenue' THEN amount ELSE 0 END) AS revenue,
        SUM(CASE WHEN category = 'COGS' THEN amount ELSE 0 END) AS cogs,
        SUM(CASE WHEN category = 'OpEx' THEN amount ELSE 0 END) AS opex
    FROM daily_sales
    GROUP BY month
),

-- CTE 2: monthly_calc
monthly_calc AS (
    SELECT 
        month,
        revenue,
        cogs,
        opex,
        (revenue + cogs) AS gross_profit,
        (revenue + cogs + opex) AS ebit,
        ((revenue + cogs) / NULLIF(revenue, 0)) * 100 AS gp_margin_pct,
        ((revenue + cogs + opex) / NULLIF(revenue, 0)) * 100 AS ebit_margin_pct
    FROM monthly_base
),

-- CTE 3: monthly_mom
monthly_mom AS (
    SELECT 
        month,
        revenue,
        cogs,
        gross_profit,
        gp_margin_pct,
        opex,
        ebit,
        ebit_margin_pct,
        COALESCE(ebit - LAG(ebit) OVER (ORDER BY month), 0) AS mom_ebit_change
    FROM monthly_calc
)

-- FINAL SELECT: formatting layer only
SELECT 
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(cogs, 2) AS cogs,
    ROUND(gross_profit, 2) AS gross_profit,
    ROUND(gp_margin_pct, 1) AS gp_margin_pct,
    ROUND(opex, 2) AS opex,
    ROUND(ebit, 2) AS ebit,
    ROUND(ebit_margin_pct, 1) AS ebit_margin_pct,
    ROUND(mom_ebit_change, 2) AS mom_ebit_change
FROM monthly_mom

UNION ALL

SELECT 
    '2024-Q1 Total' AS month,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(cogs), 2) AS cogs,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    ROUND(AVG(gp_margin_pct), 1) AS gp_margin_pct, -- Persentase pakai AVG, bukan SUM
    ROUND(SUM(opex), 2) AS opex,
    ROUND(SUM(ebit), 2) AS ebit,
    ROUND(AVG(ebit_margin_pct), 1) AS ebit_margin_pct,
    ROUND(SUM(mom_ebit_change), 2) AS mom_ebit_change
FROM monthly_mom;