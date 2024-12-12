---
title: Methodology
layout: default
--- 

# Methodology

## 1. **Data Processing**
- Although the [Data Description](Data.md) already explained how the data was processed, a new variable `IsRaining` was added to make the clustering possible
- For this analysis sepcifically, the focus is on the two subsets rush hour (morning) and non-rush hour (noon)
- Below is the specific 15 variables that is focused on throughout the analysis:

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


## 1. **K-means Clustering**
- **Motivation**:
  - Previous analyses revealed weak associations between tipping behavior and trip characteristics. K-means clustering was used to uncover latent patterns in the data, providing insights into distinct rider groups and their behaviors during rush and non-rush hours.

- **Methodology**:
  - The dataset was divided into rush (morning) and non-rush (noon) hours.
  - K-means clustering was initialized using hierarchical clustering to determine initial cluster centers and performed separately for rush and non-rush hours.
  - The optimal number of clusters was determined using the Calinski-Harabasz (CH) index and the elbow plot.
  - Total within-cluster variation and between-cluster variation were calculated to evaluate clustering quality.

- **K-means Clustering Visualizations**:
  - **K-means Plot**: Displays clusters on a two-dimensional plot using principal components (PC1 and PC2).
  - **CH Index Plot**: Identifies the optimal number of clusters based on the CH index.
  - **PC Loadings Barplot**: Highlights the contribution of each variable to the principal components.

---

## 2. **Model-Based Clustering**
- **Motivation**:
  - After conducting K-means clustering, model-based clustering was applied to compare the two methods and evaluate which approach produces better-defined clusters.

- **Methodology**:
  - The data distribution was analyzed to ensure model-based clustering was appropriate.
  - Model-based clustering was performed, and the optimal number of clusters was identified.
  - Total within-cluster variation and between-cluster variation were calculated for comparison with K-means clustering.

- **Model-Based Visualizations**:
  - **Model-Based Plot**: Displays clusters on a two-dimensional plot using principal components (PC1 and PC2).
  - **CH Index Plot**: Identifies the optimal number of clusters based on the CH index.

- **Comparing K-means and Model-Based Clustering**:
  - The total within-cluster variation and between-cluster variation were compared between K-means and model-based clustering.
  - The clustering method that minimized within-cluster variation and maximized between-cluster variation was selected for inference.

---

## **3. Inference**

- **Motivation**:
  - The clustering results were analyzed using inference to gain insights into rider behavior, tipping habits, trip characteristics, and the influence of external factors such as weather and time of day. 

- **MANOVA Analysis**:
  - Separate MANOVA tests were performed for rush-hour and non-rush-hour clusters to evaluate differences across five key variables: **IsRaining**, **Temperature**, **Trip Duration**, **Trip Distance**, and **Tip Percentage**.
  - Significant variables identified through MANOVA were further analyzed using one-way ANOVA tests to pinpoint specific areas of divergence between clusters.

- **Post-Hoc Analysis**:
  - For rush-hour clusters, **Bonferroni correction** was applied to compare differences between clusters for significant variables identified in the ANOVA.
  - For non-rush-hour clusters, a **paired t-test** was used to assess differences between the two clusters based on significant variables.
