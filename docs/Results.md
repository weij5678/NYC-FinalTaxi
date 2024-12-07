---
title: Results
layout: default
---

# Results and Visualizations

This section presents the key results from K-means clustering, Model-Based Clustering, and Inference to better understand the factors influencing tipping behavior and FHV ride patterns.

---

## 1. **K-means Clustering**
- Clustering analysis was conducted separately for two time periods: Rush hour (Morning) and Non-Rush hour (Noon).
- K-means clustering was initialized using hierarchical clustering to determine starting cluster centers.

---

### a. **Rush Hour (Morning) K-means Clusters**
The plot below visualizes the K-means clustering (k = 3) results for the morning data, projected onto the first two principal components (PC1 and PC2). The clusters (1, 2, and 3) are color-coded as red, green, and blue, respectively.

- **K-means Plot**:

<img src="images/MorningKmeans.png" alt="drawing" width="600"/>

- **Interpretation**:
  - **Cluster 3 (blue)** is positioned on the **negative side of PC1**, representing trips with higher trip characteristics (e.g., longer trips, higher charges, and more tolls).
  - **Cluster 2 (green)** is positioned on the **positive side of PC1**, indicating trips with lower trip characteristics (e.g., shorter trips, lower charges, and likely fewer tolls).
  - **Cluster 1 (red)** lies in between, capturing trips with moderate trip characteristics.
  - PC1 drives most of the separation, highlighting the importance of trip-related factors, while PC2 contributes less to differentiation, capturing secondary factors like tipping behavior or weather.

---

- **Morning PC Loadings Plot**:

<img src="images/MorningBarplot.png" alt="drawing" width="600"/>

- **Interpretation**:
  - **PC1** explains the largest proportion of variance, with most variables having **negative loadings**. Higher values for these variables are associated with **lower PC1 scores**.
  - Key contributors to PC1 include:
    - **Trip Distance**, **Trip Duration**, **Base Passenger Fare**, **Tolls**, and **Sales Tax**, indicating longer, more expensive trips drive the clustering.
  - These variables strongly influence Cluster 3 (blue), which represents premium trips.

---

- **Determining Optimal Clusters**:

<img src="images/KmeanCH.png" alt="drawing" width="600"/>

- **Interpretation**:
  - The **CH index** is highest at **k = 2**, suggesting that two clusters provide the strongest separation.
  - The **elbow plot** also suggests the optimal number of clusters lies between **k = 2 and k = 3**.
  - Based on visualizations and interpretability of the clustering results, **k = 3** was chosen to better differentiate distinct rider behaviors during rush hour.

---

### b. **Non-Rush Hour (Noon) K-means Clusters**
The plot below visualizes the K-means clustering (k = 2) results for the noon data, projected onto the first two principal components (PC1 and PC2). The clusters (1 and 2) are color-coded as red and blue, respectively.

- **K-means Plot**:

<img src="images/NoonKmeans.png" alt="drawing" width="600"/>

- **Interpretation**:
  - **Cluster 1 (red)** is positioned on the **negative side of PC1**, representing trips with **higher trip characteristics**, such as longer distances and higher costs.
  - **Cluster 2 (blue)** is positioned on the **positive side of PC1**, capturing trips with **lower trip characteristics**, such as shorter distances and lower costs.
  - The separation between clusters is primarily driven by PC1, reflecting differences in trip-related variables.

---

- **Determining Optimal Clusters**:

<img src="images/KmeanCH1.png" alt="drawing" width="600"/>

- **Interpretation**:
  - The **CH index** is highest at **k = 2**, confirming that two clusters provide the strongest separation for noon data.
  - The **elbow plot** similarly supports **k = 2** as the optimal number of clusters.
  - The clustering results align well with these findings, so we proceed with **k = 2** clusters for non-rush hour.

---


## 2. **Model-Based Clustering**
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
