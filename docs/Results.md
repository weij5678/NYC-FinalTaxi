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


### a. **Rush Hour (Morning) K-means Clusters**:
The plot below visualizes the K-means clustering (k = 3) results for the morning data, projected onto the first two principal components (PC1 and PC2). The clusters (1, 2, and 3) are color-coded as red, green, and blue, respectively.

- **K-means Plot**:

<img src="images/MorningKmeans.png" alt="drawing" width="600"/>

- **Interpretation**:
  - **Cluster 3 (blue)** is positioned on the **negative side of PC1**, representing trips with higher trip characteristics (e.g., longer trips, higher charges, and more tolls).
  - **Cluster 2 (green)** is positioned on the **positive side of PC1**, indicating trips with lower trip characteristics (e.g., shorter trips, lower charges, and likely fewer tolls).
  - **Cluster 1 (red)** lies in between, capturing trips with moderate trip characteristics.
  - PC1 drives most of the separation, highlighting the importance of trip-related factors, while PC2 contributes less to differentiation, capturing secondary factors like tipping behavior or weather.


- **Morning PC Loadings Plot**:

<img src="images/MorningBarplot.png" alt="drawing" width="600"/>

- **Interpretation**:
  - **PC1** explains the largest proportion of variance, with most variables having **negative loadings**. Higher values for these variables are associated with **lower PC1 scores**.
  - Key contributors to PC1 include:
    - **Trip Distance**, **Trip Duration**, **Base Passenger Fare**, **Tolls**, and **Sales Tax**, indicating longer, more expensive trips drive the clustering.
  - These variables strongly influence Cluster 3 (blue), which represents premium trips.


- **Determining Optimal Clusters**:

<img src="images/KmeanCH.png" alt="drawing" width="600"/>

- **Interpretation**:
  - The **CH index** is highest at **k = 2**, suggesting that two clusters provide the strongest separation.
  - The **elbow plot** also suggests the optimal number of clusters lies between **k = 2 and k = 3**.
  - Based on visualizations and interpretability of the clustering results, **k = 3** was chosen to better differentiate distinct rider behaviors during rush hour.


### b. **Non-Rush Hour (Noon) K-means Clusters**
The plot below visualizes the K-means clustering (k = 2) results for the noon data, projected onto the first two principal components (PC1 and PC2). The clusters (1 and 2) are color-coded as red and blue, respectively.

- **K-means Plot**:

<img src="images/NoonKmeans.png" alt="drawing" width="600"/>

- **Interpretation**:
  - **Cluster 1 (red)** is positioned on the **negative side of PC1**, representing trips with **higher trip characteristics**, such as longer distances and higher costs.
  - **Cluster 2 (blue)** is positioned on the **positive side of PC1**, capturing trips with **lower trip characteristics**, such as shorter distances and lower costs.
  - The separation between clusters is primarily driven by PC1, reflecting differences in trip-related variables.


- **Determining Optimal Clusters**:

<img src="images/KmeanCH1.png" alt="drawing" width="600"/>

- **Interpretation**:
  - The **CH index** is highest at **k = 2**, confirming that two clusters provide the strongest separation for noon data.
  - The **elbow plot** similarly supports **k = 2** as the optimal number of clusters.
  - The clustering results align well with these findings, so we proceed with **k = 2** clusters for non-rush hour.

---


## 2. **Model-Based Clustering**
The plot below visualizes the Model-Based Clustering (k = 3) results for the morning data, projected onto the first two principal components (PC1 and PC2). The clusters (1, 2, and 3) are color-coded as red, green, and blue, respectively.

### a. **Testing Model-Based Assumptions**



### b. **Rush Hour (Morning) Model-Based Clustering**

- **Morning Model-Based Plot**:
  
<img src="images/MorningModel.png" alt="drawing" width="600"/>

- **Interpretation**:
  - Significant overlap between the clusters, particularly between Clusters 2 and 3, suggests that while the model-based approach identifies group differences, some riders exhibit transitional or shared characteristics.
  - The spread of Cluster 3 is broader, indicating greater variability in trip-related features for this group.
  - Compared to K-means clustering, the separation of clusters is less distinct, particularly along PC2. This reflects the probabilistic nature of model-based clustering, which accounts for uncertainty in assigning data points to clusters.


 - **Determining Optimal Clusters**:

<img src="images/MorningBIC.png" alt="drawing" width="600"/>

- **Interpretation**:
  - From the BIC plot above, it shows that the most optimal model is Mclust VEV (ellipsoidal, equal shape) model with 3 clusters. 

  
### c. **Non-Rush Hour (Noon) Model-Based Plots**
The plot below visualizes the Model-Based Clustering (k = 6) results for the morning data, projected onto the first two principal components (PC1 and PC2). The clusters are are color-coded below:

- **Noon Model-Based Plot**:
  
<img src="images/NoonModel.png" alt="drawing" width="600"/>

- **Interpretation**:
  - Significant overlap is observed, especially among Clusters 1, 4, and 5, suggesting some shared characteristics between these clusters.
  - Clusters 3 and 6 have more distinct boundaries, likely reflecting trips with extreme values for trip distance or cost.
  - Again, clusters are primarily separated along PC1, indicating that trip-related variables (e.g., trip distance, fare, and tolls) are the dominant factors in clustering.
  - Compared to K-means clustering, the separation of clusters is much less distinct.

 - **Determining Optimal Clusters**:

   <img src="images/NoonBIC.png" alt="drawing" width="600"/>

