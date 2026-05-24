--To view all records in the database
SELECT *
FROM marketing;
--The dataset has 11 columns and 308 rows

--To identify categories of marketing campaigns
SELECT DISTINCT(category)
FROM marketing;
--There are 4 distinct categories social, search, influencer and media

--To identify types of campaigns in the database
SELECT DISTINCT(campaign_name)
FROM marketing;

SELECT DISTINCT campaign_name
FROM marketing
WHERE category = 'media';
--There are 11 distinct campaign names: banner_partner, youtube_blogger, facebook retargeting, google_hot, google_wide, instagram_blogger,
--facebook_tier1, facebook_tier2, facebook_lal, instagram_tier1, instagram_tier2

--All campaign_names with social media names and not ending in blogger are in the category search, influencer have the suffix blogger, media is banner partner, while those with google before hand are in the search category

--It is also important to note that this dataset is set in the month of february in the year 2021

--GENERAL ANALYTICS
-- Which campaign had the highest budget?
SELECT campaign_name, SUM(mark_spent) as marketing_spent
FROM marketing
GROUP BY campaign_name
ORDER BY marketing_spent DESC;
--banner_partner had the highest budget at 5026674.76 while facebook retargeting had 266466.22

--Which category had the highest budget?
SELECT category, SUM(mark_spent) as marketing_spent
FROM marketing
GROUP BY category
ORDER BY marketing_spent DESC;
--Social had the highest at 13798500.91 while search had the lowest at 3460400.07

-- Which campaign had the highest revenue?
SELECT campaign_name, SUM(revenue) as revenue
FROM marketing
GROUP BY campaign_name
ORDER BY revenue DESC;
--Youtube_blogger had the highest returns at 15311433 while facebook_lal had the lowest at 300233.0

-- Which category had the highest budget?
SELECT category, SUM(revenue) as revenue
FROM marketing
GROUP BY category
ORDER BY revenue DESC;
--Influencer had the highest revenue at 21,119,887 while search had the lowest at 3705065.0

--BUSINESS QUESTIONS
--1. Overall ROMI
SELECT ROUND(((SUM(revenue)-SUM(mark_spent))/SUM(mark_spent) * 100),2) as romi
FROM marketing;
--The overall romi was 40.2%

--2. ROMI by campaigns and categories
--a) by campaign_name
SELECT campaign_name, ROUND(((SUM(revenue)-SUM(mark_spent))/SUM(mark_spent) * 100),2) as romi
FROM marketing
GROUP BY campaign_name
ORDER BY romi DESC;
--Youtube_blogger had the highest at 277.32% while facebook_lal had the lowest at -88.64%

--b)by category
SELECT category, ROUND(((SUM(revenue)-SUM(mark_spent))/SUM(mark_spent) * 100),2) as romi
FROM marketing
GROUP BY category
ORDER BY romi DESC;
--Influencer had the highest at 154.29 while social had the lowest at -13.68

--3. Performance of the campaigns depending on the date
--a) On which date did we spend the most on advertising?
SELECT c_date, SUM(mark_spent) as marketing
FROM marketing
GROUP BY c_date
ORDER BY marketing DESC;
--20-02-2021 had the highest budget at 3499171.7 while the lowest was 2021-02-27 at 28902.73

--b) When we got the biggest revenue?
SELECT c_date, SUM(revenue) as revenue
FROM marketing
GROUP BY c_date
ORDER BY revenue DESC;
--The day with the highest returns was 20-02-2021 at 5261521 while 2021-02-27 also had the lowest returns

--c)When conversion rates were high or low?
--i)Visitors to leads
SELECT c_date, ROUND(SUM(leads)::NUMERIC/ SUM(clicks)::NUMERIC,3) as visitors_to_leads
FROM marketing
GROUP BY c_date
ORDER BY visitors_to_leads DESC;
--The day with the highest visitors to leads is 2021-02-10 at 0.028 while 2021-02-02 had the lowest at 0.013

--ii) Leads to orders
SELECT c_date, ROUND(SUM(orders)::NUMERIC/ SUM(leads)::NUMERIC,3) as leads_to_orders
FROM marketing
GROUP BY c_date
ORDER BY leads_to_orders DESC;
--The day with the highest leads to orders is 2021-02-25 at 0.150 while 2021-02-18 had the lowest at 0.090

--From the findings above the visitors to leads ratio at 2021-02-20 was 0.022 and leads to orders ratio was 0.127
--It is therefore evident that the high revenue that day was not due to new visitors but rather frequent customers

