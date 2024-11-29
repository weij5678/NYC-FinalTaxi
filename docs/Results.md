---
title: Results
layout: default
--- 

# Results and Visualizations

In this section, we present the key results from the dimension reduction analysis and visualizations to understand the factors influencing tipping and FHV ride trends.

---
## 1. **Principal Component Analysis (PCA)**
- Initially, three separate principal component analyses were conducted for different times of the day—morning, noon, and evening—excluding tipping variables.
- Since no significant differences were observed across the time periods, a combined principal component analysis was performed without considering time, while still excluding the tipping variables.
- This allowed for the regression of tips against the important principal components identified, leading to the following observations.

### a. **Key Principal Components**
To identify the most important principal components, a scree plot was first generated.

- **Visualization**:

  
<img src="images/FullScreeplot.png" alt="drawing" width="600"/>


- **Interpretation**:
  - The scree plot shows that the first principal component accounts for 37.1% of the variance, while the second accounts for 11%.
  - Based on the "elbow" in the plot and taking the variance explained into consideration, only the first two principal components need to be kept when performing principal component regression.


### b. **Analyzing the Variables within the Principal Components**
- After selecting the first two principal components, the next step is to identify which variables play a significant role in these components.
- This can be examined through a biplot and bar plot, which highlight the contribution of each variable to the first two principal components.

- **Visualization**:
  
<img src="images/FullBiplot.png" alt="drawing" width="600"/>

 
 ![FullBarplot](images/FullBarplot.png)


- **Interpretation**:
  - The biplot and loadings together provide a detailed information of the key factors influencing the variability in the dataset.
    
  - Starting with PC1, the loadings plot shows that variables like trip distances, duration, base fare, black car fund fee, and driver pay have the largest negative contributions. This aligns with the biplot, where arrows representing these variables point are far from zero in the direction of PC1, indicating their strong influence on this component.The high loadings suggest that PC1 is primarily driven by trip related variables, meaning longer trips, higher fares, and additional charges such as sales tax and driver pay are key factors contributing to the variation in PC1.
    
  - In PC2, the loadings plot indicates that wind speed, wind direciton, tolls charged during, and congestion surcharge have the strongest positive contributions. In the biplot, windspeed and tolls charged are far from the origin in the direction of PC2, confirming their role as key drivers of variability in this component. This suggests that PC2 captures variability related to external factors like weather and tolls/congestion perhaps indicating different patterns of demand depending on weather conditions and traffic conditions.

### c. **Principal Component Regression**
The Principal Component Regression (PCR) model was used to examine the relationship between tipping behavior and the first two principal components.

- **PCR Results**:
  - **(Intercept)**: The intercept of 7.00 suggests that, on average, the baseline tip percentage is around 7% when both PC1 and PC2 are zero.
  - **PC1**: With an estimate of -0.48 and a highly significant p-value (p < 2e-16), this coefficient suggests a slight negative association between PC1 which holds most of the ride characterstics and tip_percentage, meaning that as PC1 increases, the tip percentage tends to decrease slightly.
  - **PC2**: This coefficient is also negative but not significant (p = 0.087), indicating a weaker relationship.

- **Diagnostics**:

  
<img src="images/FullRegression.png" alt="drawing" width="600"/>

 
- **Interpretation**:
  - The Principal Component Regression model provided a simplified view of how tipping percentage relates to broader factors like trip characteristics and weather conditions (summarized by the principal components).
  - However, the diagnostic plots reveal shortcomings, including non-linearity, heteroscedasticity, and non-normal residuals.
  - To improve the model, further steps such as applying transformations could help better capture the relationship between tipping percentage and the underlying factors.

---
## 2. **Canonical Correlation Analysis**
- Canonical Correlation Analysis (CCA) was used to explore the relationship between weather conditions (temperature, dew point, windspeed, humidity, precipitation, wind direction, and air pressure) and trip characteristics (trip duration, trip distance, base fare, toll charges, and tip percentage).
- The analysis revealed the following:

### a. **Visualizing Cross-Correlation** 
The cross-correlation matrix was examined to observe potential correlations within each category—weather conditions and trip characteristics—as well as the cross-correlations between them.

- **Visualization**:
<img src="images/CrossCorrelation.png" alt="drawing" width="600"/>

