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

Since the storage on Github is limited I opted to provide the above mentioned *.csv files through a link, which can be found here: `Database-Tables/link-to-database-tables`

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
I recommend creating a separate AWS Lambda function only for the current weather forecast, as this will be updated on a daily basis.

Create the respective Lambda functions and copy the appropriate code from the ZIP-files in the folder /`Lambda functions` (don't forget to insert your MySQL endpoint and API credentials).

The ZIP file contain the code for the Lambda function:

- `ETL-Pipeline/Lambda-Function/daily_weather_forecast.zip` creates the DataFrames for the tables `current_weather_daily.csv`and `current_weather_hourly.csv` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench

- Add your layer (see Prerequisites) to the function.
- Create an EventBridge schedule. There is a short tutorial [here](https://www.youtube.com/watch?v=lSqd6DVWZ9o&t).

# 2. City Weather Prediction using SLTM Model

This repository contains code for a City Weather Prediction model using an LSTM-based Sequential Learning Time Model (SLTM) implemented in TensorFlow. The model predicts daily maximum temperature and precipitation for multiple cities based on historical weather data. Here's a brief overview of the code and its functionalities:

## 2.1 Data Collection
The code collects historical weather data for target cities using an API and a provided CSV file (`cities_data_cls_ele.csv`). It retrieves data for various weather parameters, including maximum temperature, minimum temperature, mean temperature, precipitation, rain, snowfall, windspeed, shortwave radiation, and evapotranspiration.

## 2.2 Data Preprocessing
The collected data is preprocessed, including:
- Scaling and one-hot encoding of selected features.
- Encoding time variables such as day of the year and year.
- Splitting the data into training, validation, and test sets.

## 2.3 Model Architecture
The SLTM model architecture consists of two LSTM layers followed by Dense layers for regression. The model is trained to predict daily maximum temperature and precipitation.

## 2.4 Training and Evaluation
The model is trained using the training and validation datasets. It uses Mean Squared Error (MSE) loss and Root Mean Squared Error (RMSE) as a metric for evaluation. A ModelCheckpoint callback is used to save the best model during training.

## 2.5 Model Deployment
The trained model can be saved and deployed for making predictions on future weather data. It can be loaded using `load_model` from TensorFlow.

## 2.6 Post-processing
The code includes post-processing functions to adjust the predicted temperature and precipitation using reference historical data. It applies corrections for trends, variability, and extreme events in the predictions.

## 2.7 Model Evaluation
The code also provides functionality to evaluate the model's performance using various metrics such as MAE, RMSE, R-squared, and Nash-Sutcliffe Efficiency.

## 2.8 Future Predictions
The model can be used to make predictions on future weather data for the target cities.

For usage instructions and further details, please refer to the code files:

- [FP_for_upload_final.ipynb](FP_for_upload_final.ipynb): Jupyter Notebook containing the code.
- [FP_for_upload_final.py](FP_for_upload_final.py): Python script version of the code.
- [requirements.txt](requirements.txt): Required packages and dependencies.
- [best_model.h5](best_model.h5): The trained model.
- [cities_data_cls_ele.csv](cities_data_cls_ele.csv): Historical weather data CSV file.

Please refer to these files for implementation details and usage instructions.


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

