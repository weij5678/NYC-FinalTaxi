
###### NYC Final Taxi Filtering/Methodology Code

## Reading/Filtering the Data: -----------------------------------------------------------------------
library(readr)
taxi <- read.csv("/Users/weiran/FinalMultiProject/2023NYC_Taxi.csv")
taxi <- taxi[, !names(taxi) %in% c("Unnamed..0", "access_a_ride_flag", "snow", "wpgt", "coco", "tsun")]
taxi <- taxi[ , colSums(is.na(taxi)) == 0]
taxi$tip_percentage <- (taxi$tips / taxi$base_passenger_fare) * 100

#Subsetting the data
apply(taxi[,-6], 2, sd)
var <- c("pulocationid", "dolocationid", "trip_miles", "trip_time", 
         "base_passenger_fare", "tolls", "bcf", "sales_tax", "congestion_surcharge", 
         "airport_fee", "tips", "driver_pay", "temp", "dwpt", "rhum", "prcp", "wdir", 
         "wspd", "pres", "WeatherCondition", "", "tip_percentage")
morning_data <- subset(taxi, PeriodOfDay == "Morning")
noon_data <- subset(taxi, PeriodOfDay == "Noon")
evening_data <- subset(taxi, PeriodOfDay == "Evening")


###########MORNING DATA#####################################################################################

##K-means Clustering: ----------------------------------------------------------------
library(tidyverse)
library(factoextra)
taxi_num <- c('trip_miles', 'trip_time', 'base_passenger_fare', 'tolls', 'bcf', 
              'sales_tax', 'congestion_surcharge', 'airport_fee', 'driver_pay', 
              'temp', 'rhum', 'wdir', 'wspd', 'tip_percentage', 'WeatherCondition')

# Morning K-means Clustering:
morning_data <- subset(taxi, PeriodOfDay == "Morning")[, taxi_num]
if ('WeatherCondition' %in% colnames(morning_data)) {
  morning_data$WeatherCondition <- as.factor(morning_data$WeatherCondition)
  morning_data$IsRaining <- ifelse(morning_data$WeatherCondition %in% c("Light Rain", "Heavy Rain", "Rain"), 1, 0)  # Raining (1) vs. Not Raining (0)
}
morning_data <- morning_data[, !names(morning_data) %in% c("WeatherCondition")]
rownames(morning_data) <- NULL
morning_data <- morning_data[-c(2844, 2528, 3449), ]
morning_data$base_passenger_fare <- log(morning_data$base_passenger_fare)
morning_data$bcf <- log(morning_data$bcf)
morning_data$driver_pay <- log(morning_data$driver_pay)
morning_data$trip_time <- log(morning_data$trip_time)
morning_data <- na.omit(morning_data)


# Perform hierarchical clustering to determine initial cluster centers
morning_data[] <- lapply(morning_data, function(x) as.numeric(as.character(x)))

# Standardize the data for clustering
morning_data <- scale(morning_data)
hc <- hclust(dist(morning_data))
clusters <- cutree(hc, k = 3)
initial.centers <- as.matrix(aggregate(list(morning_data), by = list(cluster = clusters), FUN = mean)[, -1])
kmeans_pottery <- kmeans(morning_data, centers = initial.centers)

# Visualize k-means clustering
fviz_cluster(kmeans_pottery, data = morning_data,
             geom = "point",
             ellipse.type = "convex",
             main = "Morning K-means Clustering (k = 3) on PCA Plot", axes = c(1, 2))

fviz_cluster(kmeans_pottery, data = morning_data,
             geom = "point",
             ellipse.type = "convex",
             main = "Morning K-means Clustering (k = 3) on PCA Plot", axes = c(1, 3))


pca_result <- prcomp(morning_data, scale. = TRUE)
par(mfrow = c(1, 2), mar = c(10, 4, 4, 2) + 0.1) 
for (i in 1:2) {
  barplot(pca_result$rotation[, i],
          las = 2,
          cex.names = 0.7,
          main = paste("Morning PC", i, "Loadings"),
          ylab = "Loadings",
          xlab = "Variables")
}

###Within Variation
within_cluster_ss <- kmeans_pottery$withinss
total_within_cluster_variation <- sum(within_cluster_ss)
print(total_within_cluster_variation)