- **Interpretation**:
  - X Correlation Matrix:  Among the weather variables, there is a strong positive correlation between (temperature and dew point) and (dew point and humidity), as indicated by the dark red, which is expected given that these variables often go together. In contrast, wind speed shows negative correlations with other weather factors like relative humidity (rhum) and air pressure (pres), as seen by the blue sqaures.
  - Y Correlation Matrix: For the trip characteristics, strong positive correlations are observed between trip miles, trip distances, and base passenger fare, which makes intuitive sense since longer trips typically result in higher fares. However, tip percentage shows weaker correlations with the other trip-related variables, suggesting that tipping behavior is less influenced by trip distance or fare.
  - The cross-correlation between weather and trip variables is weak, as shown by the green squares. This suggests that weather conditions, such as temperature, wind speed, and humidity, has weak association with  trip duration, distance, fare, or tipping percentage. 

### b. **Visualizing the Canonical Covariates**
- Although the cross-correlation between the two sets of variables (weather conditions and trip characteristics) was weak, canonical covariates were still calculated to further explore the relationships.
- The CCA bar plots were examined to visualize how the first two pairs of canonical variates relate to each other.

- **Visualization**:

<img src="images/CCAbarplot.png" alt="drawing" width="600"/>

- **Interpretation**:
  - Since u1 is heavily influenced by dew point and relative humidity, and v1 is driven by trip duration and base fare, this suggests that higher humidity and dew point might be associated with longer trip durations and higher base fares.
  - The second pair of canonical variates(right) shows that u2 is influenced primarily by wind speed and air pressure, while v2 is driven by tolls, base fare, and tip percentage.
  - This suggests that certain weather conditions, like higher wind speeds and air pressure, might be related to higher tolls or tipping percentages, though the strength of this relationship is quite weak.

### c. **Overall CCA Structures**
- After visualizing the bar plots, canonical correlations were calculated to assess the association between the covariates.
- A test for the significance of these correlations revealed that the first two canonical variate pairs were significant and prompted further exploration, as shown above in the bar plots. 

- **Visualization**:

<img src="images/CanonicalStructure.png" alt="drawing" width="600"/>

- **Interpretation**:
  - The first canonical variate pair (u1 and v1) in the visualization shows a canonical correlation of 0.21, which means that 21% of the variance in the summary weather conditions can be explained by the summary of trip characteristics.
  - This suggests a weak relationship between the two sets of variables, where factors like trip duration, trip miles, and base fare provide some explanatory power for weather conditions like temperature and humidity.
  - However, the relatively weak correlation indicates that while trip characteristics do influence weather conditions to some extent, the relationship is not particularly strong. In other words, only a small portion of the variability in weather can be attributed to the characteristics of the trips. 

---
## 3. **Visualizing Pickup/Dropoff Locations**
- Initially, pickup/dropoff locations were plotted based off of longitute and latitudee as points on google maps, but it was quite hard to discern the patterns.
- Instead, hexbin plots were utilized instead in order to observe the pickup/dropoff count on top of NYC's map to osberve any patterns.

### a. **Pickup Location Observations**

- **Visualization**:

<img src="images/PuHexbin.png" alt="drawing" width="2500" height="500"/>

- **Interpretation**:
  - The hexbin pickup maps for morning, noon, and evening clearly show how ride-hailing demand shifts throughout the day.
  - It is unsurprising that the most popular pickup location is around Midtown Manhattan. However, an interesting pattern emerges as the day progresses, with Midtown becoming a less dominant pickup spot.
    - This suggests that while the morning sees a high concentration of pickups in central Manhattan, potentially related to nightlife or early commuters, the assumption that people would be coming from various parts of the city in the morning doesn't hold as strongly.
  - Though less noticeable, residential areas such as Brooklyn show a higher concentration of pickups in the morning compared to other times of the day, indicating shifting demand patterns.

  

### b. **Dropoff Location Observations**

- **Visualization**:

<img src="images/DoHexbin.png" alt="drawing" width="2500" height="500"/>

- **Interpretation**:
  - In the morning, drop-offs are predominantly concentrated in lower Manhattan, particularly in the Financial District, which aligns with the morning commute as workers head to offices and other commercial hubs.
  - However, the yellow hexbin in the morning points to the Upper East Side, which is primarily a residential area. This is an intriguing observation, as it suggests that the Upper East Side experiences higher drop-off activity than expected during the morning hours.
  - Much like the pickup map, it appears that the highly concentrated drop-off locations in lower Manhattan and the Upper East side begin to fade or become less significant as the day progresses.
  - This could indicate that taxis as a commuting option are less popular later in the day, possibly giving way to other modes of transport or indicating less concentrated work-related travel after the morning rush.

---
