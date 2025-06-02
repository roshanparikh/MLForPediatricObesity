setwd("/Users/roshanparikh/Documents/DATA 2050/dsicapstone")

# Loading data 
data_imp = read.csv("df_regression_imp.csv")

# Creating model
model_imp = lm(target ~., data=data_imp)
summary(model_imp)

# For Ridge regression (L2 regularization)
library(glmnet)
model_ridge = cv.glmnet(as.matrix(data_imp[, -which(names(data_imp) == "target")]), data_imp$target, alpha=0)

# For Lasso regression (L1 regularization)
model_lasso = cv.glmnet(as.matrix(data_imp[, -which(names(data_imp) == "target")]), data_imp$target, alpha=1)

# Cook's D: Threshold=4/42=0.095
threshold = 4/41
cooksD = cooks.distance(model_imp)

# Same thing but not imputed--basically useless
# data_not_imp=read.csv("df_regression_not_imp.csv")
# model_not_imp= lm(target ~., data=data_not_imp)
# summary(model_not_imp)

# Plotting
library(broom)  # for tidy()
library(dplyr)

coef_df <- broom::tidy(model_imp)
coef_sig <- coef_df %>% 
  filter(p.value < 0.05, term != "(Intercept)")

library(ggplot2)

ggplot(coef_sig, aes(x = reorder(term, -abs(estimate)), y = estimate)) +
  geom_point(color='steelblue') +
  geom_errorbar(aes(ymin = estimate - std.error, ymax = estimate + std.error), 
                width = 0.2,
                linewidth=0.8,
                color="steelblue") +
  geom_hline(yintercept = 0, linetype = "solid", color = "gray", linewidth = 0.7) +
  labs(title = "Significant Covariates (p-value < 0.5) from Linear Regression",
       x = "Feature",
       y = "Coefficient Estimate") +
  scale_x_discrete(labels = c(
    "std__birth.1yr_wt_diff" = "Weight difference \n(birth-1 year)", 
    "std__3yr_wt_pct" = "Weight percentile \n(3 years)", 
    "std__1yr.3yr_wt_diff" = "Weight difference \n(1 year-3 years)",
    "ohot__6mo_feeding_type_Both.Breast.and.Formula" = "Combination feeding \nat 6 months**"
  )) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0,hjust = 0.5, vjust=0.7))



# Create a data frame for plotting
cooks_df <- data.frame(
  Index = seq_along(cooksD),
  CooksD = cooksD
)

# Plot Cook's Distance using ggplot2
library(ggplot2)

cooks_df$color <- ifelse(cooks_df$CooksD > threshold, "red", "skyblue")
cooks_df$CooksD[is.na(cooks_df$CooksD)] <- 0

ggplot(cooks_df, aes(x = Index, y = CooksD, fill = color)) +
  geom_col(color = "black") +  # Color bars based on the 'color' column
  geom_hline(yintercept = threshold, linetype = "dashed", color = "black") +  # Threshold line
  labs(title = "Cook's Distance Plot",
       x = "Observation Index",
       y = "Cook's Distance") +
  scale_fill_identity() +  # Use the exact colors specified in 'color' column
  annotate("text", x = 25, y = threshold+0.003, 
           label = paste0("Threshold = ", round(threshold, 3)),
           vjust = -1, hjust = 1, color = "black", size = 3)+
  theme_minimal()

# Removing outliers and trying again
threshold <- 4 / 41
cooksD <- cooks.distance(model_imp)
influential_points <- which(cooksD > threshold)
df_clean <- data_imp[-influential_points, ]
model_clean = lm(target~., data=df_clean)

# Plotting
library(broom)  # for tidy()
library(dplyr)

coef_df <- broom::tidy(model_clean)
coef_sig <- coef_df %>% 
  filter(p.value < 0.05, term != "(Intercept)")

library(ggplot2)

ggplot(coef_sig, aes(x = reorder(term, -abs(estimate)), y = estimate)) +
  geom_point(color='steelblue') +
  geom_errorbar(aes(ymin = estimate - std.error, ymax = estimate + std.error), 
                width = 0.2,
                linewidth=0.8,
                color="steelblue") +
  geom_hline(yintercept = 0, linetype = "solid", color = "gray", linewidth = 0.7) +
  labs(title = "Significant Covariates (p-value < 0.5) from Linear Regression",
       x = "Feature",
       y = "Coefficient Estimate") +
  scale_x_discrete(labels = c(
    "std__birth.1yr_wt_diff" = "Weight difference \n(birth-1 year)", 
    "std__3yr_wt_pct" = "Weight percentile \n(3 years)", 
    "std__1yr.3yr_wt_diff" = "Weight difference \n(1 year-3 years)",
    "std__1yr_wt_pct" = "Weight percentile \n(1 year)",
    "std__birth.1yr_wt_diff" = "Weight difference \n(birth-1 year)",
    "ohot__race_Other" = "Race: Other",
    "ohot__4mo_feeding_type_Breast.Feeding" = "Breast feeding \nat 4 months",
    "ohot__6mo_feeding_type_Formula.Feeding" = "Formula feeding \nat 6 months"
  )) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45,hjust = 0.5, vjust=0.7))
