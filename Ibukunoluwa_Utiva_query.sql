/* Utiva Data Competition
*/
-- Name: Ibukunoluwa Jeremiah Ajoh

Drop Database if exists Breweries;
CREATE DATABASE IF NOT EXISTS Breweries;
USE Breweries;

Drop table if exists sales;
CREATE TABLE IF NOT EXISTS sales (
    sales_id SMALLINT NOT NULL AUTO_INCREMENT,
    sales_rep VARCHAR(25) NOT NULL,
    email VARCHAR(25) DEFAULT NULL,
    brands VARCHAR(25) NOT NULL,
    plant_cost SMALLINT NOT NULL,
    unit_price SMALLINT NOT NULL,
    quantity SMALLINT NOT NULL,
    cost INT NOT NULL,
    profit INT NOT NULL,
    countries VARCHAR(25) NOT NULL,
    region VARCHAR(25) NOT NULL,
    months ENUM('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December') NOT NULL,
    years INT NOT NULL,
    PRIMARY KEY (sales_id)
);

/* Importing  International Breweries csv file into the Database
*/
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/International_Breweries (1).csv"
into table sales
fields terminated by ","
enclosed by ""
lines terminated by "\n"
ignore 1 rows;


# SECTION A 
# PROFIT ANALYSIS

#1. SUM TOTAL OF PROFIT FOR THE LAST THREE YEARS

SELECT 
    SUM(profit) AS Total_Profit
FROM
    sales;

#2. Comparing Profit between Anglophone territories and Francophone territories fro Strategic Decision making. 
/* Anglophone countries (English speaking Countries) in the dataset - Ghana and Nigeria
Francophone Countries (Franch Speaking Countries) in the dataset - Togo, Senegal and Benin
*/

SELECT 
    CASE
        WHEN countries IN ('Ghana' , 'Nigeria') THEN 'Anglophone Countries'
        ELSE 'Francophone Countries'
    END AS Territory,
    SUM(profit) AS Total_Profit
FROM
    sales
GROUP BY Territory;

#3 Country that generated the highest profit in 2019 

SELECT 
    countries AS Country_With_Highest_profit,
    SUM(profit) AS Profit
FROM
    sales
WHERE
    years = 2019
GROUP BY countries
ORDER BY profit DESC
LIMIT 1;

#4. Help him find the year with the highest profit.

SELECT 
    years AS Year_with_Highest_profit, SUM(profit) AS Profit
FROM
    sales
GROUP BY years
ORDER BY profit DESC
LIMIT 1;

#5. Which month in the three years were the least profit generated?

SELECT 
    months AS Month_with_least_profit, SUM(profit) AS Profit
FROM
    sales
GROUP BY months
ORDER BY profit ASC
LIMIT 1
;

#6. What was the minimum profit in the month of December 2018? 

SELECT 
    profit AS Minimum_Profit_for_December_2018
FROM
    sales
WHERE
    months = 'December' AND years = 2018
ORDER BY profit ASC
LIMIT 1;

#7. Compare the profit in percentage for each of the month in 2019 

SELECT 
    months,
    ROUND(SUM(profit) / (SELECT 
                    SUM(profit)
                FROM
                    sales
                WHERE
                    years = 2019) * 100,
            2) AS Percentage_profit
FROM
    sales
WHERE
    years = 2019
GROUP BY months
ORDER BY months;

#8. Which particular brand generated the highest profit in Senegal? 

SELECT 
    brands AS Brand_with_Highest_Profit, SUM(profit) AS Profit
FROM
    sales
WHERE
    countries = 'Senegal'
GROUP BY brands
ORDER BY profit DESC
LIMIT 1;

#--------------------------------------------------------------------------------------------------------------
# SECTION B
# BRAND ANALYSIS

#1. Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries 

SELECT 
    brands AS TOP_THREE_BRANDS, SUM(quantity) AS Quantity
FROM
    sales
WHERE
    countries IN ('Togo' , 'Senegal', 'Benin')
        AND years IN (2018 , 2019)
GROUP BY brands
ORDER BY Quantity DESC
LIMIT 3;

#2. Find out the top two choice of consumer brands in Ghana 

