---
layout: default   # This tells Jekyll to use the default layout (from the theme)
title: "Conclusion" # Title of the page
---

# Conclusions

This project explored the patterns of tipping behavior and FHV ride characteristics in New York City during rush and non-rush hours, using clustering techniques and statistical inference to identify key differences.

---

## Key Findings

### 1. **Rush Hour (Morning)**

- **Clustering Results**:
  - K-means clustering (k = 3) revealed distinct groups based on trip characteristics:
    - **Cluster 3** represents premium trips with the highest tip percentages, longest trip durations, and highest black car fees.
    - **Cluster 2** reflects budget-friendly trips with the lowest tip percentages, shortest durations, and minimal black car fees.
    - **Cluster 1** represents moderate trips, balancing characteristics of the other two clusters.

- **Statistical Inference**:
  - The MANOVA test showed significant differences across clusters for all variables tested (**Tip Percentage**, **Trip Miles**, **Trip Duration**, **Black Car Fee**, **Temperature**, and **IsRaining**).
  - One-way ANOVA highlighted **Tip Percentage**, **Trip Miles**, **Trip Duration**, and **Black Car Fee** as the most significant differentiators.
  - Bonferroni corrections confirmed Cluster 3's association with high-value, premium rides, while Cluster 2's characteristics aligned with short, cost-effective trips.

---

### 2. **Non-Rush Hour (Noon)**

- **Clustering Results**:
  - K-means clustering (k = 2) revealed two distinct clusters:
    - **Cluster 1** represents premium trips with higher tip percentages, longer durations, and higher black car fees.
    - **Cluster 2** captures budget-friendly trips with lower tip percentages, shorter durations, and minimal black car fees.

- **Statistical Inference**:
  - MANOVA confirmed significant differences across clusters for trip-related variables, but **weather variables (Temperature and IsRaining)** were not significant.
  - One-way ANOVA identified **Tip Percentage**, **Trip Miles**, **Trip Duration**, and **Black Car Fee** as key variables distinguishing the clusters.
  - Bonferroni corrections validated the findings, reinforcing the segmentation of premium and budget trips during non-rush hours.

---

## Comparison of Clustering Methods

- **K-means Clustering**:
  - Produced more distinct clusters with minimized within-cluster variation and maximized between-cluster variation for both rush and non-rush hour data.
  - Better aligned with interpretable rider and trip characteristics.

- **Model-Based Clustering**:
  - Generated less distinct clusters with significant overlap, particularly for non-rush hour data.
  - Was less effective in capturing clear behavioral differences across clusters.

---

## Limitations

- **Data Constraints**:
  - This analysis relied solely on the provided dataset, which lacked information on external factors such as rider demographics, income levels, or dynamic pricing strategies.
  - The dataset may not capture rare or extreme weather events, limiting insights into how severe conditions affect rider behavior.

- **Temporal Limitations**:
  - The analysis focused only on morning and noon periods, potentially overlooking unique patterns during evening or late-night hours.

- **Clustering Assumptions**:
  - K-means clustering assumes spherical clusters and equal variances, which may not fully capture the complexity of ride-hailing data. Model-based clustering, while more flexible, produced less interpretable clusters in this context.

---

## Recommendations for Future Work

- **Expand Temporal Analysis**:
  - Include additional time periods, such as evening and late-night rides, to explore whether similar patterns emerge across other parts of the day.

- **Incorporate External Factors**:
  - Enrich the dataset with rider demographics, traffic conditions, and dynamic pricing data to better understand factors influencing tipping behavior and trip patterns.

- **Extreme Weather Events**:
  - Analyze how rare weather events (e.g., heavy snow, severe storms) influence ride-hailing demand, trip characteristics, and tipping behavior.

- **Advanced Clustering Techniques**:
  - Experiment with alternative clustering methods such as DBSCAN or hierarchical clustering for non-spherical clusters.
  - Use ensemble clustering methods to combine the strengths of different approaches.

- **Dynamic Pricing Analysis**:
  - Study the impact of surge pricing on tipping behavior and cluster characteristics to inform pricing strategies.

---

## **Final Thoughts**

This analysis offers a detailed exploration of ride pattern and tipping behavior in New York City in 2023. By employing dimensionality reduction techniques and spatial visualization, the study has highlighted the main factors driving ride demand and uncovered patterns related to both geography and timing. 

**Thank you for exploring this analysis! Feel free to check out the [GitHub repository](https://github.com/weij5678/NYC-FinalTaxi/tree/main) for code, data, and further details.**
