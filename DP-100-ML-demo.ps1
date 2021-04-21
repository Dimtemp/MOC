# Melbourne housing source: https://www.kaggle.com/anthonypino/melbourne-housing-market

# init
$uri = 'https://github.com/csymarcia/Melbourne_housing_FULL/raw/master/Melbourne_housing_FULL.csv'
$pythonFilename = 'Melbourne_housing.py'

# enable Tls12, required for Chocolatey and CSV download
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# download csv file
$OutFile = "$HOME\Downloads\$(Split-Path $uri -Leaf)"
Invoke-WebRequest -Uri $uri -OutFile $OutFile

# Chocolatey  install
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install anaconda3
choco install miniconda3

# train model in Python
$pythonscript = @'
# import libraries
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn import ensemble
from sklearn.metrics import mean_absolute_error

df = pd.read_csv('~/Downloads/Melbourne_housing_FULL.csv')

del df['Address']
del df['Method']
del df['SellerG']
del df['Date']
del df['Postcode']
del df['Lattitude']
del df['Lontitude']
del df['Regionname']
del df['Propertycount']

df.dropna(axis = 0, how = 'any', thresh = None, subset = None, inplace = True)

df = dp.get_dummies(df, columns = ['Suburb', 'CouncilArea', 'Type')

X = df.drop('Price', axis=1)
y = df['Price']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, shuffle = True)

model = ensemble.GradientBoostingRegressor(
    n_estimators = 150,
    learning_rate = 0.1,
    max_depth = 30,
    min_samples_split = 4,
    min_samples_leaf = 6,
    max_features = 0.6,
    loss = 'huber'
)

model.fit(X_train, y_train)

mae_train = mean_absolute_error(y_train, model.predict(X_train))
print("Training Set Mean Absolute Error: %.2f" % mae_train)

mae_test = mean_absolute_error(y_test, model.predict(X_test))
print("Test Set Mean Absolute Error: %.2f" % mae_test)

'@

$pythonscript | Out-File "$HOME\Documents\$pythonFilename"

