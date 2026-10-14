# Multivariate Analysis of Air Pollution Patterns Across Monitoring Stations in India

**M.Sc. Dissertation Project | Statistics and Computing**

This project was completed as part of my Master of Science in Statistics and Computing at **Banaras Hindu University (BHU)**, under the guidance of **Prof. Sanjeev Kumar**.

The study investigates air pollution patterns across monitoring stations in India using multivariate statistical techniques and hypothesis testing in R. It explores differences in pollutant concentrations, relationships among pollutants, underlying pollution factors, and similarities between monitoring stations.

---

## Project Overview

Air pollution is a major environmental concern, and pollutant concentrations can vary across locations due to differences in urbanisation, industrial activity, transportation, and other factors.

This project applies multivariate statistical methods to study the distribution and relationships of major air pollutants across monitoring stations in India.

The analysis focuses on exploratory data analysis, statistical hypothesis testing, dimensionality reduction, factor analysis, and clustering.

---

## Dataset

The dataset contains air pollution measurements from monitoring stations across India.

**Pollutants analysed:**
- PM2.5
- PM10
- NO2
- SO2
- CO
- OZONE
- NH3

**Other information:** Monitoring-station identifiers and available geographical details, including state, city, and coordinates.

**Data source:** Refer to the dissertation report and the data documentation included in this repository for the source and details of the dataset.

---

## Objectives

- Explore the distribution of major air pollutants across monitoring stations.
- Examine differences in pollutant concentrations across states.
- Investigate relationships between different pollutants.
- Apply Principal Component Analysis (PCA) to reduce dimensionality.
- Use Factor Analysis to identify underlying pollutant patterns.
- Apply K-means clustering to group monitoring stations based on pollution characteristics.
- Interpret the statistical results to understand broad air pollution patterns.

---

## Methodology

The project follows these major steps:

1. **Data Preparation** – Organising pollutant measurements and relevant station information.
2. **Exploratory Data Analysis (EDA)** – Examining distributions, summary statistics, and pollution patterns.
3. **Hypothesis Testing** – Using the Kruskal–Wallis test to investigate differences in pollutant concentrations across states.
4. **Correlation Analysis** – Applying Spearman's rank correlation to study relationships between pollutants.
5. **Principal Component Analysis (PCA)** – Reducing dimensionality and identifying major sources of variation in the data.
6. **Factor Analysis** – Exploring latent factors associated with pollutant patterns using Varimax rotation.
7. **K-means Clustering** – Grouping monitoring stations according to their pollution characteristics.
8. **Cluster Interpretation** – Comparing the resulting clusters to identify broad pollution profiles.

---

## Tools and Libraries

- **Programming Language:** R
- **Statistical Techniques:** Hypothesis Testing, Correlation Analysis, PCA, Factor Analysis, K-means Clustering
- **Visualisation:** R plotting and visualisation tools

The exact package dependencies and execution instructions should be documented alongside the R scripts.

---

## Key Findings

The dissertation reports the following findings:

- Statistically significant differences in the concentrations of the seven analysed pollutants across states.
- The first four principal components explain approximately **80.79% of the total variance**.
- Factor Analysis identifies three broad latent factors interpreted as particulate, vehicular/secondary, and industrial pollution patterns.
- K-means clustering groups monitoring stations into three broad pollution profiles.
- The reported silhouette score is approximately **0.23**, suggesting that separation between clusters is limited and that some overlap exists between groups.

These findings are based on the analyses documented in the dissertation. The interpretations should be considered in light of the dataset's limitations and the assumptions of the statistical methods used.

---

## Limitations

- Unequal numbers of monitoring stations across states may affect comparisons.
- Missing observations may influence the analyses.
- The study focuses on multivariate pollution patterns rather than temporal changes.
- The reported cluster separation is limited, so cluster assignments should be interpreted cautiously.

---

## Repository Structure

```text
Air-Pollution-Multivariate-Analysis/
│
├── R/
│   └── R analysis scripts
│
├── data/
│   └── Dataset files
│
├── Air_Pollution_Multivariate_Analysis_Report.pdf
├── README.md
├── LICENSE
└── .gitignore
```

---

## How to Run

1. Clone this repository:

   ```bash
   git clone https://github.com/soham-1018/Air-Pollution-Multivariate-Analysis.git
   ```

2. Open the project in RStudio.

3. Check the `data/` folder and update the data-file path in the R script if necessary.

4. Install the R packages required by the script.

5. Run the analysis script from the `R/` folder.

**Note:** The exact script filename, required packages, and data-loading instructions should be confirmed against the files in the repository before attempting to reproduce the results.

---

## Dissertation Report

The complete M.Sc. dissertation report is available in the repository:

`Air_Pollution_Multivariate_Analysis_Report.pdf`

---

## Author

**Soham Choudhury**

M.Sc. Statistics and Computing  
Banaras Hindu University (BHU)

GitHub: https://github.com/soham-1018
