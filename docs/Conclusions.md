---
layout: default   # This tells Jekyll to use the default layout (from the theme)
title: "Conclusion" # Title of the page
---

# Conclusion

## Comparison of Clustering Methods

- **K-means Clustering**:
  - Produced more distinct clusters with minimized within-cluster variation and maximized between-cluster variation for both rush and non-rush hour data.
  - Better aligned with interpretable rider and trip characteristics.

- **Model-Based Clustering**:
  - Generated less distinct clusters with significant overlap, particularly for non-rush hour data.
  - Was less effective in capturing clear behavioral differences across clusters.

---

## Morning: Rush Hour

During rush hour, the analysis revealed more diversity in trip patterns and tipping behaviors, driven by trip-related variables such as distance, duration, and additional charges (e.g., black car fees and tolls). This variability was captured effectively by **K-means clustering**, which identified three distinct clusters that reflect different types of riders and trips.

Cluster 3 represents riders engaging in premium trips, characterized by **longer durations, higher costs, and higher tip percentages**. These trips are often associated with **warmer weather** and include additional charges, such as black car fees and tolls. Riders in this cluster are more likely to tip generously, aligning with the high-value nature of these rides.

Cluster 2, on the other hand, encompasses budget-conscious riders who rarely tip. Trips in this cluster are **shorter, less costly, and occur more frequently in colder weather**. The minimal additional charges and low black car fees further suggest that these rides cater to routine, economical transportation needs.

Cluster 1 serves as a middle ground, capturing trips with **moderate duration, cost, and tipping behavior**. These rides are reflective of average commuter behavior during rush hour, where the mix of regular and premium trips results in less extreme patterns compared to the other clusters.

The morning clustering results highlight the importance of trip-related variables (as captured by PC1), underscoring how rider behavior and tipping habits are influenced by the length and cost of trips, as well as external factors like weather.

---

## Noon: Non-Rush Hour

The non-rush hour analysis revealed less diversity in trip patterns and tipping behaviors compared to rush hour. The data during this period showed a reduction in the number of clusters, with **two primary clusters identified** by **K-means clustering**. These clusters primarily reflect differences in trip-related variables such as distance, duration, and additional fees, but weather variables played a less significant role.

Cluster 1 represents riders engaging in **longer, more premium trips**, with higher black car fees and **more generous tipping behavior**. These trips are more likely to be associated with riders willing to pay for additional services or traveling longer distances during non-rush hours, where competition for rides is lower.

Cluster 2 reflects **short, low-cost trips** dominated by budget-conscious riders or those engaging in routine, economical transportation. The **minimal tipping behavior** and lack of significant additional fees in this cluster suggest a focus on cost-efficiency during non-rush hours.

Unlike the morning clusters, which were influenced by weather conditions, the non-rush hour clusters showed no significant differences in weather-related variables such as temperature or rain. This may indicate that, during non-peak hours, rider behavior is less affected by external factors and more influenced by the nature and purpose of the trip itself.

---

By comparing rush and non-rush hour periods, the findings illustrate how rider behavior and tipping patterns evolve throughout the day. Rush hour trips display greater complexity, likely due to a mix of commuter and discretionary travel. Non-rush hour trips, by contrast, exhibit more homogeneity, with a clear distinction between premium and economical travel.

---

## Limitations

- **Data Constraints**:
  - This analysis relied solely on the provided dataset, which lacked information on external factors such as rider demographics, income levels, or dynamic pricing strategies.
  - The dataset may not capture rare or extreme weather events, limiting insights into how severe conditions affect rider behavior.

- **Temporal Limitations**:
  - The analysis focused only on morning and noon periods, potentially overlooking unique patterns during evening or late-night hours. 

- **Data Scaling**:
   - Standardized data could make some of the interpretations more complicated and could mask absolute differences in variables .

---

## Recommendations for Future Work

- **Expand Temporal Analysis**:
  - Include additional time periods, such as evening and late-night rides, to explore whether similar patterns emerge across other parts of the day.

- **Incorporate External Factors**:
  - Enrich the dataset with rider demographics, traffic conditions, and dynamic pricing data to better understand factors influencing tipping behavior and trip patterns.

- **Extreme Weather Events**:
  - Analyze how rare weather events (e.g., heavy snow, severe storms) influence ride-hailing demand, trip characteristics, and tipping behavior.

- **Dynamic Pricing Analysis**:
  - Would be interesting to study the impact of surge pricing on tipping behavior and cluster characteristics to inform pricing strategies.

---

## **Final Thoughts**

This analysis offers a detailed exploration of ride pattern and tipping behavior in New York City in 2023. By employing clustering techniques and inference, the study has highlighted the main factors driving ride demand and uncovered patterns related to both geography and timing. 

**Thank you for exploring this analysis! Feel free to check out the [GitHub repository](https://github.com/weij5678/NYC-FinalTaxi/tree/main) for code, data, and further details.**
