// Databricks notebook source
//Cmd 1
// Optionally get or verify details with Get-DP200Module3Details function from https://github.com/Dimtemp/MOC/blob/master/dp-200/DP200Functions.ps1
val storageAccountName = "storageAccountName"
val appID = "GUID"
val key = "key"
val tenantID = "GUID"
val fileSystemName = "logs"

// COMMAND ----------

//Cmd 2
//Connect to Azure Data Lake Storage Gen2 account

spark.conf.set("fs.azure.account.auth.type", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id." + storageAccountName + ".dfs.core.windows.net", appID)
spark.conf.set("fs.azure.account.oauth2.client.secret." + storageAccountName + ".dfs.core.windows.net", key)
spark.conf.set("fs.azure.account.oauth2.client.endpoint." + storageAccountName + ".dfs.core.windows.net", "https://login.microsoftonline.com/" + tenantID + "/oauth2/token")

// COMMAND ----------

//Cmd 3
//Read JSON data in Azure Data Lake Storage Gen2 file system
val df = spark.read.json("abfss://" + fileSystemName + "@" + storageAccountName + ".dfs.core.windows.net/preferences.json")
//val df = spark.read.json("abfss://logs@dp200x984.dfs.core.windows.net/preferences.json")


// COMMAND ----------

//Cmd 4
//Show result of reading the JSON file

df.show()

// COMMAND ----------

//Cmd 5
//Retrieve specific columns from a JSON dataset in Azure Data Lake Storage Gen2 file system

val specificColumnsDf = df.select("firstname", "lastname", "gender", "location", "page")
specificColumnsDf.show()

// COMMAND ----------

//Cmd 6
//Rename the page column to bike_preference

val renamedColumnsDF = specificColumnsDf.withColumnRenamed("page", "bike_preference")
renamedColumnsDF.show()

// COMMAND ----------

//Transformations if time permits

//Basic
//https://github.com/MicrosoftDocs/mslearn-perform-basic-data-transformation-in-azure-databricks/blob/master/DBC/05.1-Basic-ETL.dbc?raw=true

//Advanced
//https://github.com/MicrosoftDocs/mslearn-perform-advanced-data-transformation-in-azure-databricks/blob/master/DBC/05.2-Advanced-ETL.dbc?raw=true

// COMMAND ----------


