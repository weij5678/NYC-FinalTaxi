---
layout: default   # This tells Jekyll to use the default layout (from the theme)
title: "Conclusion" # Title of the page
---

# Conclusion

## **Key Findings**:

The analysis of FHV ride pattern data through dimensionality reduction techniques and spatial visualizations reveals insights into tipping behavior, ride characteristics, weather conditions, and demand patterns across New York City. Here are the key conclusions:

### 1. **Principal Component Analysis (PCA)**

The PCA revealed that the first two principal components capture a significant portion of the variability in ride-hailing data. The key factors driving the first principal component are trip-related variables such as **trip distances**, **duration**, and **base fare**, while the second principal component is driven by external factors like **wind speed**, **congestion surcharge**, and **tolls charged**. These findings suggest that longer trips with higher fares are major contributors to ride-hailing behavior, while weather and traffic conditions also influence ride demand, although to a lesser degree.

### 2. **Tipping Behavior**

The Principal Component Regression model, which regressed tipping behavior on the first two principal components, uncovered a weak negative association between tipping and ride characteristics. While trip duration and distance influence tips, the diagnostic plots indicated issues with non-linearity and heteroscedasticity. Future studies could improve the regression model by exploring transformations or non-linear models to better capture the relationship between tipping and these underlying factors.

### 3. **Canonical Correlation Analysis (CCA)**

The CCA uncovered a weak relationship between weather conditions and trip characteristics. Despite the weak correlations, some interesting associations were found: **dew point** and **humidity** were weakly related to longer trip durations and higher base fares. However, overall, the analysis shows that weather factors like **temperature**, **wind speed**, and **air pressure** have limited influence on trip characteristics and tipping behavior. This suggests that other factors, such as time of day or location, may play a more significant role in ride demand.

### 4. **Spatial Distribution of Ride Demand**

Hexbin maps revealed shifting patterns of ride-hailing demand across New York City throughout the day. Midtown Manhattan emerged as the primary hotspot for pickups in the morning, but as the day progressed, this demand faded, indicating a decline in ride activity in the area. Meanwhile, residential areas like **Brooklyn** showed a higher concentration of pickups in the morning, reflecting commuting patterns. Interestingly, the **Upper East Side**, traditionally a residential area, showed an unexpected concentration of drop-offs in the morning, suggesting more complex ride behavior patterns, perhaps related to daily commuting or other factors.

--- 

## **Limitations**

While the analysis provided valuable insights, there are several limitations to consider:

1. **Lack of Taxi Zone Data Usage**: The analysis would have benefitted from incorporating **taxi zone data** into the hexbin mapping plots, which would have allowed for a more granular understanding of ride patterns across specific zones in New York City. This could have improved the spatial accuracy of the pickup and drop-off patterns.
  
2. **Granularity of Weather Data**: The weather data used in this study may lack the level of granularity required to capture the impact of weather on ride behavior. More  cohesive weather data could have provided deeper insights into how conditions such as snow and seasonality influence demand.

3. **Complexity of Variables**: The large number of variables in the dataset made it difficult to discern a clear, continuous trend. While PCA helped reduce dimensionality, there remains a degree of complexity that could be addressed by focusing on a smaller set of key variables or by applying advanced methods such as feature selection.

---

## **Recommendations for Future Research**

The analysis has provided valuable insights into ride-hailing behavior in New York City, but there are several areas that warrant further exploration:

1. **Improving Regression Models**: Future work could explore non-linear models or transformations to better capture the complex relationship between tipping and trip characteristics.
  
2. **Weather Data Integration**: While this study found weak correlations between weather and ride behavior, future studies could include more granular weather data or explore its interaction with other factors, such as time of day or specific locations.

3. **Further Exploration of Spatial Patterns**: Additional spatial analyses could focus on more specifc neighborhoods to uncover nuanced patterns in ride demand across different parts of New York City, including areas beyond Manhattan.

4.  **Rider Behavior and Economic Variables**:  
  Incorporating economic variables such as tips, driver pay, and fare surcharges could provide additional insights into rider behavior. Understanding how tipping interacts with fare and weather could inform driver compensation models and help improve driver satisfaction by identifying patterns where higher tips are more likely.

---

## **Final Thoughts**

This analysis offers a detailed exploration of ride pattern and tipping behavior in New York City in 2023. By employing dimensionality reduction techniques and spatial visualization, the study has highlighted the main factors driving ride demand and uncovered patterns related to both geography and timing. 

**Thank you for exploring this analysis! Feel free to check out the [GitHub repository](https://github.com/weij5678/NYC-FinalTaxi/tree/main) for code, data, and further details.**
