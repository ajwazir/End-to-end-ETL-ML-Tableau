-- DROP DATABASE jam_fp_db;
CREATE DATABASE jam_fp_db;

USE jam_fp_db;

-- DROP TABLE cities_data;
CREATE TABLE cities_data (
	city_id INT PRIMARY KEY AUTO_INCREMENT,
    city_name VARCHAR(255),
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    country VARCHAR(255),
    population DECIMAL(15, 6)
);

-- DROP TABLE historical_weather;
CREATE TABLE historical_weather (
	city_id INT,
    city_name VARCHAR(255),
    date_time DATETIME,
    weather_code INTEGER,
    temperature_avg DECIMAL(5, 2),
    temperature_min DECIMAL(5, 2),
    temperature_max DECIMAL(5, 2),
    wind_speed DECIMAL(5, 2),
    shortwave_radiation DECIMAL(5, 2),
    precipitation DECIMAL(5, 2),
    rain DECIMAL(5, 2),
    snowfall DECIMAL(5, 2),
    FOREIGN KEY (city_id) REFERENCES cities_data(city_id)
);

-- DROP TABLE current_weather_hourly;
CREATE TABLE current_weather_hourly (
	city_id INT,
    city_name VARCHAR(255),
    date_time DATETIME,
    weather_code INTEGER,
    temperature DECIMAL(5, 2),
    humidity INT,
    precipitation DECIMAL(5, 2),
    rain DECIMAL(5, 2),
    snowfall DECIMAL(5, 2),
    surface_pressure DECIMAL(5, 2),
    cloudcover INTEGER,
    visibility DECIMAL(5, 2),
    evapotranspiration DECIMAL(5, 2),
    wind_speed DECIMAL(5, 2),
    wind_direction DECIMAL(5, 2),
    FOREIGN KEY (city_id) REFERENCES cities_data(city_id)
);

-- DROP TABLE current_weather_daily;
CREATE TABLE current_weather_daily (
	city_id INT,
    city_name VARCHAR(255),
    date_time DATETIME,
    weather_code INTEGER,
    temperature_min DECIMAL(5, 2),
    temperature_max DECIMAL(5, 2),
    temperature_avg DECIMAL(5, 2),
    precipitation DECIMAL(5, 2),
    rain DECIMAL(5, 2),
    snowfall DECIMAL(5, 2),
    shortwave_radiation DECIMAL(5, 2),
    wind_speed DECIMAL(5, 2),
    FOREIGN KEY (city_id) REFERENCES cities_data(city_id)
);

-- DROP TABLE future_weather_mpi;
CREATE TABLE future_weather_mpi (
	city_id INT,
    city_name VARCHAR(255),
    date_time DATETIME,
    temperature_avg DECIMAL(5, 2),
    temperature_min DECIMAL(5, 2),
    temperature_max DECIMAL(5, 2),
    wind_speed DECIMAL(5, 2),
    shortwave_radiation DECIMAL(5, 2),
    precipitation DECIMAL(5, 2),
    rain DECIMAL(5, 2),
    snowfall DECIMAL(5, 2),
    evapotranspiration DECIMAL(5, 2),
    FOREIGN KEY (city_id) REFERENCES cities_data(city_id)
);

-- DROP TABLE future_weather_jam;
CREATE TABLE future_weather_jam (
	city_id INT,
    city_name VARCHAR(255),
    date_time DATETIME,
    temperature DECIMAL(5, 2),
    precipitation DECIMAL(5, 2),
    FOREIGN KEY (city_id) REFERENCES cities_data(city_id)
);

-- DROP TABLE future_weather_jam_mpi;
CREATE TABLE future_weather_jam_mpi (
	city_id INT,
    city_name VARCHAR(255),
    date_time DATETIME,
    temperature_jam DECIMAL(5, 2),
    precipitation_jam DECIMAL(5, 2),
    temperature_mpi DECIMAL(5, 2),
    precipitation_mpi DECIMAL(5, 2),
    FOREIGN KEY (city_id) REFERENCES cities_data(city_id)
);