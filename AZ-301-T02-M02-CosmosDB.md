New Item
{
    "firstName": "Suzanne",
    "lastName": "Oneal",
    "company": "Microsoft"
}
New item (2 more, with unique fieldnames, see lab)

SELECT * FROM c

SELECT c.id, c.firstName, c.lastName, c.isVested, c.company
FROM c WHERE IS_DEFINED(c.isVested)

SELECT c.id, c.firstName, c.lastName, c.age
FROM c WHERE c.age > 20

SELECT VALUE c.id
FROM c

SELECT VALUE {
    "badgeNumber": SUBSTRING(c.id, 0, 8),
    "company": c.company,
    "fullName": CONCAT(c.firstName, " ", c.lastName)
}
FROM c