--Let us explore a bit more on 2021-02-20
SELECT campaign_name, SUM(impressions) as impressions, SUM(revenue) as revenue
FROM marketing
WHERE c_date = '2021-02-20'
GROUP BY campaign_name
ORDER BY impressions DESC, revenue DESC;
--youtube_blogger generated the highest revenue at 1,452,540 despite ranking 7th in terms of impressions earned that day
--facebook retargeting had the lowest impressions while facebook_lal generated least revenue at 17658

--d) Perfomance by campaign_names throughout the month
WITH grouped AS (
				SELECT c_date, campaign_name, SUM(impressions) as impressions
				FROM marketing
				GROUP BY c_date, campaign_name
				ORDER BY c_date, impressions DESC),
ranked AS (
		SELECT *, 
			  ROW_NUMBER() OVER(PARTITION BY c_date ORDER BY c_date, impressions DESC) as rn
		FROM grouped)
SELECT *
FROM ranked
WHERE rn = 1;
--banner_partner had the most impressions throughout the month being the first for 23 days

--e) What were the average order values?
--Overall
SELECT ROUND(SUM(revenue)/SUM(orders),2) as aov
FROM marketing;
--The average aov for the month was 5332.51

--dates
SELECT c_date,ROUND(SUM(revenue)/SUM(orders),2) as aov
FROM marketing
GROUP BY c_date
ORDER BY aov DESC;
--The day with the highest aov was 2021-02-25 at 6282.84 while 2021-02-10 had the lowest at 4203.95

--4) When are buyers more active?
SELECT ROUND(AVG(CASE WHEN EXTRACT(DOW FROM c_date) IN (1,2,3,4,5) THEN impressions END),2) AS weekday_impressions,
	   ROUND(AVG(CASE WHEN EXTRACT(DOW FROM c_date) IN (0,6) THEN impressions END),2) AS weekend_impressions
FROM marketing;
--Buyers were more active during weekdays with 2,925,363.62 more impressions than weekends on average

SELECT campaign_name,
	   ROUND(AVG(CASE WHEN EXTRACT(DOW FROM c_date) IN (1,2,3,4,5) THEN impressions END),2) AS weekday_impressions,
	   ROUND(AVG(CASE WHEN EXTRACT(DOW FROM c_date) IN (0,6) THEN impressions END),2) AS weekend_impressions
FROM marketing
GROUP BY campaign_name
ORDER BY weekday_impressions DESC;
--banner_partner generates most impressions on both weekdays and weekends

--5)What is the average revenue on weekdays and weekends?
SELECT ROUND(AVG(CASE WHEN EXTRACT(DOW FROM c_date) IN (1,2,3,4,5) THEN revenue END),2) AS weekday_revenue,
	   ROUND(AVG(CASE WHEN EXTRACT(DOW FROM c_date) IN (0,6) THEN revenue END),2) AS weekend_revenue
FROM marketing;
--Weekdays generated more revenue by 9,320.68 averagely

--6) Which geo locations are better for targeting?
SELECT CASE 
			WHEN campaign_name LIKE '%tier1' THEN 'tier_1'
			WHEN campaign_name LIKE '%tier2' THEN 'tier_2'
			ELSE 'no_tier'
		END AS tiers,
		SUM(revenue) as revenue,
		ROUND(((SUM(revenue)-SUM(mark_spent))/SUM(mark_spent) * 100),2) as romi
FROM marketing
GROUP BY CASE 
			WHEN campaign_name LIKE '%tier1' THEN 'tier_1'
			WHEN campaign_name LIKE '%tier2' THEN 'tier_2'
			ELSE 'no_tier'
		END;
--Tier_1 cities had a higher romi than tier_2 areas each having 35.29% and -28.23% respectively
--Marketing should then be doubled down on those areas since the company gets back its value for money

--Key performance indicators
--Since we have already calculated ROMI above we will continue with others below

--1. Click through rate
--a) by campaign_name
SELECT campaign_name, ROUND((SUM(clicks)::NUMERIC)/SUM(impressions),3) as ctr
FROM marketing
GROUP BY campaign_name
ORDER BY ctr DESC;
--Facebook_retargeting had the highest at 0.031 while banner_partner had the lowest at 0.00

--b) by category
SELECT category, ROUND((SUM(clicks)::NUMERIC)/SUM(impressions),3) as ctr
FROM marketing
GROUP BY category
ORDER BY ctr DESC;
--Influencer had the highest at 0.01 while media had the lowest 0.000

--2. cost per click(cpc)
--overall
SELECT ROUND((SUM(mark_spent)::NUMERIC)/SUM(clicks),2) as cpc
FROM marketing;
--overall was 10.20

--a) by campaign_name
SELECT campaign_name, ROUND((SUM(mark_spent)::NUMERIC)/SUM(clicks),2) as cpc
FROM marketing
GROUP BY campaign_name
ORDER BY cpc DESC;
--facebook_lal had the highest at 22.01 while instagram_tier2 had the lowest at 2.09

