
# ============================================================
# PROJECT TITLE:
# Multivariate Analysis of Air Pollution Patterns Across
# Monitoring Stations in India
#
# PROGRAMMING LANGUAGE: R
#
# STATISTICAL TECHNIQUES:
# 1. Exploratory Data Analysis (EDA)
# 2. Spearman Correlation Analysis
# 3. Kruskal-Wallis Hypothesis Testing
# 4. Principal Component Analysis (PCA)
# 5. Factor Analysis (FA)
# 6. K-means Clustering
#
# ============================================================


# ------------------------------------------------------------
# STEP 1: ENVIRONMENT SETUP AND LIBRARY LOADING
# ------------------------------------------------------------

# Clear all objects from the current R environment
rm(list=ls())

# Load the libraries required for the analysis
library(readxl)    # Import Excel datasets
library(dplyr)     # Data manipulation
library(tidyr)     # Data reshaping and handling missing values
library(psych)     # PCA-related diagnostics and Factor Analysis
library(ggplot2)   # Data visualisation
library(corrplot)  # Correlation matrix visualisation
library(cluster)   # Cluster analysis and related tools


# ------------------------------------------------------------
# STEP 2: LOAD THE DATASET
# ------------------------------------------------------------

# Import the air pollution dataset from an Excel file
df_raw <- read_excel("C:/Users/lenovo/Desktop/M.Sc. Dissertation/pollution_data.xlsx")


# ------------------------------------------------------------
# STEP 3: DATA CLEANING AND PREPROCESSING
# ------------------------------------------------------------

# Replace invalid pollutant values with NA
# Convert pollutant concentrations into numeric format
df_raw$pollutant_avg[df_raw$pollutant_avg %in% c("NA","--","")] <- NA
df_raw$pollutant_avg <- as.numeric(df_raw$pollutant_avg)

# Select the relevant columns required for the analysis
df_selected <- df_raw %>%
  select(station, state, city, latitude, longitude, pollutant_id, pollutant_avg)

# Handle duplicate records by calculating the mean pollutant
# concentration for each station and pollutant combination
df_selected <- df_selected %>%
  group_by(station, state, city, latitude, longitude, pollutant_id) %>%
  summarise(pollutant_avg = mean(pollutant_avg, na.rm = TRUE), .groups = "drop")

# Convert the dataset from long format to wide format
# Each pollutant becomes a separate column
df_wide <- df_selected %>%
  pivot_wider(
    id_cols = c(station, state),
    names_from = pollutant_id,
    values_from = pollutant_avg
  )

# Define the pollutants included in the analysis
pollutants <- c("PM2.5","PM10","NO2","SO2","CO","OZONE","NH3")

# Retain observations with no more than two missing pollutant values
df_clean <- df_wide %>%
  filter(rowSums(is.na(across(all_of(pollutants)))) <= 2)

# Convert the cleaned dataset into long format for visualisation
df_long <- df_clean %>%
  pivot_longer(cols = all_of(pollutants),
               names_to = "pollutant",
               values_to = "concentration")


# ------------------------------------------------------------
# STEP 4: EXPLORATORY DATA ANALYSIS (EDA)
# ------------------------------------------------------------

# Visualise the distribution of each pollutant using histograms
# Separate panels allow each pollutant to have its own scale
ggplot(df_long, aes(x = concentration)) +
  geom_histogram(bins = 30) +
  facet_wrap(~ pollutant, scales = "free")

# Compare the distributions of major pollutants across states
# Boxplots help visualise medians, spread and potential outliers
ggplot(df_long %>% filter(pollutant %in% main_pollutants),
       aes(x = state, y = concentration)) +
  geom_boxplot() +
  facet_wrap(~ pollutant, scales = "free", ncol = 2) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 6),   # Reduce label size
    strip.text = element_text(face = "bold")
  ) +
  labs(title = "Distribution of Major Pollutants Across States",
       x = "State",
       y = "Concentration")


# ------------------------------------------------------------
# STEP 5: SPEARMAN CORRELATION ANALYSIS
# ------------------------------------------------------------

# Calculate Spearman rank correlations between pollutants
# Pairwise complete observations are used for each correlation
cor_mat <- cor(df_clean[, pollutants],
               use = "pairwise.complete.obs",
               method = "spearman")

# Visualise the correlation matrix as a heatmap
corrplot(cor_mat,
         method = "color",
         type = "upper",
         tl.col = "black",
         title = "Correlation Heatmap",
         mar = c(0,0,1,0))


# ------------------------------------------------------------
# STEP 6: KRUSKAL-WALLIS HYPOTHESIS TESTING
# ------------------------------------------------------------

# Perform a separate Kruskal-Wallis test for each pollutant
# The test examines whether pollutant distributions differ
# across states
kw_results <- lapply(pollutants, function(p) {
  formula <- as.formula(paste(p, "~ state"))
  test <- kruskal.test(formula, data = df_clean)
  data.frame(
    pollutant = p,
    statistic = test$statistic,
    p_value = test$p.value
  )
})

# Combine the individual test results into one data frame
kw_results_df <- do.call(rbind, kw_results)

# Display the Kruskal-Wallis test results
print(kw_results_df)


# ------------------------------------------------------------
# STEP 7: PRINCIPAL COMPONENT ANALYSIS (PCA)
# ------------------------------------------------------------

