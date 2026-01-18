# ===============================================================
# Coffee Acidity Determinants
# Sensory Attributes, Altitude, and Processing Method
# ===============================================================

# Clean environment ------------------------------------------------
rm(list = ls())
Sys.setenv(LANG = "en")

# Packages ---------------------------------------------------------
library(tidyverse)
library(estimatr)
library(modelsummary)
library(car)

# Working directory ------------------------------------------------
# (Use relative paths for GitHub projects)
setwd("C:/Users/johnr/Desktop/coursera/Data analytics for economics and business/coffee")

# Import data ------------------------------------------------------
coffee <- read_csv("merged_data_cleaned.csv")
summary(coffee)

# Initial inspection ----------------------------------------------
glimpse(coffee)
summary(coffee)

# ===============================================================
# Variable Selection & Renaming
# ===============================================================

coffee <- coffee %>%
  select(
    Acidity,
    Flavor,
    Aftertaste,
    Body,
    Balance,
    Altitude,
    Processing.Method
  ) %>%
  rename(Processing = Processing.Method)

# ===============================================================
# Altitude Cleaning
# ===============================================================

# Convert altitude ranges (e.g. "1200-1400") to numeric midpoint
coffee <- coffee %>%
  mutate(
    altitude_num = sapply(Altitude, function(x) {
      vals <- as.numeric(str_extract_all(x, "\\d+\\.*\\d*")[[1]])
      if (length(vals) > 0) mean(vals) else NA_real_
    })
  )

# ===============================================================
# General Data Cleaning
# ===============================================================

coffee <- coffee %>%
  drop_na() %>%            # remove missing values
  distinct() %>%           # remove duplicates
  filter(
    Acidity >= 5, Acidity <= 10,
    altitude_num >= 500, altitude_num <= 2500
  )

# ===============================================================
# Variable Transformation
# ===============================================================

coffee <- coffee %>%
  mutate(
    Processing = as.factor(Processing),
    Processing = relevel(Processing, ref = "Washed / Wet"),
    l_altitude = log(altitude_num)
  )

# ===============================================================
# Exploratory Data Analysis (EDA)
# ===============================================================

# Distribution of Acidity
ggplot(coffee, aes(Acidity)) +
  geom_histogram(bins = 20, fill = "lightblue", color = "black") +
  labs(title = "Distribution of Acidity")

# Acidity vs Altitude
ggplot(coffee, aes(altitude_num, Acidity)) +
  geom_point(alpha = 0.6) +
  labs(title = "Acidity vs Altitude")

# Acidity vs Log Altitude
ggplot(coffee, aes(l_altitude, Acidity)) +
  geom_point(alpha = 0.6) +
  labs(title = "Acidity vs Log Altitude")

# Sensory attributes (long format)
sensory_long <- coffee %>%
  pivot_longer(
    cols = c(Flavor, Aftertaste, Body, Balance),
    names_to = "Sensory",
    values_to = "Score"
  )

ggplot(sensory_long, aes(Score, Acidity)) +
  geom_point(alpha = 0.5) +
  facet_wrap(~ Sensory, scales = "free_x") +
  theme_minimal() +
  labs(title = "Acidity vs Sensory Attributes")

# Processing method comparison
ggplot(coffee, aes(Processing, Acidity)) +
  geom_violin(fill = "lightblue", alpha = 0.5) +
  geom_jitter(width = 0.15, alpha = 0.4) +
  coord_flip() +
  labs(title = "Acidity by Processing Method")

# ===============================================================
# Descriptive Statistics
# ===============================================================

datasummary(
  Acidity * Factor(Processing) ~ Mean + Median + SD + N,
  data = coffee
)

# ===============================================================
# Regression Models
# ===============================================================

# Model 1: Simple
reg_simple <- lm_robust(
  Acidity ~ Flavor,
  data = coffee,
  se_type = "HC1"
)

# Model 2: Sensory attributes
reg_sensory <- lm_robust(
  Acidity ~ Flavor + Aftertaste + Body + Balance,
  data = coffee,
  se_type = "HC1"
)

# Model 3: Sensory + Altitude
reg_altitude <- lm_robust(
  Acidity ~ Flavor + Aftertaste + Body + Balance + l_altitude,
  data = coffee,
  se_type = "HC1"
)

# Model 4: Full model
reg_full <- lm_robust(
  Acidity ~ Flavor + Aftertaste + Body + Balance + l_altitude + Processing,
  data = coffee,
  se_type = "HC1"
)

# Model comparison table
modelsummary(
  list(
    "Simple" = reg_simple,
    "Sensory" = reg_sensory,
    "Sensory + Altitude" = reg_altitude,
    "Full Model" = reg_full
  ),
  statistic = "p.value",
  stars = TRUE,
  gof_omit = "IC|Log|F"
)

# ===============================================================
# Diagnostics
# ===============================================================

coffee <- coffee %>%
  mutate(
    fitted = predict(reg_full, newdata = coffee),
    residual = Acidity - fitted
  )

# Actual vs Predicted
ggplot(coffee, aes(fitted, Acidity)) +
  geom_point(alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  labs(title = "Actual vs Predicted Acidity")

# Residuals vs Fitted
plot(
  coffee$fitted,
  coffee$residual,
  pch = 19,
  col = "steelblue",
  xlab = "Fitted Values",
  ylab = "Residuals",
  main = "Residuals vs Fitted"
)
abline(h = 0, col = "red", lty = 2)

# Residual distribution
ggplot(coffee, aes(residual)) +
  geom_histogram(bins = 20, fill = "lightblue", color = "black") +
  labs(title = "Residual Distribution")

# ===============================================================
# Multidisciplinary Check
# ===============================================================

vif(
  lm(
    Acidity ~ Flavor + Aftertaste + Body + Balance + l_altitude + Processing,
    data = coffee
  )
)