--b) by category
SELECT category, ROUND((SUM(mark_spent)::NUMERIC)/SUM(clicks),2) as cpc
FROM marketing
GROUP BY category
ORDER BY cpc DESC;
--Media has the highest at 11.97, while social had 9.20

--3. Visitors to leads
--Overall
SELECT ROUND(SUM(leads)::NUMERIC/ SUM(clicks)::NUMERIC,3) as visitors_to_leads
FROM marketing;
--Overall was 0.022

--a) by campaign_name
SELECT campaign_name, ROUND(SUM(leads)::NUMERIC/ SUM(clicks)::NUMERIC,3) as visitors_to_leads
FROM marketing
GROUP BY campaign_name
ORDER BY visitors_to_leads DESC;
--facebook_tier2 led at 0.026 while facebook_tier1 had the lowest at 0.015

--b) by category
SELECT category, ROUND(SUM(leads)::NUMERIC/ SUM(clicks)::NUMERIC,3) as visitors_to_leads
FROM marketing
GROUP BY category
ORDER BY visitors_to_leads DESC;
--Media had the highest at 0.024 while social had the lowest at 0.021

--4. Leads to orders
--a) by campaign_name
SELECT campaign_name, ROUND(SUM(orders)::NUMERIC/ SUM(leads)::NUMERIC,3) as leads_to_orders
FROM marketing
GROUP BY campaign_name
ORDER BY leads_to_orders DESC;
--facebook_retargeting had the highest at 0.213 while instagram_tier2 has the lowest at 0.030

--b) by category
SELECT category, ROUND(SUM(orders)::NUMERIC/ SUM(leads)::NUMERIC,3) as leads_to_orders
FROM marketing
GROUP BY category
ORDER BY leads_to_orders DESC;
--influencer had the highest at 0.178 while social had the lowest at 0.084

--5.Average order value
--a) by campaign_name
SELECT campaign_name, ROUND(SUM(revenue)/SUM(orders),2) as aov
FROM marketing
GROUP BY campaign_name
ORDER BY aov DESC;
--Youtube blogger had the highest at 7999.70 while facebook_lal had the lowest at 1021.20

--b) by category
SELECT category, ROUND(SUM(revenue)/SUM(orders),2) as aov
FROM marketing
GROUP BY category
ORDER BY aov DESC;
--influencer had the highest at 7007.26 while media had the lowest at 3929.09

--6.Cost per lead
SELECT ROUND(SUM(mark_spent)/SUM(leads),2) as cpl
FROM marketing;
--The average cpl was 466.47

--7.Customer acquisition cost
SELECT ROUND(SUM(mark_spent)/SUM(orders),2) as cac
FROM marketing;
--The average cac was 3803.42

--8. Gross profit/loss
SELECT SUM(revenue)-SUM(mark_spent) as gp
FROM marketing;
--The gross profit was 12298486.18

--a)by campaign
SELECT campaign_name,SUM(revenue)-SUM(mark_spent) as gp
FROM marketing
GROUP BY campaign_name
ORDER BY gp DESC;
--Youtube_blogger registered the highest profit at 11253496
--The following categories registered losses:
--facebook_tier1 -168381.48
--instagram_tier2 -395693.75
--google_wide  -761083.31
--facebook_tier2 -1230564.97
--facebook_lal -2341706.24

--b)by category
SELECT category,SUM(revenue)-SUM(mark_spent) as gp
FROM marketing
GROUP BY category
ORDER BY gp DESC;

--influencer had the highest profit at 12814582 while social has the lowest at -1887046.91

--Recommendations
--1. Marketing budget to be invested more in influencers as they generate highest romi
--2. Tier_1 cities to receive more targeting
--3. facebook_lal seems to be generating the lowest at -88.64% while the campaign before it having an romi -37.11%
--facebook_lal is losing alot of money and the company should consider reducing marketing campaigns toward it and invest more money
--in facebook_retargeting and instagram_tier1.
--facebook_tier1 has a romi of -6.57% which is below the romi of cities in tier1 which is 35.29%, this leads to -168k loss.
--I recommend the budget to be reduced and test out new ad campaigns before cutting budget completely.
--4. instagram_tier2 has the lowest leads to orders rate while the geo location also underperforming.The budget should be redirected to instagram_tier1
--5. In the search category google_hot generates a romi of 83.81% while google_wide generates -33.67%, the company should consider investing
--more money on google_hot
--6. Banner_partner despite having most impressions and biggest marketing budget has the lowest romi at 22.41, I reckon the budget should be reduced here
--reinvested elsewhere and urge the company to negotiate better placement to improve ctr