# Retain complete observations for the selected pollutants
df_pca <- df_clean %>%
  drop_na(all_of(pollutants))

# Preserve station and state information for reference
station_info <- df_pca[, c("station", "state")]

# Select the pollutant measurements for PCA
pca_data <- df_pca[, pollutants]

# Apply log transformation and standardisation
pca_scaled <- scale(log1p(pca_data))

# Perform Principal Component Analysis
pca_result <- prcomp(pca_scaled, center = TRUE, scale. = TRUE)

# Display the PCA summary, including variance explained
summary(pca_result)

# Calculate and display the eigenvalues of the components
eigenvalues <- pca_result$sdev^2
print(eigenvalues)

# Generate a scree plot to examine component eigenvalues
plot(eigenvalues, type = "b",
     xlab = "Principal Component",
     ylab = "Eigenvalue",
     main = "Scree Plot for PCA")

# Add a reference line at eigenvalue = 1
abline(h = 1, col = "red", lty = 2)

# Display the proportion and cumulative proportion of variance
var_explained <- summary(pca_result)$importance
print(var_explained)

# Extract and display the principal component loadings
loadings <- pca_result$rotation
round(loadings, 3)


# ------------------------------------------------------------
# STEP 8: FACTOR ANALYSIS (FA)
# ------------------------------------------------------------

# Retain complete observations for Factor Analysis
df_fa <- df_clean %>%
  drop_na(all_of(pollutants))

# Select the pollutant measurements
fa_data <- df_fa[, pollutants]

# Apply log transformation and standardisation
fa_scaled <- scale(log1p(fa_data))

# Kaiser-Meyer-Olkin (KMO) test:
# Assess the adequacy of the data for Factor Analysis
KMO(fa_scaled)

# Bartlett's test of sphericity:
# Examine whether the correlation matrix differs from identity
cortest.bartlett(fa_scaled)

# Parallel analysis to help assess the number of factors
fa.parallel(fa_scaled, fa = "fa", n.iter = 100)

# Specify the number of factors to retain
nfactors <- 3

# Fit a Maximum Likelihood Factor Analysis model
# Apply Varimax rotation to simplify factor interpretation
fa_result <- fa(fa_scaled, nfactors = nfactors, rotate = "varimax",
                fm = "ml")

# Display the Factor Analysis results
print(fa_result)

# Extract factor loadings and display loadings above 0.3
loadings_fa <- fa_result$loadings
print(loadings_fa, cutoff = 0.3)

# Display the complete factor loading matrix
print(loadings_fa)

# Extract the factor scores for each observation
fa_scores <- as.data.frame(fa_result$scores)

# Combine factor scores with station and state information
final_fa <- cbind(df_fa[, c("station", "state")], fa_scores)


# ------------------------------------------------------------
# STEP 9: K-MEANS CLUSTERING
# ------------------------------------------------------------

# Select the factor scores used as input variables for clustering
cluster_data <- final_fa[, c("Particulate", 
                             "Vehicular_Secondary", 
                             "Industrial")]

# Standardise the factor scores before clustering
cluster_scaled <- scale(cluster_data)

# Initialise a vector to store within-cluster sum of squares
wss <- numeric(10)

# Apply K-means for cluster counts from 1 to 10
# The within-cluster sum of squares is recorded for each model
for(i in 1:10){
  kmeans_model <- kmeans(cluster_scaled, centers = i, nstart = 25)
  wss[i] <- kmeans_model$tot.withinss
}

# Generate the elbow plot to examine the number of clusters
plot(1:10, wss, type = "b",
     xlab = "Number of Clusters",
     ylab = "Within Sum of Squares",
     main = "Elbow Method")

# Fit the final K-means model using three clusters
kmeans_result <- kmeans(cluster_scaled, centers = 3, nstart = 25)

# Store the cluster assignments
final_fa$cluster <- as.factor(kmeans_result$cluster)

# Extract and display the cluster centres
cluster_centers <- kmeans_result$centers
print(cluster_centers)

# Assign descriptive names to the three clusters
final_fa$cluster_label <- recode(final_fa$cluster,
                                 "1" = "Industrial_Vehicular",
                                 "2" = "Low_Pollution",
                                 "3" = "Particulate_Vehicular")


# ------------------------------------------------------------
# STEP 10: STATE-WISE CLUSTER DISTRIBUTION
# ------------------------------------------------------------

# Calculate the proportion of each cluster within each state
state_cluster_distribution <- prop.table(
  table(final_fa$state, final_fa$cluster_label),
  margin = 1
)

# Display state-wise cluster proportions
print(state_cluster_distribution)

# Calculate and display the number of observations
# in each cluster for every state
state_cluster_counts <- table(final_fa$state, final_fa$cluster_label)
print(state_cluster_counts)

# Visualise the proportion of pollution clusters across states
final_fa %>%
  count(state, cluster_label) %>%
  group_by(state) %>%
  mutate(prop = n / sum(n)) %>%
  ggplot(aes(x = state, y = prop, fill = cluster_label)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "State-wise Distribution of Pollution Clusters",
       x = "State",
       y = "Proportion",
       fill = "Cluster Type")


# ------------------------------------------------------------
# STEP 11: FINAL CLUSTER SUMMARY
# ------------------------------------------------------------

# Display the total number of observations in each cluster
table(final_fa$cluster_label)


# ============================================================
# END OF ANALYSIS
# ===========================================================
