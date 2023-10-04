# End-to-end-ETL-ML-Tableau
End to end weather prediction - from an ETL Pipeline through Machine Learning to Tableau Visualisation


In a nutshell, this is an end to end project for extracting data (historical weather (once), current weather (on a daily basis through a Lambda function) and future weather (once; Max Planck Institute Earth System Model (MPI-ESM1.2)) to compare it with our own model (see Machine Learning part)) from an API, transforming the data and loading it into a MySQL database on AWS RDS. 
The historical weather data (from 1940/01/01 onwards) will then be used to train a machine learing model which will be used to predict the future weather (temperature and precipitation) up until 2050/12/31 (in the comparison to MPI-ESM1.2).

## 1. ETL Pipeleine

To create an automated ETL pipeline on the cloud using Python and MySQL on AWS (RDS, Lambda, and EventBridge). The project is designed to gather weather data through API calls: 

* API calls for [historical weather data](https://open-meteo.com/en/docs/historical-weather-api), [current weather forecast](https://open-meteo.com/en/docs) and [future weather data](https://open-meteo.com/en/docs/climate-api)

In the folder /`ETL-Pipeleine` you will find the python code notebook for the data extraction, transformation and loading into MySQL instance on AWS RDS, as well as comments to the code.

The folder `/Database-Tables` contains the file `jam_database_setup_short.sql` which sets up the SQL database on AWS RDS. you will also find the file `jam_database_user_setup_short.sql` as an example on how to set up users for your AWS RDS instance without going through AWS IAM. 
All data is stored in a relational database containing the following tables: 
* `cities_data.csv` (data such as longitude, latitude and population for over 44.000 cities),
* `future_weather_jam.csv` (predicted future weather data from our trained model),
* `future_weather_mpi.csv` (predicted future weather data from MPI-ESM1.2),
* `future_weather_jam_mpi.csv` (predicted future weather data from MPI-ESM1.2 and our trained model) ,
* `historical_weather.csv` (historical weather data from 1940/01/01 until 2022/12/31), as well as
* `current_weather_daily_20230927.csv` (weather forecast from 2023/09/27 - daily) and
* `current_weather_hourly_20230927.csv` (weather forecast from 2023/09/27 - hourly).

## 1.1. Prerequisites
To run this project, you need an AWS account to run the project in the cloud.

__WARNING:__ Free tier options are available for AWS, but costs may occur when choosing the wrong payment plan or exceeding limits. __I am not responsible for any costs.__

- Set up your AWS credentials and ensure you have the necessary permissions to create and manage AWS resources.

Create a new layers in AWS Lambda with the following ARNs:

* `pandas` --> arn:aws:lambda:eu-north-1:336392948345:layer:AWSSDKPandas-Python310:3
* `requests` --> arn:aws:lambda:eu-north-1:770693421928:layer:Klayers-p310-requests:3
* `SQLAlchemy` --> arn:aws:lambda:eu-north-1:770693421928:layer:Klayers-p39-SQLAlchemy:14

Or just import all the prerequistites from `ETL-Pipeline/Lambda-Function/daily_weather_forecast.yaml`

## 1.2. Usage

### 1.2.1. Setting up AWS Lambda functions
- I recommend creating separate AWS Lambda functions for different update schedules:
  - Update city and airport information - only needs to run if a new city was added to the database manually.
  - Update city information - should be updated yearly; older information will be stored with the respective year.
  - Update weather and arrival flights - should be updated on a daily basis to retrieve information for the next day.

Create the respective Lambda functions and copy the appropriate code from the ZIP-files in the folder /`Lambda functions` (don't forget to insert your MySQL endpoint and API credentials).

The ZIP file contain the different code for the Lambda functions:

- `static_tables.zip` creates the DataFrames for the tables `city_table`, `airport_table` and `city_airport_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `city_data_web_scraping.zip` web scrapes data for the cities in the the list from Wikipedia, creates a DataFrame for the table `city_data_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `weather_data_api_call.zip` creates the DataFrames for the table `weather_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `arrivals_data_api_call.zip` creates the DataFrames for the table `arrivals_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `all_in_one_weather_arrivals.zip` creates the DataFrames for the tables `arrivals_table` and `weather_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench <-- this Lambda function is a combination of `arrivals_data_api_call.zip` and `weather_data_api_call.zip` and does exactly the same as the two seperate functions. As the data extracted with these functions is to be updated daily, you can run this one function instead of the two separate ones.

- Add your layer (see Prerequisites) to the function.
- Create an EventBridge schedule. There is a short tutorial [here](https://www.youtube.com/watch?v=lSqd6DVWZ9o&t).

## 3. Tableau Dashboard for Weather Data

_Version: Tableau Desktop 2023.2.1_

The interactive dashboard offers a comprehensive view of weather conditions, providing valuable insight.

**Dashboard Highlights:**

-	Current Weather: At the top of the dashboard, you'll find real-time data displaying the current day's temperature and hourly precipitation.
-	Averages: The top left and right sections feature average temperature and precipitation data, giving you a quick overview.

**What Makes Our Weather Forecast Unique:**

Diving deeper, the bottom part of the dashboard sets our weather forecast apart from the typical ones:

-	Historical Weather: On the left side, you can explore the historical weather forecast for the exact same day, but 20 years in the past. To enhance clarity, precipitation data for this period is color-coded, making it easier to understand the amounts in millimeters.
-	Future Predictions: On the right side, you'll find our model's predictions for the next 20 years, all for this very day. Similar to the historical data, the highest predicted temperature is displayed as a numerical value.

This dashboard offers a unique perspective on weather data, allowing you to compare current conditions, historical trends, and future forecasts seamlessly in one place. 
For usage instructions and more information, please refer to the Tableau Desktop 2023.2.1 documentation.

