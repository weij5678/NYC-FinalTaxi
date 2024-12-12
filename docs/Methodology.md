---
title: Methodology
layout: default
--- 

# Methodology

## 1. **Data Processing**
- Although the [Data Description](Data.md) already explained how the data was processed, a new variable `IsRaining` was created by collapsing the `WeatherCondition` to make the clustering simpler and easier to interpret.
- For this analysis sepcifically, the focus is on the two subsets rush hour (morning) and non-rush hour (noon), by subsetting the variable based on the variable `PeriodOfDay`.
- Below is the specific *16 variables* that is analzed throughout the analysis:

| Variable Name          | Variable Label                                           |
|------------------------|----------------------------------------------------------|
| `trip_miles`            | Distance covered during the trip (miles)                |
| `trip_time`             | Duration of the trip (seconds)                          |
| `base_passenger_fare`   | Fare paid by the passenger (USD)                        |
| `tolls`                 | Tolls charged during the trip (USD)                     |
| `bcf`                   | Black car fund fee                                      |
| `sales_tax`             | Sales tax applied to the trip (USD)                     |
| `congestion_surcharge`  | Congestion surcharge applied to the trip (USD)          |
| `airport_fee`           | Fee for airport dropoffs (USD)                          |
| `tips`                  | Tips given by the passenger (USD)                       |
| `driver_pay`            | Pay received by the driver (USD)                        |
| `temp`                  | Temperature at pickup location (°C)                     |
| `rhum`                  | Relative humidity at pickup location (%)                |
| `wdir`                  | Wind direction at pickup location (degrees)             |
| `wspd`                  | Wind speed at pickup location (km/h)                    |
| `tip_percentage`        | Percentage of Tip Recieved based on base fare/tip       |
| `IsRaining`             | Indicates if it is raining or not for that ride         |

## 2. **K-means Clustering**
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

## 3. **Model-Based Clustering**
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

## **4. Inference**

- **Motivation**:
  - The clustering results were analyzed using inference to gain insights into rider behavior, tipping habits, trip characteristics, and the influence of external factors such as weather and time of day. 

- **MANOVA Analysis**:
  - Separate MANOVA tests were performed for rush-hour and non-rush-hour clusters to evaluate differences across five key variables: **IsRaining**, **Temperature**, **Trip Duration**, **Trip Distance**, and **Tip Percentage**.
  - Significant variables identified through MANOVA were further analyzed using one-way ANOVA tests to pinpoint specific areas of divergence between clusters.

- **Post-Hoc Analysis**:
  - For rush-hour clusters, **Bonferroni correction** was applied to compare differences between clusters for significant variables identified in the ANOVA.
  - For non-rush-hour clusters, a **paired t-test** was used to assess differences between the two clusters based on significant variables.
