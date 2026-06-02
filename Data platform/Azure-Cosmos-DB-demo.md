Create a Cosmos DB first.
API: Core (SQL)

<Cosmos DB>
Create Items container
Open Data Explorer

New Item
{ "firstName": "Suzanne", "lastName": "Oneal", "company": "Microsoft" }

New Item
{ "firstName": "Patrick", "lastName": "Johanssen", "company": "Microsoft", "salary": 5000 }

New Item
{ "firstName": "James", "lastName": "Mcdonald", "company": "ABC", "salary": 9000 }

New SQL Query
SELECT * FROM c
SELECT VALUE c.id FROM c
SELECT c.id, c.firstName, c.lastName, c.salary, c.company FROM c WHERE c.salary > 6000
SELECT c.id, c.firstName, c.lastName, c.salary, c.company FROM c WHERE IS_DEFINED(c.salary)
SELECT VALUE { "badgeNumber": SUBSTRING(c.id, 0, 8),
"company": c.company,
"fullName": CONCAT(c.firstName, " ", c.lastName) }
FROM c


<Cosmos DB>
Add Container
Database id: Products
Throughput: 400
Container id: Clothing
Partition key: /productId


Navigate to Products, Clothing, Items

New Item
{
   "id": "1",
   "productId": "33218896",
   "category": "Women's Clothing",
   "manufacturer": "Contoso Sport",
   "description": "Quick dry crew neck t-shirt",
   "price": "14.99",
   "shipping": {
       "weight": 1,
       "dimensions": {
       "width": 6,
       "height": 8,
       "depth": 1
      }
   }
}



New Item
{
    "id": "2",
    "productId": "33218897",
    "category": "Women's Outerwear",
    "manufacturer": "Contoso",
    "description": "Black wool pea-coat",
    "price": "49.99",
    "shipping": {
        "weight": 2,
        "dimensions": {
        "width": 8,
        "height": 11,
        "depth": 3
        }
    }
}








New Item
{
    "id": "3",
    "productId": "74264420",
    "category": "Vehicles",
    "manufacturer": "Contoso",
    "description": "Jetski",
    "price": "5000",
    "shipping": {
        "weight": 1800,
        "dimensions": {
        "width": 70,
        "height": 21,
        "depth": 22
        }
    }
}





New SQL Query
SELECT * FROM c



New SQL Query
SELECT * FROM Products p



New SQL Query
SELECT *
FROM Products p
WHERE p.id ="1"



New SQL Query
SELECT
    p.id,
    p.manufacturer,
    p.description
FROM Products p
WHERE p.id ="1"



New SQL Query
SELECT p.price, p.description, p.productId
FROM Products p
ORDER BY p.price ASC
-- or DESC


New Stored Procedure
function createMyDocument() {
    var context = getContext();
    var collection = context.getCollection();

    var doc = {
        "id": "3",
        "productId": "33218898",
        "description": "Contoso microfleece zip-up jacket",
        "price": "44.99"
    };

    var accepted = collection.createDocument(collection.getSelfLink(),
        doc,
        function (err, documentCreated) {
            if (err) throw new Error('Error' + err.message);
            context.getResponse().setBody(documentCreated)
        });
    if (!accepted) return;
}



Execute
Input Parameters: type: string
value: 33218898



New UDF
function producttax(price) {
    if (price == undefined) 
        throw 'no input';

    var amount = parseFloat(price);

    if (amount < 1000) 
        return amount * 0.1;
    else if (amount < 10000) 
        return amount * 0.2;
    else
        return amount * 0.4;
}



New SQL Query
SELECT c.id, c.productId, c.price, udf.producttax(c.price) AS producttax FROM c

