setwd("/Users/roshanparikh/Documents/DATA 2050/MLForPediatricObesity")

# Loading data 
df_missing = read.csv("../Preprocessed Data/df_class_not_imp.csv") # with missing values
df_imputed = read.csv("../Preprocessed Data/df_class_imp.csv") # without missing values

# WITH MISSING VALUES
# One-way anova: LGA vs. AGA
df_pair_lga = subset(df_missing, target %in% c("AGA", "LGA"))
outcome_vars = setdiff(names(df_pair_lga), "target")

aov_results_miss_lga = lapply(outcome_vars, function(var) {
  formula = as.formula(paste(var, "~ target"))
  fit = aov(formula, data = df_pair_lga)
  summary(fit)
})
names(aov_results_miss_lga) = outcome_vars

# One-way anova: SGA vs. AGA
df_pair_sga = subset(df_missing, target %in% c("AGA", "SGA"))
outcome_vars = setdiff(names(df_pair_sga), "target")

aov_results_miss_sga = lapply(outcome_vars, function(var) {
  formula = as.formula(paste(var, "~ target"))
  fit = aov(formula, data = df_pair_sga)
  summary(fit)
})
names(aov_results_miss_sga) = outcome_vars

# WITHOUT MISSING VALUES
# One-way anova: LGA vs. AGA
df_pair_lga = subset(df_imputed, target %in% c("AGA", "LGA"))
outcome_vars = setdiff(names(df_pair_lga), "target")

aov_results_imp_lga = lapply(outcome_vars, function(var) {
  formula = as.formula(paste(var, "~ target"))
  fit = aov(formula, data = df_pair_lga)
  summary(fit)
})
names(aov_results_imp_lga) = outcome_vars

# One-way anova: SGA vs. AGA
df_pair_sga = subset(df_imputed, target %in% c("AGA", "SGA"))
outcome_vars = setdiff(names(df_pair_sga), "target")

aov_results_imp_sga = lapply(outcome_vars, function(var) {
  formula = as.formula(paste(var, "~ target"))
  fit = aov(formula, data = df_pair_sga)
  summary(fit)
})
names(aov_results_imp_sga) = outcome_vars

# One-way anova: SGA vs. LGA vs. AGA
outcome_vars = setdiff(names(df_imputed), "target")

aov_results_imp_allclasses = lapply(outcome_vars, function(var) {
  formula <- as.formula(paste(var, "~ target"))
  fit = aov(formula, data = df_imputed)
  summary(fit)
})
names(aov_results_imp_allclasses) = outcome_vars


# RESULTS (for ease)
aov_results_miss_sga
aov_results_miss_lga
aov_results_imp_sga
aov_results_imp_lga
aov_results_imp_allclasses
