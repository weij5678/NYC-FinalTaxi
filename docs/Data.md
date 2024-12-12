---
layout: default   # This tells Jekyll to use the default layout (from the theme)
title: "Data Description" # Title of the page
---
[Home](index.md) / [Data](Data.md) / [Methodology](Methodology.md) / [Results](Results.md) / [Conclusion](Conclusions.md)


# **Data Description**

## **Dataset Background**
- This project utilizes high-volume for-hire vehicle (FHV) or taxi trip data in New York City from **October 15, 2023, to November 15, 2023**, focusing on trips that occurred at three specific times:
   - **8:00-8:03 AM (Morning)**
   - **12:00-12:03 PM (Noon)**
   - **6:00-6:03 PM (Evening)**
- These time windows were selected to capture key parts of the day (morning, midday, evening) while reducing the overall dataset size.
- Since the full dataset includes millions of trips, limiting the data to these specific times helps ensure a manageable dataset for analysis. In addition, the dataset contains 36 variables after cleaning the data which provide detailed information on pickup locations, timestamps, and various meteorological conditions during each trip.
- The goal is to explore potential relationships between weather patterns and ride-hailing demand across NYC, identifying spatial and temporal clusters that may help optimize taxi operations.

---

## **Key Steps for Data Cleaning and Pre-Processing**
The dataset contains **6,939 observations**, each representing a three minute interval of ride-hiring activity starting from the pickup times. Each trip is linked to weather data based on the pickup location's latitude and longitude, retrieved through the Meteostat database. Each case is linked to meteorological data based on the trip's pickup location, which was geocoded using Google Maps API. Weather conditions, including temperature, wind speed, and precipitation, were sourced from the Meteostat API. 

1. **Filtering Data to Specific Time Points**:  
   Given the large size of the original dataset, which includes trips recorded every minute throughout the day, the analysis focuses on three specific time points—**8:00 AM, 12:00 PM, and 6:00 PM**—for a selected month, from mid-October to mid-November. This period was chosen due to its high variability in weather conditions, providing an opportunity to explore how weather impacts ride-hailing behavior while minimizing the number of observations. These times were selected to represent key periods of the day when ride-hailing activity is likely to fluctuate based on traffic patterns and other factors.

2. **Geolocation Lookup**:  
   Pickup location IDs were mapped to geographic coordinates (latitude, longitude) using the NYC Taxi Zone dataset and Google Maps Geocoding API.
   
3. **Merging Weather Data**:  
   Weather data (temperature, wind speed, precipitation) was merged based on the geolocated pickup location and time using the Meteostat dataset.

4. **Handling Missing Data**:  
   Variables such as `snow`, `wpgt`, and `tsun` had many missing values. These columns were removed altogether as there were too many missing values for the variable to be meaningful.

5. **Time of Day Labeling**:  
   To make for a more interpretable analysis, a new categorical variable `PeriodOfDay` (Morning, Midday, Evening) derived from the `pickup_datetime` was added to the dataset to better analyze temporal patterns.

6. **Created New Tip_Percentage Variable**:
   To make a more meaningful interpretation of tips, a new quantative varirable `tip_percentage` was derived from dividing tips by base passenger fare (tips/base passenger fare*100) to better analyzing tipping trends.

7. **Created New IsRaining Variable**:
    To make a more meaningful interpretation of weather conditions, a new quantative varirable `IsRaining` was derived from collapsing the `WeatherCondition` into a binary variable (Raining or Not Raining).
---

## **Variable Descriptions**


