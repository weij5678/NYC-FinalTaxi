---
title: Methodology
layout: default
--- 

# Methodology

## 1. **K-means Clustering**
- **Motivation**:
  -  Previous analyses revealed weak associations between tipping behavior and trip characteristics. K-means clustering provided insights into distinct rider groups and their behaviors that were not apparent through direct analysis of individual variables.
    
- **Methodology**:
  - First, I 
  - However, upon reviewing the visualizations, it was found that there were no significant differences between the time-specific PCA analyses.
- As a result, a combined PCA was performed, excluding time as a factor, but still excluding the tip percentage variable in order to perform a regression on tip percentages.

- **PCA Visualizations**: 
  - **Screeplot**: Used to determine the number of principal components to retain.
  - **Biplot**: Displays the variables that are important to the principal components.
  - **Barplot**: Shows the contribution of each variable to the principal components.
  
- **Principal Component Regression**:
  - Performed a Principal Component Regression (PCR) using the first two principal components.
  - Diagnostic plots were generated to assess the quality of the regression.

---

## 2. **Canonical Correlation Analysis (CCA)**
- **Motivation**:
  - After exploring tipping behavior, CCA was applied to closely examine the relationships between ride characteristics and weather conditions.

- **Methodology**:
  - Seven weather variables (temperature, dew point, wind speed, humidity, precipitation, wind direction, air pressure) and five trip characteristics (trip duration, trip distance, base passenger fare, tolls, tip percentage) were examined to determine if weather conditions significantly influence trip characteristics.

- **Correlation Matrix**: 
  - Visualized the canonical correlation matrix to examine relationships between weather variables and trip characteristics.
  - Analyzed the cross-correlation between weather conditions and trip characteristics.
    
- **Visualizing Canonical Covariates**:
  - Performed correlation test to see how many canonical covariate pairs were necassary to visualize
  - Identified which variables contributed the most to the first two canonical pairs
    

- **Canonical Correlation Structure**:
  - Calculated the canonical correlations in order to visualize
  - Visualized the overall structure of the canonical correlation to understand how much summary of weather variables and trip characterstics are related.

---

## 3. **Maps for Pickup and Drop-off Locations**
- **Motivation**:
  - Hexbin maps were used to visualize the spatial distribution of pickup and drop-off locations across New York City at different times of the day (morning, noon, evening).
  - Hexbin maps were chosen specifically for their ability to declutter dense spatial data and reveal meaningful geographic patterns. 

- **Methodology**:
  - Initially, points were plotted on the NYC map and distinguished by color for different times.
  - However, hexbin plots were plotted next because they effectively manage dense spatial data by aggregating ride data into hexagonal bins.
    - This approach makes it easier to identify geographic hotspots and observe patterns in ride demand.
  - The lighter the color of the hexbin, the more popular the pickup/dropoff location is at the time of day
  
- **Hexbin Map of Pickup and Drop off Locations**: 
  - Created separate hexbin maps for morning, noon, and evening to observe the temporal and spatial variations in ride activity.
  - Interpreted the patterns to identify where ride demand is concentrated throughout the day.
 
  
