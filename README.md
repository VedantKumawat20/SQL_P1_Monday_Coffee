# SQL_P1_Monday_Coffee
### Data Analysis Project 1 (SQL)
This study uses SQL to…
<br>
The goal is to predict which….

### Table of Contents
[Background and Overview](1.-Background-and-Overview)
<br>
[Data Sources](2.Data-Sources-)
<br>
[Tool](#3.-Tools-)
<br>
[Data Cleaning/Preparation](4.Data-Cleaning/Preparation-)
<br>
[Data Structure Overview](5.Data-Structure-Overview-)
<br>
[Recommendations](6.Recommendations-)
<br>
[References](7.References-)

### 1. Background and Overview-
#### Project Background--
Monday Coffee, established in January 2023, has successfully sold its products online and received an overwhelmingly positive respone in several cities.
<br>
The company has significant amounts of data on its sales, product offerings, cities, and customers details. This project throughly analyzes and synthesizes this data in order to uncover critical insights that will improve Monday_coffee commercial success.

#### Overview--
##### Insights and recommendations are provided on the following key areas:

##### Sales Trends Analysis: 
1.	Total revenue from coffee sales- all cities in Q of 2023.
2.	Impact of estimated rent on sales – find each city and their average sale per customer and avg rent per customer.
3.	Monthly sales growth – sales growth rate – calculate the percentage growth (or decline) in sales over different time periods (monthly).
4.	Market potential analysis – Identify top 3 cities based on highest sales. return - city, name, total sale, total rent, total customers, estimated coffee customer

##### Product level performance:
1.	Sales count for each products- how many units of each coffee products have been sold?

##### Regional Comparisons:
1.	An evaluation of sales and orders by region.
2.	People estimated to consume coffee in each city.
3.	Average sales amount per city – what is average sales amount per customer in each city?
4.	Top selling products by city – top 3 selling products in each city based on sales volume
5.	Customer segmentation by city – unique customers are there in each city who have purchased coffee products

#### Objective--
The goal of this project is to analyze the sales data of Monday Coffee, and to recommend the top three major cities in India for opening new coffee shop locations based on consumer demand and sales performance.

### 2. Data Sources-
#### Sales Data--  The primary dataset used for this analysis is the "sales_sql.csv" file, containing detailed information about each sale made by the company.
#### Customers Data--
#### Products Data--
#### City Data--

### 3. Tools-
- Excel - Data Cleaning/Transfromation
- MySQL Workbench - Data Analysis

### 4. Data Cleaning/Preparation-
#### In the initial data preparation phase, we performed the following tasks:
- Data loading and inspection.
- Data cleaning and formating.

### 5.	Data Structure Overview-
EER Diagram
<br>
Monday coffee data structure as seen below consists of four tables: sales, customers, products, and city with a total row count of 10,927.
![Screenshot (112)](https://github.com/user-attachments/assets/d9f2c697-43a2-4c75-a928-caa88b3b9bd5)

(Prior to begnning the analysis, a variety of checks were conducted for quality control and famaliarization with the dataset. The SQL quaries utilized to instep and perform quality check can be found here.)

### 6. Recommendations-
Based on the analysis, we recommend the following actions:

#### Pune - Ideal Expansion Market

##### Rationale:
- Highest average sales per customer
- 1st highest in total revenue
- Strong current customer base
- low rent among cities with high revenue
  
##### Recommendation: 
Prioritize Pune for expansion, new product launches, and marketing campaigns. Consider
setting up a flagship store or warehouse to leverage both high sales and low costs.

#### Chennai - Strategic Growth Opportunity

##### Rationale:
- 2nd highest in both average sales per customer and overall revenue
- Good potential based on estimated number of coffee consumers
  
##### Recommendation: 
Strengthen brand visibility in Chennai through influencer marketing and localized
campaigns. Explore partnership with delivery platforms to scale last-mile sales.

#### Jaipur - High-Potential Emerging Market

##### Rationale:
- Lowest average rent per customer across cities with high revenue
- Highest number of active current customers
- Solid performance in both sales and revenue/ Average sales per customer is better
  
##### Recommendation:
Consider Jaipur for cost-efficient warehousing or logistics hub. Run targeted loyalty and
referral programs to increase average order value.

#### Nagpur, Kanpur, Indore, Lucknow - Low-Priority or Watchlist Cities

- Low estimated customer base and/or low average sales per customer
- High cost-to-revenue ratio if expanded prematurely
  
#### Recommendation:
Maintain limited marketing presence. Focus on digital-only sales while monitoring market
trends and consumer behavior.

### 7. References-
[YT1](https://youtu.be/ZZEP4ZRnDaU?si=7l5_xzD22_3q3MGK)



