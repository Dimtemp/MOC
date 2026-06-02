# Create an Azure Cosmos DB in MongoDB mode

# optionally install the mongo db package in python:
# python -m pip install pymongo

# start python and test the mongodb package:
import pymongo

# After CosmosDB creation: copy the Python connection script here and connect:
uri = "mongodb://mongo184:1n9DhEAesiDY54z7wR2nvj6oqGWi4ra9Qzdu3KUQS5DGOV0Fg7itubphYY8mEChm7226O6VR40RxHmC2cv6ZYA==@mongo184.mongo.cosmos.azure.com:10255/?ssl=true&retrywrites=false&replicaSet=globaldb&maxIdleTimeMS=120000&appName=@mongo184@"
myclient = pymongo.MongoClient(uri)

# create a database
mydb = myclient["mydatabase"]

# create a collection (table)
mycol = mydb["customers"]

# create a single record
mydict = { "name": "John", "address": "Highway 37" }
x = mycol.insert_one(mydict)

# view the record
print(x.inserted_id)

# create multiple records
mylist = [
  { "name": "Amy", "address": "Apple st 652"},
  { "name": "Hannah", "address": "Mountain 21"},
  { "name": "Michael", "address": "Valley 345"},
  { "name": "Sandy", "address": "Ocean blvd 2"},
  { "name": "Betty", "address": "Green Grass 1"},
  { "name": "Richard", "address": "Sky st 331"},
  { "name": "Susan", "address": "One way 98"},
  { "name": "Vicky", "address": "Yellow Garden 2"},
  { "name": "Ben", "address": "Park Lane 38"},
  { "name": "William", "address": "Central st 954"},
  { "name": "Chuck", "address": "Main Road 989"},
  { "name": "Viola", "address": "Sideway 1633"}
]

x = mycol.insert_many(mylist)

# print list of the _id values of the inserted documents:
print(x.inserted_ids)

# Insert Multiple Documents, with Specified IDs

mylist = [
  { "_id": 1, "name": "John", "address": "Highway 37"},
  { "_id": 2, "name": "Peter", "address": "Lowstreet 27"},
  { "_id": 3, "name": "Amy", "address": "Apple st 652"},
  { "_id": 4, "name": "Hannah", "address": "Mountain 21"},
  { "_id": 5, "name": "Michael", "address": "Valley 345"},
  { "_id": 6, "name": "Sandy", "address": "Ocean blvd 2"},
  { "_id": 7, "name": "Betty", "address": "Green Grass 1"},
  { "_id": 8, "name": "Richard", "address": "Sky st 331"},
  { "_id": 9, "name": "Susan", "address": "One way 98"},
  { "_id": 10, "name": "Vicky", "address": "Yellow Garden 2"},
  { "_id": 11, "name": "Ben", "address": "Park Lane 38"},
  { "_id": 12, "name": "William", "address": "Central st 954"},
  { "_id": 13, "name": "Chuck", "address": "Main Road 989"},
  { "_id": 14, "name": "Viola", "address": "Sideway 1633"}
]

x = mycol.insert_many(mylist)

# print list of the _id values of the inserted documents:
print(x.inserted_ids)

# find a document
x = mycol.find_one()
print(x)

# Return all documents in the "customers" collection, and print each document
for x in mycol.find():
    print(x)

# Return only the names and addresses, not the _ids:
for x in mycol.find({},{ "_id": 0, "name": 1, "address": 1 }):
    print(x)

