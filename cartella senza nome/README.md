# Car

## La Lista
- TUTTI i plot.
  - Price vs all (+ o -) (quelli che vedeva Elena stamattina (19/01/2023))
  - Prediction of price vs all (compare above)
  - Distribution of all the vars with histogrammins
  - Plots for models: residuals and whatnot
  - Correlation
- Price:
  - log transformation:
    - lm(log(price)~.)
    - glm(price ~ . , Gamma(log))
  - High res for low prices. How come?
- Kilometers: no transformation, but in 1000 km (interpretability)
- Make:
  - Fit with make
  - Fit without make
  -> Compare => we choose to keep whichever for whatever reason
  - Lasso (?)
- Residuals vs covariates: patterns?
- Correlated variables: try models with less variables => better? worse?
  - Correlation with log?
