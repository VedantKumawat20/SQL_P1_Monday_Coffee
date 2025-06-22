# SQL_P1_Monday_Coffee
### Data Analysis Project 1 (SQL)

### Table of Contents
[Background and Overview](#1-Background-and-Overview-)
<br>
[Data Sources](#2-Data-Sources-)
<br>
[Tools](#3-Tools-)
<br>
[Data Cleaning/Preparation](#4-Data-Cleaning/Preparation-)
<br>
[Data Structure Overview](#5-Data-Structure-Overview-)
<br>
[Recommendations](#6-Recommendations-)


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
#### Customers Data--  "customers.csv" file, containing detailed information about their each current cutomer's name, id, and city id they belong to.
#### Products Data--  "products.csv" file, containing detailed information about each product company offers.
#### City Data--  "city.csv" file, containing detailed information about each city where Monday Coffee operates.

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

(Prior to begnning the analysis, a variety of checks were conducted for quality control and famaliarization with the dataset.)

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
Consider Jaipur for cost-efficient warehousing or logistics hub. Runing targeted loyalty and
referral programs could increase average order value.

#### Nagpur, Kanpur, Indore, Lucknow - Low-Priority or Watchlist Cities

- Low estimated customer base and/or low average sales per customer
- High cost-to-revenue ratio if expanded prematurely
  
#### Recommendation:
Maintain limited marketing presence. Focus on digital-only sales while monitoring market
trends and consumer behavior.

---
##### [The results are generated from the execution of queries within the SQL file. The outputs below correspond to the results of the SQL queries. The question numbers align with those in the SQL file.]

Q1
![PQ1](https://github.com/user-attachments/assets/80b9bd12-09d3-4b34-a348-cdf5f8912594)

Q2
![PQ2](https://github.com/user-attachments/assets/532a3ee1-8a1a-41bc-a603-f70af2c2a1dc)

Q3
![PQ3](https://github.com/user-attachments/assets/85a9c257-c4e0-439a-a81a-05875c00479a)

Q4
![PQ4](https://github.com/user-attachments/assets/0b90f594-437a-43ab-88d5-b8f70d2ab6a0)

Q5
![PQ5](https://github.com/user-attachments/assets/401cfafa-da94-4d19-9be2-251e7b469cbe)

Q6
![PQ6](https://github.com/user-attachments/assets/f649550d-26d9-4d42-851f-1c7d9a1087ee)

Q7
![PQ7](https://github.com/user-attachments/assets/d55e693f-e4d5-4dcb-b844-c76518bf5e3a)

Q8
![PQ8](https://github.com/user-attachments/assets/26718581-3de2-4fb9-bc56-5490d2dee0d0)

Q10
![PQ10](https://github.com/user-attachments/assets/230c5d4a-68a8-44b3-b622-3ec31af1c9cb)








