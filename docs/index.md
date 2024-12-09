---
title: "Home" # Title of the page
layout: default # This tells Jekyll to use the default layout (from the theme)
---

# Exploring 2023 NYC Taxi Ride Patterns

## **Project Overview**
Ride-hailing services, including For-Hire Vehicles (FHVs) like taxis, have become an integral part of urban transportation in large cities such as New York. With the city's unpredictable weather patterns, there is growing interest in understanding how external factors, such as weather conditions, influence ride-hailing demand. In a previous analysis of the 2023 NYC Taxi dataset, it was found that tipping percentage had a weak association with trip characteristics, while trip characteristics showed little to no association with weather conditions, as revealed through PCA and canonical correlation analysis. Building on these findings, the motivation for this final project is to further explore this dataset to examine FHV ride patterns and analyze how weather conditions may affect commuters based on the time of day.

- **Dataset**: [NYC FHV Trip Data](https://data.cityofnewyork.us/Transportation/2023-High-Volume-FHV-Trip-Data/u253-aew4/about_data)
- **Tools Used**: R, Python
- **Previous Project**: [2023 NYC Taxi Project](https://weij5678.github.io/NYC-Taxi/)
- **Statistical Methods**: K-means Clustering, and Model-Based Clustering, MANOVA Inference, Bonferroni Correct ANOVA


### **Key Research Questions**:
- How does tipping behavior, trip characteristics, and weather differ during rush hour(morning) compared to non-rush hour(noon)?
- Can we identify distinct groups/cluster of riders based on their tipping habits and trip patterns/weather?


## **Navigation**
- [Data Description](Data.md)
- [Methodology](Methodology.md)
- [Results and Visualizations](Results.md)
- [Conclusion](Conclusions.md)
- [Code and References](https://github.com/weij5678/NYC-FinalTaxi/tree/main)
  

## **Key Findings**

- During rush hour (morning), premium trips (longer duration, higher costs) were associated with generous tipping, while budget-friendly, shorter trips exhibited minimal tipping. During non-rush hour (noon), tipping behavior followed a simpler pattern, with premium trips having higher tips and low-cost trips showing little to no tipping.
- Weather conditions (e.g., temperature and rain) influenced rider behavior more during rush hour, with colder conditions linked to budget-conscious trips and warmer conditions associated with premium rides. In non-rush hour, weather played an insignificant role in differentiating rider behavior.
- From K-means Clustering:
  - Morning (Rush Hour): Three clusters capturing premium, budget, and average trip characteristics.
  - Noon (Non-Rush Hour): Two clusters distinguishing premium versus budget-friendly trips, with simpler segmentation compared to morning data.

## **Visualizations**


---

## **Future Work**

Potential extensions of this analysis include:
- Improving/transforming the Regression Models
- Better Weather Data Integration
- Further Exploration of Spatial Patterns
- Rider Behavior and Economic Variables