###Between Variation
global_mean <- colMeans(full_data)
between_cluster_ss <- sum(kmeans_pottery$size * rowSums((kmeans_pottery$centers - global_mean)^2))
print(between_cluster_ss)

#checking how many clusters
#gap statisitc
library(factoextra)
library(cluster)
gap_stat <- clusGap(morning_data, FUN = kmeans, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

#CH Index
par(mfrow = c(1, 2), mar = c(10, 4, 4, 2) + 0.1) 
library(fpc)
ch_index <- numeric(10)
for (k in 1:10) {
  # Apply K-means clustering
  km <- kmeans(morning_data, centers = k, nstart = 25)
    ch_index[k] <- calinhara(morning_data, km$cluster)
}
print(ch_index)
plot(1:10, ch_index, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters (k)",
     ylab = "Calinski-Harabasz Index",
     main = "Optimal Clusters Using CH Index")

##elbow plot
n <- nrow(morning_data)
wcv <- rep(0, 10)
wcv[1] <- (n - 1) * sum(sapply(morning_data, var))
for (i in 2:10) {
  wcv[i] <- sum(kmeans(morning_data, centers = i, nstart = 25)$withinss)
}
plot(1:10, wcv, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters",
     ylab = "Within-Cluster Sum of Squares",
     main = "Elbow Method for Optimal Clusters")

library(cluster)
kmedoids_result <- pam(morning_data, k = 3)
# Print
print(kmedoids_result$medoids)
fviz_cluster(kmedoids_result, data = morning_data,
             geom = "point",
             ellipse.type = "convex",
             main = "K-mediod Clustering (k = 3) on PCA Plot")
minimax <- protoclust(dist(morning_data))
plotwithprototypes(minimax, main = 'Dendrogram - Minimax Linkage')
rect.hclust(minimax, k = 2, border = "red")

##Model Based Clustering:----------------------------------------------------------
## Assessing Multinormality:
# Plot Kernel Densities 
par(mfrow = c(2, 3))
plot((density(log(morning_data$trip_miles))), main = "Kernel Density Estimation", xlab = "Trip Miles", ylab = "Density", col = "black", lwd = 2)
plot((density(morning_data$trip_time)), main = "Kernel Density Estimation", xlab = "TripTime", ylab = "Density", col = "black", lwd = 2)
plot((density((morning_data$bcf))), main = "Kernel Density Estimation", xlab = "Black Car Fee", ylab = "Density", col = "black", lwd = 2)
plot((density((morning_data$base_passenger_fare))), main = "Kernel Density Estimation", xlab = "Base Fare", ylab = "Density", col = "black", lwd = 2)
plot((density((log(morning_data$tip_percentage)))), main = "Kernel Density Estimation", xlab = "Tip Percentage", ylab = "Density", col = "black", lwd = 2)
plot((density((morning_data$temp))), main = "Kernel Density Estimation", xlab = "Temperature", ylab = "Density", col = "black", lwd = 2)

require(mclust)
set.seed(123)
mod <- Mclust(morning_data)
plot(mod, morning_data, what = "BIC", col = "black")
summary(mod)

morning_data$Cluster <- factor(mod$classification)

fviz_cluster(mod, data = morning_data,
             geom = "point",
             ellipse.type = "convex",
             main = "Morning Model-Based Clustering (k = 3) on PCA Plot", axes = c(1, 2))

###Within Variation
# Ensure data is a matrix
data <- as.matrix(mod$data)
cluster_assignments <- mod$classification
within_cluster_ss_model <- 0
for (k in unique(cluster_assignments)) {
  cluster_data <- data[cluster_assignments == k, , drop = FALSE]  # Subset data for the cluster
  cluster_mean <- colMeans(cluster_data)  # Compute cluster mean
  within_cluster_ss_model <- within_cluster_ss_model + sum(rowSums((cluster_data - cluster_mean)^2))  # Sum squared distances
}
print(paste("Within-Cluster Variation (Model):", within_cluster_ss_model))

###Between Variation
global_mean <- colMeans(data)
between_cluster_ss_model <- 0
for (k in unique(cluster_assignments)) {
  cluster_data <- data[cluster_assignments == k, , drop = FALSE]
  cluster_mean <- colMeans(cluster_data)
  cluster_size <- nrow(cluster_data)
  between_cluster_ss_model <- between_cluster_ss_model + cluster_size * sum((cluster_mean - global_mean)^2)
}
print(paste("Between-Cluster Variation (Model):", between_cluster_ss_model))

###MANOVA:----------------------------------------------------------
morning_data <- as.data.frame(morning_data)

morning_data$Cluster <- factor(kmeans_pottery$cluster)
# Select dependent variables
dependent_vars <- morning_data[, c("IsRaining", "tip_percentage", "trip_miles", "trip_time", "temp", "bcf")] 

# Perform MANOVA
fit <- manova(as.matrix(dependent_vars) ~ morning_data$Cluster)

# Summary of MANOVA using Wilks' Lambda
summary(fit, test = "Wilks")

########### UNIVARAITE ANOVA 
rain_aov <- aov(IsRaining ~ Cluster, data = morning_data)
summary(rain_aov)

# ANOVA for tip_percentage
tip_aov <- aov(tip_percentage ~ Cluster, data = morning_data)
summary(tip_aov)

# ANOVA for trip_miles
trip_aov <- aov(trip_miles ~ Cluster, data = morning_data)
summary(trip_aov)

# ANOVA for trip_time
trip_aov <- aov(trip_time ~ Cluster, data = morning_data)
summary(trip_aov)

# ANOVA for temp
trip_aov <- aov(temp ~ Cluster, data = morning_data)
summary(trip_aov)

# ANOVA for bcf
trip_aov <- aov(bcf ~ Cluster, data = morning_data)
summary(trip_aov)


###Boxplots
library(ggplot2)
ggplot(morning_data, aes(x = Cluster, y = tip_percentage, fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Morning Tip Percentage by Cluster", x = "Cluster", y = "Tip Percentage") +
  theme_minimal()

library(ggplot2)
ggplot(morning_data, aes(x = Cluster, y = log(trip_time), fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Morning Trip duration by Cluster", x = "Cluster", y = "Trip Duration") +
  theme_minimal()

library(ggplot2)
ggplot(morning_data, aes(x = Cluster, y = trip_miles, fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Morning Trip Distance by Cluster", x = "Cluster", y = "Trip Distance") +
  theme_minimal()

library(ggplot2)
ggplot(morning_data, aes(x = Cluster, y = bcf, fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Morning Black Car Fee by Cluster", x = "Cluster", y = "Black Car Fee") +
  theme_minimal()

library(ggplot2)
ggplot(morning_data, aes(x = Cluster, y = temp, fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Morning Temperature by Cluster", x = "Cluster", y = "Temperature") +
  theme_minimal()


#####Bonferroni Correction
# ANOVA for tip_percentage
library(DescTools)
anova_tip <- aov(tip_percentage ~ Cluster, data = morning_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

library(DescTools)
anova_tip <- aov(temp ~ Cluster, data = morning_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)


library(DescTools)
anova_tip <- aov(IsRaining ~ Cluster, data = morning_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

library(DescTools)
anova_tip <- aov(bcf ~ Cluster, data = morning_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

library(DescTools)
anova_tip <- aov(trip_miles ~ Cluster, data = morning_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

###########NOON DATA#####################################################################################
library(tidyverse)
library(factoextra)
taxi_num <- c('trip_miles', 'trip_time', 'base_passenger_fare', 'tolls', 'bcf', 
              'sales_tax', 'congestion_surcharge', 'airport_fee', 'driver_pay', 
              'temp', 'rhum', 'wdir', 'wspd', 'tip_percentage', 'WeatherCondition')
# Morning K-means Clustering:
noon_data <- subset(taxi, PeriodOfDay == "Noon")[, taxi_num]
if ('WeatherCondition' %in% colnames(noon_data)) {
  noon_data$WeatherCondition <- as.factor(noon_data$WeatherCondition)
  noon_data$IsRaining <- ifelse(noon_data$WeatherCondition %in% c("Light Rain", "Heavy Rain", "Rain"), 1, 0)  # Raining (1) vs. Not Raining (0)
}
noon_data <- noon_data[, !names(noon_data) %in% c("WeatherCondition")]

rownames(noon_data) <- NULL
noon_data <- noon_data[-c(1338, 1683, 793), ]
noon_data$base_passenger_fare <- log(noon_data$base_passenger_fare)
noon_data$bcf <- log(noon_data$bcf)
noon_data$driver_pay <- log(noon_data$driver_pay)
noon_data$trip_time <- log(noon_data$trip_time)
noon_data <- na.omit(noon_data)

noon_data[] <- lapply(noon_data, function(x) as.numeric(as.character(x)))

# Standardize the data for clustering
noon_data <- scale(noon_data)
hc <- hclust(dist(noon_data))
clusters <- cutree(hc, k = 2)
initial.centers <- as.matrix(aggregate(list(noon_data), by = list(cluster = clusters), FUN = mean)[, -1])
kmeans_pottery <- kmeans(noon_data, centers = initial.centers)

# Visualize k-means clustering
fviz_cluster(kmeans_pottery, data = noon_data,
             geom = "point",
             ellipse.type = "convex",
             main = "Noon K-means Clustering (k = 2) on PCA Plot")

###Within Variation
within_cluster_ss <- kmeans_pottery$withinss
total_within_cluster_variation <- sum(within_cluster_ss)
print(total_within_cluster_variation)

###Between Variation
global_mean <- colMeans(full_data)

# Between-cluster sum of squares
between_cluster_ss <- sum(kmeans_pottery$size * rowSums((kmeans_pottery$centers - global_mean)^2))
print(between_cluster_ss)

pca_result <- prcomp(noon_data, scale. = TRUE)
# Loop over the first three principal components and plot their loading
par(mfrow = c(1, 3), mar = c(10, 4, 4, 2) + 0.1)  
for (i in 1:2) {
  barplot(pca_result$rotation[, i],
          las = 2,
          cex.names = 0.7,
          main = paste("Noon PC", i, "Loadings"),
          ylab = "Loadings",
          xlab = "Variables")
}

#checking how many clusters
#gap statisitc
library(factoextra)
library(cluster)
gap_stat <- clusGap(noon_data, FUN = kmeans, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

#CH Index
par(mfrow = c(1, 2))
library(fpc)
ch_index <- numeric(10)
for (k in 1:10) {
  # Apply K-means clustering
  km <- kmeans(noon_data, centers = k, nstart = 25)
  ch_index[k] <- calinhara(noon_data, km$cluster)
}
print(ch_index)
# Plot the CH index to find the optimal number of clusters
plot(1:10, ch_index, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters (k)",
     ylab = "Calinski-Harabasz Index",
     main = "Optimal Clusters Using CH Index")

##elbow plot
n <- nrow(noon_data)
wcv <- rep(0, 10)
wcv[1] <- (n - 1) * sum(sapply(noon_data, var))
for (i in 2:10) {
  wcv[i] <- sum(kmeans(noon_data, centers = i, nstart = 25)$withinss)
}
plot(1:10, wcv, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters",
     ylab = "Within-Cluster Sum of Squares",
     main = "Elbow Method for Optimal Clusters")

##Model Based Clustering:----------------------------------------------------------
require(mclust)
set.seed(123)
mod <- Mclust(noon_data)
plot(mod, noon_data, what = "BIC", col = "black")
summary(mod)

fviz_cluster(mod, data = noon_data,
             geom = "point",
             ellipse.type = "convex",
             main = "Noon Model-Based Clustering (k = 6) on PCA Plot")

###Within Variation
# Ensure data is a matrix
data <- as.matrix(mod$data)
cluster_assignments <- mod$classification
within_cluster_ss_model <- 0
for (k in unique(cluster_assignments)) {
  cluster_data <- data[cluster_assignments == k, , drop = FALSE]  # Subset data for the cluster
  cluster_mean <- colMeans(cluster_data)  # Compute cluster mean
  within_cluster_ss_model <- within_cluster_ss_model + sum(rowSums((cluster_data - cluster_mean)^2))  # Sum squared distances
}
print(paste("Within-Cluster Variation (Model):", within_cluster_ss_model))


###Between Variation
global_mean <- colMeans(data)
between_cluster_ss_model <- 0
for (k in unique(cluster_assignments)) {
  cluster_data <- data[cluster_assignments == k, , drop = FALSE]
  cluster_mean <- colMeans(cluster_data)
  cluster_size <- nrow(cluster_data)
  between_cluster_ss_model <- between_cluster_ss_model + cluster_size * sum((cluster_mean - global_mean)^2)
}
print(paste("Between-Cluster Variation (Model):", between_cluster_ss_model))

###MANOVA:----------------------------------------------------------
noon_data <- as.data.frame(noon_data)

noon_data$Cluster <- factor(kmeans_pottery$cluster)
# Select dependent variables
dependent_vars <- noon_data[, c("IsRaining", "tip_percentage", "trip_miles", "trip_time", "temp")] 

# Perform MANOVA
fit <- manova(as.matrix(dependent_vars) ~ noon_data$Cluster)

# Summary of MANOVA using Wilks' Lambda
summary(fit, test = "Wilks")

########### UNIVARAITE ANOVA 
rain_aov <- aov(IsRaining ~ Cluster, data = noon_data)
summary(rain_aov)

# ANOVA for tip_percentage
tip_aov <- aov(tip_percentage ~ Cluster, data = noon_data)
summary(tip_aov)

# ANOVA for trip_miles
trip_aov <- aov(trip_miles ~ Cluster, data = noon_data)
summary(trip_aov)

# ANOVA for trip_time
trip_aov <- aov(trip_time ~ Cluster, data = noon_data)
summary(trip_aov)

# ANOVA for temp
trip_aov <- aov(temp ~ Cluster, data = noon_data)
summary(trip_aov)

# ANOVA for bcf
trip_aov <- aov(bcf ~ Cluster, data = noon_data)
summary(trip_aov)


library(ggplot2)
ggplot(noon_data, aes(x = Cluster, y = tip_percentage, fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Noon Tip Percentage by Cluster", x = "Cluster", y = "Tip Percentage") +
  theme_minimal()

library(ggplot2)
ggplot(noon_data, aes(x = Cluster, y = log(trip_time), fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Noon Trip duration by Cluster", x = "Cluster", y = "Trip Duration") +
  theme_minimal()

library(ggplot2)
ggplot(noon_data, aes(x = Cluster, y = log(trip_miles), fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Noon Trip Distance by Cluster", x = "Cluster", y = "Trip Distance") +
  theme_minimal()

library(ggplot2)
ggplot(noon_data, aes(x = Cluster, y = log(bcf), fill = Cluster)) +
  geom_boxplot() +
  labs(title = "Noon Black Car Fee by Cluster", x = "Cluster", y = "Black Car Fee") +
  theme_minimal()

table(morning_data$Cluster)

#####Pairwise ANOVA
# ANOVA for tip_percentage
library(DescTools)
anova_tip <- aov(tip_percentage ~ Cluster, data = noon_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

library(DescTools)
anova_tip <- aov(temp ~ Cluster, data = noon_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

library(DescTools)
anova_tip <- aov(IsRaining ~ Cluster, data = noon_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

library(DescTools)
anova_tip <- aov(trip_miles ~ Cluster, data = noon_data)
bonf_tip <- PostHocTest(anova_tip, method = "bonferroni")
print(bonf_tip)

###########Evening DATA#####################################################################################
library(tidyverse)
library(factoextra)
taxi_num <- c('trip_miles', 'trip_time', 'base_passenger_fare', 'tolls', 'bcf', 
              'sales_tax', 'congestion_surcharge', 'airport_fee', 'driver_pay', 
              'temp', 'rhum', 'wdir', 'wspd', 'tip_percentage', 'WeatherCondition')
# Morning K-means Clustering:
evening_data <- subset(taxi, PeriodOfDay == "Evening")[, taxi_num]
if ('WeatherCondition' %in% colnames(evening_data)) {
  evening_data$WeatherCondition <- as.factor(evening_data$WeatherCondition)
  evening_data$IsRaining <- ifelse(evening_data$WeatherCondition %in% c("Light Rain", "Heavy Rain", "Rain"), 1, 0)  # Raining (1) vs. Not Raining (0)
}
evening_data <- evening_data[, !names(evening_data) %in% c("WeatherCondition")]

rownames(evening_data) <- NULL
evening_data <- evening_data[-c(536, 536, 1129), ]
evening_data$base_passenger_fare <- log(evening_data$base_passenger_fare)
evening_data$bcf <- log(evening_data$bcf)
evening_data$driver_pay <- log(evening_data$trip_miles)
evening_data$trip_time <- log(evening_data$trip_time)
evening_data <- na.omit(evening_data)

evening_data[] <- lapply(evening_data, function(x) as.numeric(as.character(x)))

# Standardize the data for clustering
evening_data <- scale(evening_data)
hc <- hclust(dist(evening_data))
clusters <- cutree(hc, k = 2)

initial.centers <- as.matrix(aggregate(list(evening_data), by = list(cluster = clusters), FUN = mean)[, -1])

# Perform k-means clustering using the initial centers
kmeans_pottery <- kmeans(evening_data, centers = initial.centers)

# Visualize k-means clustering
fviz_cluster(kmeans_pottery, data = evening_data,
             geom = "point",
             ellipse.type = "convex",
             main = "Evening K-means Clustering (k = 2) on PCA Plot")

pca_result <- prcomp(evening_data, scale. = TRUE)
# Loop over the first three principal components and plot their loading
for (i in 1:2) {
  barplot(pca_result$rotation[, i],
          las = 2,
          cex.names = 0.7,
          main = paste("PC", i, "Loadings"),
          ylab = "Loadings",
          xlab = "Variables")
}

#checking how many clusters
#gap statisitc
library(factoextra)
library(cluster)
gap_stat <- clusGap(evening_data, FUN = kmeans, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

#CH Index
library(fpc)
ch_index <- numeric(10)
for (k in 1:10) {
  # Apply K-means clustering
  km <- kmeans(evening_data, centers = k, nstart = 25)
  ch_index[k] <- calinhara(evening_data, km$cluster)
}
print(ch_index)
# Plot the CH index to find the optimal number of clusters
plot(1:10, ch_index, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters (k)",
     ylab = "Calinski-Harabasz Index",
     main = "Optimal Clusters Using CH Index")

##elbow plot
n <- nrow(evening_data)
wcv <- rep(0, 10)
wcv[1] <- (n - 1) * sum(sapply(evening_data, var))
for (i in 2:10) {
  wcv[i] <- sum(kmeans(noon_data, centers = i, nstart = 25)$withinss)
}
plot(1:10, wcv, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters",
     ylab = "Within-Cluster Sum of Squares",
     main = "Elbow Method for Optimal Clusters")

##Model Based Clustering:----------------------------------------------------------
require(mclust)
set.seed(123)
mod <- Mclust(evening_data)
plot(mod, evening_data, what = "BIC", col = "black")
summary(mod)

noon_data$Cluster <- factor(mod$classification)
boxplot(evening_data$tip_percentage ~ evening_data$Cluster,
        main = "Tip Percentage by Cluster",
        xlab = "Cluster",
        ylab = "Tip Percentage",
        col = "violet")

###MANOVA:----------------------------------------------------------

evening_data$Cluster <- factor(mod$classification)

# Select the dependent variables and exclude the grouping variable
dependent_vars <- evening_data[, c("IsRaining", "tip_percentage", "trip_miles")]

# Perform MANOVA
fit <- manova(as.matrix(dependent_vars) ~ evening_data$Cluster)

# Summary of MANOVA using Wilks' Lambda
summary(fit, test = "Wilks")



# Perform ANOVA for tip_percentage
rain_aov <- aov(IsRaining ~ Cluster, data = evening_data)
summary(tip_aov)

tip_aov <- aov(tip_percentage ~ Cluster, data = evening_data)
summary(tip_aov)

miles_aov <- aov(trip_miles ~ Cluster, data = evening_data)
summary(tip_aov)

###########Full DATA#####################################################################################




##K-means Clustering: ----------------------------------------------------------------
library(tidyverse)
library(factoextra)
taxi_num <- c('trip_miles', 'trip_time', 'base_passenger_fare', 'tolls', 'bcf', 
              'sales_tax', 'congestion_surcharge', 'airport_fee', 'driver_pay', 
              'temp', 'rhum', 'wdir', 'wspd', 'PeriodOfDay', 'tip_percentage', 'WeatherCondition')

# Full data K-means Clustering:
full_data <- subset(taxi,)[, taxi_num]
# Process WeatherCondition and PeriodOfDay 
if ('WeatherCondition' %in% colnames(full_data)) {
  full_data$WeatherCondition <- as.factor(full_data$WeatherCondition)
  full_data$IsRaining <- ifelse(full_data$WeatherCondition %in% c("Light Rain", "Heavy Rain", "Rain"), 1, 0)  
}

if ('PeriodOfDay' %in% colnames(full_data)) {
  # Map PeriodOfDay to numeric values: morning = 0, noon = 1, evening = 2
  full_data$PeriodOfDay <- ifelse(full_data$PeriodOfDay == "Morning", 0,
                                  ifelse(full_data$PeriodOfDay == "Noon", 1,
                                         ifelse(full_data$PeriodOfDay == "Evening", 2, NA)))
}

# Drop WeatherCondition column
full_data <- full_data[, !names(full_data) %in% c("WeatherCondition")]

rownames(full_data) <- NULL
full_data <- full_data[-c(2531, 5031), ]
full_data$base_passenger_fare <- log(full_data$base_passenger_fare)
full_data$bcf <- log(full_data$bcf)
full_data$trip_time <- log(full_data$trip_time)
full_data <- na.omit(full_data)



# Perform hierarchical clustering to determine initial cluster centers
full_data[] <- lapply(full_data, function(x) as.numeric(as.character(x)))

# Standardize the data for clustering
full_data <- scale(full_data)
hc <- hclust(dist(full_data))
clusters <- cutree(hc, k = 2)

initial.centers <- as.matrix(aggregate(list(full_data), by = list(cluster = clusters), FUN = mean)[, -1])

# Perform k-means clustering using the initial centers
kmeans_pottery <- kmeans(full_data, centers = initial.centers)

# Visualize k-means clustering
fviz_cluster(kmeans_pottery, data = full_data,
             geom = "point",
             ellipse.type = "convex",
             main = "K-means Clustering (k = 2) on PCA Plot")


pca_result <- prcomp(full_data, scale. = TRUE)
# Loop over the first three principal components and plot their loading
for (i in 1:2) {
  barplot(pca_result$rotation[, i],
          las = 2,
          cex.names = 0.7,
          main = paste("PC", i, "Loadings"),
          ylab = "Loadings",
          xlab = "Variables")
}


#checking how many clusters
#gap statisitc
library(factoextra)
library(cluster)
gap_stat <- clusGap(full_data, FUN = kmeans, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

#CH Index
library(fpc)
ch_index <- numeric(10)
for (k in 1:10) {
  # Apply K-means clustering
  km <- kmeans(full_data, centers = k, nstart = 25)
  ch_index[k] <- calinhara(full_data, km$cluster)
}
print(ch_index)
# Plot the CH index to find the optimal number of clusters
plot(1:10, ch_index, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters (k)",
     ylab = "Calinski-Harabasz Index",
     main = "Optimal Clusters Using CH Index")

##elbow plot
n <- nrow(full_data)
wcv <- rep(0, 10)
wcv[1] <- (n - 1) * sum(sapply(full_data, var))
for (i in 2:10) {
  wcv[i] <- sum(kmeans(full_data, centers = i, nstart = 25)$withinss)
}
plot(1:10, wcv, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters",
     ylab = "Within-Cluster Sum of Squares",
     main = "Elbow Method for Optimal Clusters")

library(cluster)
kmedoids_result <- pam(full_data, k = 3)
# Print
print(full_data$medoids)
fviz_cluster(kmedoids_result, data = full_data,
             geom = "point",
             ellipse.type = "convex",
             main = "K-mediod Clustering (k = 3) on PCA Plot")
minimax <- protoclust(dist(full_data))
plotwithprototypes(minimax, main = 'Dendrogram - Minimax Linkage')
rect.hclust(minimax, k = 2, border = "red")

##Model Based Clustering:----------------------------------------------------------
require(mclust)
set.seed(123)
mod <- Mclust(full_data)
plot(mod, full_data, what = "BIC", col = "black")
summary(mod)

morning_data$Cluster <- factor(mod$classification)
boxplot(morning_data$tip_percentage ~ morning_data$Cluster,
        main = "Tip Percentage by Cluster",
        xlab = "Cluster",
        ylab = "Tip Percentage",
        col = "violet")

###MANOVA:----------------------------------------------------------

full_data$Cluster <- factor(mod$classification)

# Select the dependent variables and exclude the grouping variable
dependent_vars <- full_data[, c("IsRaining", "tip_percentage", "trip_time")]

# Perform MANOVA
fit <- manova(as.matrix(dependent_vars) ~ full_data$Cluster)

# Summary of MANOVA using Wilks' Lambda
summary(fit, test = "Wilks")



# Perform ANOVA for tip_percentage
tip_aov <- aov(IsRaining ~ Cluster, data = morning_data)
summary(tip_aov)

tip_aov <- aov(IsRaining ~ Cluster, data = morning_data)
summary(tip_aov)


#######APPENDIX############################################################################
####Hierarchical Clustering: ----------------------------------------------------------------

### Morning Hierarchical
library(protoclust)
morning <- morning_data[var]
morning$WeatherCondition <- as.factor(morning$WeatherCondition)
dist.mat <- dist(morning)

## Complete linkage
hc<-hclust(dist.mat, method="ward.")
plot(hc)
cutree(hc, k = 2)
hc <- hclust(dist(morning_data), method = 'complete')
plot(hc, main = 'Hierarchical Clustering Dendrogram (Ward Linkage)', xlab = 'Sample Index', ylab = 'Distance')
# Cut the dendrogram to create 3 clusters
clusters <- cutree(hc, k = 3)

#minimax linkage
minimax <- protoclust(dist(morning))
plotwithprototypes(minimax, main = 'Dendrogram - Minimax Linkage')
rect.hclust(minimax, k = 3, border = "red")

## Subset
# Take a random sample of 500 observations for better visualization
set.seed(123)
sample_indices <- sample(1:nrow(morning), size = min(100, nrow(morning)))
df_sampled <- morning[sample_indices, ]

# Hierarchical Clustering for quantitative variables on the sampled data
hc_sampled <- hclust(dist(df_sampled), method = 'ward.D2')
plot(hc_sampled, main = 'Hierarchical Clustering Dendrogram (Ward Linkage, Sampled Data)', xlab = 'Sample Index', ylab = 'Distance')

#minimax linkage
minimax <- protoclust(dist(df_sampled))
plotwithprototypes(minimax, main = 'Dendrogram - Minimax Linkage')
rect.hclust(minimax, k = 6, border = "red")


### Noon Hierarchical
library(protoclust)
noon <- noon_data[var]
noon$WeatherCondition <- as.factor(noon$WeatherCondition)
dist.mat1 <- dist(noon)

## Complete linkage
hc<-hclust(dist.mat1, method="complete")
plot(hc)
cutree(hc, k = 2)
hc <- hclust(dist(noon), method = 'complete')
plot(hc, main = 'Hierarchical Clustering Dendrogram (Ward Linkage)', xlab = 'Sample Index', ylab = 'Distance')
# Cut the dendrogram to create 3 clusters
clusters <- cutree(hc, k = 3)

#minimax linkage
minimax <- protoclust(dist(noon))
plotwithprototypes(minimax, main = 'Dendrogram - Minimax Linkage')
rect.hclust(minimax, k = 3, border = "red")

## Subset
# Take a random sample of 500 observations for better visualization
set.seed(123)
sample_indices <- sample(1:nrow(noon), size = min(100, nrow(noon)))
df_sampled1 <- morning[sample_indices, ]

# Hierarchical Clustering for quantitative variables on the sampled data
hc_sampled <- hclust(dist(df_sampled1), method = 'complete')
plot(hc_sampled, main = 'Hierarchical Clustering Dendrogram (Ward Linkage, Sampled Data)', xlab = 'Sample Index', ylab = 'Distance')

#minimax linkage
minimax <- protoclust(dist(df_sampled1))
plotwithprototypes(minimax, main = 'Dendrogram - Minimax Linkage')
rect.hclust(minimax, k = 6, border = "red")

