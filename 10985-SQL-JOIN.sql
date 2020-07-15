CREATE DATABASE HR
GO

USE HR
GO

CREATE TABLE Person(
    ID varchar(10),
    FirstName varchar(10),
    HomeAddress varchar(10)
)
GO

INSERT INTO Person
--    (ID, FirstName, HomeAddress)
VALUES
    (1, 'Henk', 'Utrecht'),
    (2, 'Piet', 'Amsterdam'),
    (3, 'Klaas', 'Rotterdam');
GO

CREATE TABLE Car(
    Licenseplate varchar(10),
    Manufacturer varchar(10),
    Model varchar(10),
    DriverID varchar(10)
)
GO

INSERT INTO Car
--    (LicensePlate, Manufacturer, Model, DriverID)
VALUES
    ('ax-87-ds', 'BMW','3', '1'),
    ('df-34-hj', 'Mercedes','SLK', '2'),
    ('kl-43-as', 'Audi','A8', '2'),
    ('mn-12-pq', 'VW','Up', '');

SELECT * FROM Person

SELECT * FROM Car

SELECT p.FirstName, p.HomeAddress, c.Manufacturer, c.Model
FROM Person as p JOIN Car as c
ON p.ID=c.DriverID
-- LEFT (OUTER) JOIN
-- RIGHT (OUTER) JOIN
-- FULL JOIN
-- WHERE Manufacturer = 'BMW'
-- ORDER BY Manufacturer


-- CONSTRAINT
-- Person.ID needs to be key up front!
ALTER TABLE Car
ADD CONSTRAINT FK1 FOREIGN KEY (DriverID)
REFERENCES Person (ID)