| Variable Name          | Variable Label                                           | Valid Range/Code                                | Source                          |
|------------------------|----------------------------------------------------------|-------------------------------------------------|---------------------------------|
| `hvfhs_license_num`     | License number of the FHV service                       | Text                                             | NYC FHV Data                   |
| `dispatching_base_num`  | Dispatch base number of the FHV                         | Text                                             | NYC FHV Data                   |
| `request_datetime`      | Date and time when the FHV was requested                | Datetime format: `YYYY-MM-DD HH:MM:SS`           | NYC FHV Data                   |
| `pickup_datetime`       | Date and time when the trip began                       | Datetime format: `YYYY-MM-DD HH:MM:SS`           | NYC FHV Data                   |
| `dropoff_datetime`      | Date and time when the trip ended                       | Datetime format: `YYYY-MM-DD HH:MM:SS`           | NYC FHV Data                   |
| `pulocationid`          | Pickup location ID                                      | Integer, range: `1` to `263`                     | NYC FHV Data                   |
| `dolocationid`          | Dropoff location ID                                     | Integer, range: `1` to `263`                     | NYC FHV Data                   |
| `trip_miles`            | Distance covered during the trip (miles)                | Decimal, range: `0` to `100`                     | NYC FHV Data                   |
| `trip_time`             | Duration of the trip (seconds)                          | Integer, range: `0` to `5000`                    | NYC FHV Data                   |
| `base_passenger_fare`   | Fare paid by the passenger (USD)                        | Decimal, range: `0` to `500`                     | NYC FHV Data                   |
| `tolls`                 | Tolls charged during the trip (USD)                     | Decimal, range: `0` to `100`                     | NYC FHV Data                   |
| `bcf`                   | Black car fund fee                                      | Decimal, range: `0` to `10`                      | NYC FHV Data                   |
| `sales_tax`             | Sales tax applied to the trip (USD)                     | Decimal, range: `0` to `50`                      | NYC FHV Data                   |
| `congestion_surcharge`  | Congestion surcharge applied to the trip (USD)          | Decimal, range: `0` to `5.75`                    | NYC FHV Data                   |
| `airport_fee`           | Fee for airport dropoffs (USD)                          | Decimal, range: `0` to `10`                      | NYC FHV Data                   |
| `tips`                  | Tips given by the passenger (USD)                       | Decimal, range: `0` to `100`                     | NYC FHV Data                   |
| `driver_pay`            | Pay received by the driver (USD)                        | Decimal, range: `0` to `1000`                    | NYC FHV Data                   |
| `shared_request_flag`   | Indicates if a shared ride was requested                | Categorical: `Yes`, `No`                         | NYC FHV Data                   |
| `shared_match_flag`     | Indicates if a shared ride match was found              | Categorical: `Yes`, `No`                         | NYC FHV Data                   |
| `wav_request_flag`      | Indicates if a wheelchair-accessible ride was requested | Categorical: `Yes`, `No`                         | NYC FHV Data                   |
| `wav_match_flag`        | Indicates if a wheelchair-accessible ride was matched   | Boolean: `True`, `False`                         | NYC FHV Data                   |
| `temp`                  | Temperature at pickup location (°C)                     | Decimal, range: `-10` to `35`                    | Meteostat Data                 |
| `dwpt`                  | Dew point temperature at pickup location (°C)           | Decimal, range: `-10` to `35`                    | Meteostat Data                 |
| `rhum`                  | Relative humidity at pickup location (%)                | Decimal, range: `0` to `100`                     | Meteostat Data                 |
| `prcp`                  | Precipitation at pickup location (mm)                   | Decimal, range: `0` to `50`                      | Meteostat Data                 |
| `wdir`                  | Wind direction at pickup location (degrees)             | Integer, range: `0` to `360`                     | Meteostat Data                 |
| `wspd`                  | Wind speed at pickup location (km/h)                    | Decimal, range: `0` to `100`                     | Meteostat Data                 |
| `pres`                  | Atmospheric pressure at pickup location (hPa)           | Decimal, range: `900` to `1050`                  | Meteostat Data                 |
| `WeatherCondition`      | Textual description of weather condition                | Text: Clear, Cloudy, Light Rain, etc.            | Meteostat Data                 |
| `PeriodOfDay`           | Time of day the trip occurred                           | Text: Morning, Midday, Evening                   | Derived from `pickup_datetime` |
| `puloc_lat`             | Latitude of Pickup Location Id                          | Decimal, range: '40.5' to '41.2'                 | Google Maps API                |
| `puloc_lng`             | Longitude of Pickup Location Id                         | Decimal, range: '-74.2' to '-73.6'               | Google Maps API                |
| `doloc_lat`             | Latitude of Dropoff Location Id                         | Decimal, range: '40.5' to '41.2'                 | Google Maps API                |
| `doloc_lat`             | Longitude of Dropoff Location Id                        | Decimal, range: '-74.2' to '-73.6'               | Google Maps API                |
| `tip_percentage`        | Percentage of Tip Recieved based on base fare/tip       | Decimal, range: '0' to '100'                     | Derived from `tips`            |
| `IsRaining`             | Indicates if it is raining or not for that ride         | Categorical: `Yes`, `No`                         | Derived from `WeatherCondition`|

---

## **Data Sources**

1. **NYC FHV Trip Data (October 2023 - November 2023)**  
   [NYC 2023 High-Volume FHV Trip Data](https://data.cityofnewyork.us/Transportation/2023-High-Volume-FHV-Trip-Data/u253-aew4/data_preview)  
   Contains detailed trip records, including pickup and dropoff times, locations, and fare information.

2. **NYC Taxi Zone Data**  
   [NYC Taxi Zones](https://data.cityofnewyork.us/Transportation/NYC-Taxi-Zones/d3c5-ddgc)  
   Provides geographic zone mappings for location IDs in the trip data.

3. **Meteostat Weather Data**  
   [Meteostat Dataset](https://dev.meteostat.net/)  
   Meteorological data (temperature, wind speed, precipitation, etc.) was retrieved for each trip’s pickup location and time.

---
[Back](index.md)      [Next](Methodology.md)       
