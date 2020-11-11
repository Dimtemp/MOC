# Azure Machine Learning Designer Algorithms

This table describes the different algorithms that are availabe in the Azure Machine Learning Designer service.

## Types
- R = Regression
- K = Clustering
- C = Classification

Type|Title|Description
---|---|---
R|Boosted Decision Tree Regression|Create an ensemble of regression trees using boosting. Boosting means that each tree is dependent on prior trees. The algorithm learns by fitting the residual of the trees that preceded it. Thus, boosting in a decision tree ensemble tends to improve accuracy with some small risk of less coverage. This module is based LightGBM algorithm. This regression method is a supervised learning method, and therefore requires a labeled dataset. The label column must contain numerical values.
R|Decision Forest Regression|Create a regression model based on an ensemble of decision trees. After you have configured the model, you must train the model using a labeled dataset.
R|Fast Forest Quantile Regression|To understand more about the distribution of the predicted value, rather than get a single mean prediction value. Examples: Predicting prices, estimating student performance or applying growth charts to assess child development, discovering predictive relationships in cases where there is only a weak relationship between variables. This regression algorithm is a supervised learning method, which means it requires a tagged dataset that includes a label column. Because it is a regression algorithm, the label column must contain only numerical values.
R|Linear Regression|To establish a linear relationship between one or more independent variables and a numeric outcome, or dependent variable. You use this module to define a linear regression method, and then train a model using a labeled dataset.
R|Neural Network Regression|Although neural networks are widely known for use in deep learning and modeling complex problems such as image recognition, they are easily adapted to regression problems. Any class of statistical models can be termed a neural network if they use adaptive weights and can approximate non-linear functions of their inputs. Thus neural network regression is suited to problems where a more traditional regression model cannot fit a solution. Neural network regression is a supervised learning method, and therefore requires a tagged dataset, which includes a label column. Because a regression model predicts a numerical value, the label column must be a numerical data type.
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


## More info
- https://docs.microsoft.com/en-us/azure/machine-learning/algorithm-module-reference/module-reference
- https://docs.microsoft.com/en-us/azure/machine-learning/how-to-select-algorithms
- https://machinelearningmastery.com/a-tour-of-machine-learning-algorithms/
- https://cheatography.com/lulu-0012/cheat-sheets/test-ml/