- **Interpretation**:
  - From the BIC plot above, it shows that the most optimal model is Mclust VEV (ellipsoidal, equal shape) model with 6 clusters.

 
### d. **Comparing K-means vs Model Based Clustering Methods**
- We aim to compare the K-means and Model-Based clusters to determine which method is more suitable for inference.
- To make this comparison, we assess the clusters based on their ability to minimize the total within-cluster variation and maximize the total between-cluster variation.
- The diagram below indicate that K-means clustering is the most optimal approach for both rush hour (blue) and non-rush hour (red), as it minimizes the total within-cluster variation while maximizing the total between-cluster variation.

<img src="images/Compare.png" alt="drawing" width="600"/>


---

## 3. **Inference**
- The clustering results were analyzed using inference to gain insights into rider behavior, tipping habits, trip characteristics, and the influence of external factors such as weather and time of day.

### a. **Rush Hour Inference**

#### **MANOVA Inference**
- The MANOVA test was conducted to examine differences across clusters for the following variables:
  - **IsRaining**, **Tip Percentage**, **Trip Miles**, **Trip Time**, **Temperature**, and **Black Car Fee**.
  - These specific variables were chosen to determine whether trip characteristics and weather variables vary across clusters. Additionally, since only the first principal component had a distinct loading while other components contributed minimally, we excluded principal components from this analysis.
- The test yielded a p-value of **<2.2e-16**, which is much smaller than the 5% significance level. Thus, we reject the null hypothesis, indicating that these variables differ significantly across the clusters.
- To further investigate, one-way inference was conducted to identify which variables significantly differ across clusters.


#### **One-way Inference**
- **ANOVA** was conducted to determine the significant variables across clusters. For rush hour, all six variables were found to be significant, with the top three most significant variables listed below:
  - **Significant Variables**:
    - **Tip Percentage**
    - **Trip Miles**
    - **Trip Duration**
    - **Black Car Fee**


##### **Cluster-Specific Observations**

<img src="images/MorningANOVA.png" alt="Tip Percentage and Trip Duration by Cluster" width="600"/>

<img src="images/MorningANOVA1.png" alt="Temperature and Black Car Fee by Cluster" width="600"/>

- **Cluster 3 (Blue)**:
  - **Tip Percentage**: This cluster has the **highest average tip percentage** with a wide distribution, indicating significant tipping behavior.
  - **Trip Duration**: Exhibits the **longest trip durations**, consistent with its association with premium trips and higher tipping percentages.
  - **Temperature**: Cluster 3 has the **highest temperature range**, suggesting trips in this cluster occur more frequently during warmer conditions.
  - **Black Car Fee**: This cluster has the **highest black car fees**, aligning with the observation that Cluster 3 represents premium trips or trips with additional charges.

- **Cluster 2 (Green)**:
  - **Tip Percentage**: This cluster has the **lowest tip percentage**, with many trips showing no tipping behavior.
  - **Trip Duration**: This cluster shows the **shortest trip durations**, aligning with its low tipping behavior and budget-conscious riders.
  - **Temperature**: Cluster 2 has the **lowest temperature range**, indicating trips in this cluster occur more frequently during colder conditions.
  - **Black Car Fee**: Cluster 2 has the **lowest black car fees**, reflecting budget-conscious trips or those without premium services.

- **Cluster 1 (Red)**:
  - **Tip Percentage**: This cluster shows **moderate tipping behavior**, with a lower average compared to Cluster 3.
  - **Trip Duration**: This cluster has **moderate trip durations**, representing average trip lengths during the morning rush.
  - **Temperature**: Cluster 1 shows **moderate temperature conditions**, reflecting average weather for these trips.
  - **Black Car Fee**: Black car fees in this cluster are **moderate**, suggesting a mix of regular and premium trips.



#### **Bonferroni**
- Pairwise comparisons using Bonferroni correction were performed for rush hour clusters to identify significant differences:
  - **Cluster 3 vs. Cluster 2**: Significant difference in tip percentage and trip characteristics, with Cluster 3 tipping more.
  - **Cluster 3 vs. Cluster 1**: Significant difference, with Cluster 3 tipping more.
  - **Cluster 1 vs. Cluster 2**: Moderate difference, showing Cluster 1 tips more than Cluster 2.

---

### b. **Non-Rush Hour Inference**

#### **Visualization**
<img src="images/PuHexbin.png" alt="drawing" width="600"/>

#### **MANOVA Inference**
- The MANOVA test was conducted to examine differences across the two clusters for the following variables:
  - **IsRaining**, **Tip Percentage**, **Trip Miles**, **Trip Time**, and **Temperature**.
- The test revealed significant differences across these variables.

#### **One-way Inference**
- ANOVA results for non-rush hour clusters identified significant variables:
  - **Tip Percentage**
  - **Trip Miles**
  - **Trip Duration**

- **Interpretation**:
  - **Cluster 1**: Represents trips with higher trip characteristics (e.g., longer distances, higher costs) and higher tip percentages.
  - **Cluster 2**: Represents shorter, lower-cost trips with minimal tipping behavior.

#### **Bonferroni**
- No Bonferroni post hoc testing was conducted, as there are only two clusters in the non-rush hour data.


---
