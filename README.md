# Marketing Campaign Performance Analysis — February 2021

A SQL-based analysis of 11 marketing campaigns across 4 categories, covering a full 28-day period. The project explores spend efficiency, funnel conversion, geographic targeting, and profitability — culminating in data-driven budget recommendations.

---

## Dataset

| Property | Detail |
|---|---|
| Source | Internal marketing database |
| Period | February 2021 (28 days) |
| Records | 308 rows |
| Columns | 11 |
| Tool | PostgreSQL |

**Columns include:** `c_date`, `campaign_name`, `category`, `mark_spent`, `impressions`, `clicks`, `leads`, `orders`, `revenue`

**Campaign categories:**

| Category | Campaigns |
|---|---|
| Social | facebook_tier1, facebook_tier2, facebook_lal, instagram_tier1, instagram_tier2 |
| Search | google_hot, google_wide |
| Influencer | youtube_blogger, instagram_blogger |
| Media | banner_partner, facebook_retargeting |

---

## Project Structure

```
marketing-analysis/
│
├── marketing_analysis.sql      # Full query file with inline commentary
└── README.md                   # This file
```

---

## Analysis Scope

### General Analytics
- Budget and revenue breakdown by campaign and category
- Identification of best and worst performers by spend and returns

### Business Questions
- Overall and segmented ROMI (Return on Marketing Investment)
- Date-based performance: peak spend days, revenue days, conversion fluctuations
- Weekday vs. weekend engagement and revenue patterns
- Geographic targeting performance (Tier 1 vs. Tier 2 cities)
- Campaign impression dominance over the month (window functions)

### Key Performance Indicators (KPIs)
- Click-Through Rate (CTR)
- Cost Per Click (CPC)
- Visitors-to-Leads conversion rate
- Leads-to-Orders conversion rate
- Average Order Value (AOV)
- Cost Per Lead (CPL)
- Customer Acquisition Cost (CAC)
- Gross Profit / Loss

---

## Key Findings

**Overall ROMI: 40.2% | Gross Profit: KSh 12,298,486**

| Metric | Value |
|---|---|
| Best campaign ROMI | youtube_blogger — 277.32% |
| Worst campaign ROMI | facebook_lal — -88.64% |
| Best category ROMI | Influencer — 154.29% |
| Worst category ROMI | Social — -13.68% |
| Highest AOV campaign | youtube_blogger — KSh 7,999.70 |
| Best leads-to-orders | facebook_retargeting — 0.213 |
| Biggest gross loss | facebook_lal — -KSh 2,341,706 |
| Tier 1 ROMI | 35.29% |
| Tier 2 ROMI | -28.23% |

**Notable insight:** The revenue spike on 20 February 2021 (KSh 5.26M) was driven by repeat customers, not new visitor acquisition — evidenced by an average visitors-to-leads ratio (0.022) but elevated leads-to-orders rate (0.127) that day.

---

## SQL Techniques Used

- Aggregate functions (`SUM`, `AVG`, `ROUND`)
- `GROUP BY` with `ORDER BY` for ranked summaries
- `DISTINCT` for category/campaign exploration
- `EXTRACT(DOW FROM date)` for weekday vs. weekend segmentation
- `CASE WHEN` for conditional aggregation and geo-tier classification
- `LIKE` pattern matching for tier segmentation (`%tier1`, `%tier2`)
- CTEs (`WITH`) for multi-step aggregation
- Window functions (`ROW_NUMBER() OVER PARTITION BY`) for daily campaign ranking
- Type casting (`::NUMERIC`) for division precision

---

## Recommendations Summary

| Campaign / Area | Issue | Action |
|---|---|---|
| facebook_lal | -88.64% ROMI, -KSh 2.34M loss, highest CPC | **Pause immediately** |
| instagram_tier2 | Lowest leads-to-orders (0.030), Tier 2 geo | Redirect budget to instagram_tier1 |
| facebook_tier1 | -6.57% ROMI despite Tier 1 market | Reduce budget, A/B test creatives |
| google_wide | -33.67% ROMI | Pause; shift to google_hot |
| facebook_retargeting | Highest CTR (0.031) and L-to-O (0.213) | Increase budget allocation |
| youtube_blogger | 277.32% ROMI, KSh 11.25M profit | Scale up |
| banner_partner | Lowest CTR (~0.000), 22.41% ROMI vs 40.2% avg | Renegotiate placement or reduce |
| Influencer (category) | Highest ROMI, AOV, and conversion | Increase overall budget share |
| Tier 1 targeting | 35.29% ROMI vs -28.23% Tier 2 | Prioritise in all geo campaigns |
| Weekday scheduling | +2.9M avg impressions, +KSh 9,320 avg revenue vs weekends | Weight budget toward Mon–Fri |

---

## How to Run

1. Set up a PostgreSQL instance and import the `marketing` table.
2. Open `marketing_analysis.sql` in your SQL client (pgAdmin, DBeaver, psql, etc.).
3. Run queries section by section — each block is self-contained with inline commentary explaining the result.

> Queries were written and tested on **PostgreSQL 14+**. Minor syntax adjustments may be needed for other SQL dialects.

---

## Author

**George Mulu**
Data Analytics Portfolio Project
[GitHub: georgemulu](https://github.com/georgemulu)
