## Overview
This project was completed for partial requirement of the ScM in Data Science at Brown University through the capstone course (DATA 2050). This project included both a regression and classification problem. Information about the regression problem can be found in the `DATA 2050 Poster.pdf` file. This poster shows the work done for the project as of May 1, 2025. The classification problem was the same as the regression, except that the birth weight percentiles used as the target variable were converted into one of three categories (SGA, AGA, LGA). 

Exploratory data analysis was performed in the `data2050_eda.ipynb` file. Data was preprocessed in the `data2050_preprocessing.ipynb` file. Multiple ML regression models were run on the data in the `data2050_model.ipynb` file, with an additional linear regression run in R in the `data2050linreg.R` file to take advantage of statistical tools that are more accessible in R. An analysis of variance was also run on the data for classification, found in the `AnoVa.R` file. The results of this ANOVA are in `anova_results.txt`.

## Data
Data was collected from a pediatric practice in Providence, RI. IRB oversight was given through Brown University. Data is not publically available, due to privacy limits including HIPAA. Hence, there are filepaths in the code to directories outside of the repository. Note that the `data2050_preprocessing.ipynb` notebook preprocesses the raw data in multiple ways for different purposes or models. For example, this notebook can create a dataset where all features are normalized and/or where missing data is iteratively imputed. 

## Acknolwedgements
Special thanks to Sunshine Pediatrics, the Data Science Institute at Brown University, and the Office of Information Technology at Brown University.