SELECT 
    brands AS TOP_TWO_CUSTOMER_BRAND, sum(quantity) as QTY
FROM
    sales
where countries = 'Ghana'
GROUP BY brands
ORDER BY sum(quantity) DESC
LIMIT 2;

#3. Find out the details of beers consumed in the past three years in the most oil reach country in West Africa.
#Details

SELECT 
    sales_rep,
    email,
    countries AS Countries,
    brands AS Beers,
    SUM(quantity) AS QTY,
    cost,
    profit
FROM
    sales
WHERE
    brands NOT LIKE ('%malt%')
        AND countries IN ('Nigeria')
GROUP BY brands
ORDER BY countries;

#4. Favorites malt brand in Anglophone region between 2018 and 2019 

SELECT 
    brands AS FAVORITE_BRAND
FROM
    sales
WHERE
    countries IN ('Ghana' , 'Nigeria')
        AND years IN (2018 , 2019)
        AND brands LIKE ('%malt%')
GROUP BY brands
ORDER BY SUM(quantity) DESC
LIMIT 2;

#5. Which brands sold the highest in 2019 in Nigeria?

SELECT 
    brands AS BRAND_WITH_HIGHEST_SALES,
    SUM(quantity) AS Quantity
FROM
    sales
WHERE
    countries = 'Nigeria' AND years = 2019
GROUP BY brands
ORDER BY SUM(quantity) DESC
LIMIT 1;

#6. Favorites brand in South_South region in Nigeria  

SELECT 
    brands, SUM(quantity) AS quantity
FROM
    sales
WHERE
    region = 'southsouth'
        AND countries = 'Nigeria'
GROUP BY brands
ORDER BY quantity DESC
LIMIT 1;

#7. Beer consumption in Nigeria

SELECT 
    SUM(quantity) AS Beer_Quantity_Consumed_in_Nigeria
FROM
    sales
WHERE
    countries = 'Nigeria'
        AND brands NOT LIKE ('%malt%');

#8. Level of consumption of Budweiser in the regions in Nigeria 

SELECT 
    region AS Region,
    ROUND(SUM(quantity) / (SELECT 
                    SUM(quantity)
                FROM
                    sales
                WHERE
                    countries = 'Nigeria'
                        AND brands = 'budweiser') * 100,
            2) AS Budweiser_Consumption_level
FROM
    sales
WHERE
    countries = 'Nigeria'
        AND brands = 'budweiser'
GROUP BY region
ORDER BY SUM(quantity) DESC;

#9. Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)

SELECT 
    region AS Region,
    ROUND(SUM(quantity) / (SELECT 
                    SUM(quantity)
                FROM
                    sales
                WHERE
                    countries = 'Nigeria'
                        AND brands = 'budweiser'
                        AND years = 2019) * 100,
            2) AS Budweiser_Consumption_level
FROM
    sales
WHERE
    countries = 'Nigeria'
        AND brands = 'budweiser'
        AND years = 2019
GROUP BY region
ORDER BY Budweiser_Consumption_level DESC;

#------------------------------------------------------------------------------------------------------------
# SECTION C
# COUNTRIES ANALYSIS

#1. Country with the highest consumption of beer.

SELECT 
    countries AS Country_with_highest_beer_Consumption
FROM
    sales
WHERE
    brands NOT LIKE ('%malt%')
GROUP BY countries
ORDER BY SUM(quantity) DESC
LIMIT 1;

#2. Highest sales personnel of Budweiser in Senegal 

SELECT 
    sales_rep AS HIGHEST_SALES_PERSONNEL_of_Budweiser
FROM
    sales
WHERE
    countries = 'Senegal'
        AND brands = 'budweiser'
GROUP BY HIGHEST_SALES_PERSONNEL_of_Budweiser
ORDER BY SUM(quantity) DESC
LIMIT 1;

#3. Country with the highest profit of the fourth quarter in 2019

SELECT 
    countries AS Country_with_Highest_Profit
FROM
    sales
WHERE
    years = 2019
        AND months IN ('October' , 'November', 'December')
GROUP BY countries
ORDER BY SUM(profit) DESC
LIMIT 1; 
        