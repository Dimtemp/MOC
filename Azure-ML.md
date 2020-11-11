# Azure Machine Learning Designer Algorithms

This table describes the different algorithms that are availabe in the Azure Machine Learning Designer service.

## Types
- R = Regression
- K = Clustering
- C = Classification

Type|Title|Description
---|---|---
R|Boosted Decision Tree Regression|Create an ensemble of regression trees using boosting. Boosting means that each tree is dependent on prior trees. The algorithm learns by fitting the residual of the trees that preceded it. Thus, boosting in a decision tree ensemble tends to improve accuracy with some small risk of less coverage. This module is based LightGBM algorithm. This regression method is a supervised learning method, and therefore requires a labeled dataset. The label column must contain numerical values.
R|Decision Forest Regression|
R|Fast Forest Quantile Regression|
R|Linear Regression|
R|Neural Network Regression|
R|Poisson Regression|
K|K-Means Clustering|
C|Multiclass Boosted Decision Tree|
C|Multiclass Decision Forest|
C|Multiclass Logistic Regression|
C|Multiclass Neural Network|
C|One vs. All Multiclass|
C|One vs. One Multiclass|
C|Two-Class Averaged Perceptron|
C|Two-Class Boosted Decision Tree|
C|Two-Class Decision Forest|
C|Two-Class Logistic Regression|
C|Two-Class Neural Network|
C|Two Class Support Vector Machine|
