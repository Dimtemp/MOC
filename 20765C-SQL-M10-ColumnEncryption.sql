--If there is no master key, create one now.   
IF NOT EXISTS   
    (SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101)  
    CREATE MASTER KEY ENCRYPTION BY   
    PASSWORD = '23987hxJKL93QYV43j9#ghf0%lekjg5k3fd117r$$#1946kcj$n44ncjidld'  
GO  

CREATE CERTIFICATE CreditCard  
   WITH SUBJECT = 'Credit Card Numbers';  
GO  

CREATE SYMMETRIC KEY CreditCards_Key1  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE CreditCard;  
GO  

-- Create a column in which to store the encrypted data.  
ALTER TABLE SalesLT.Customer   
    ADD CardNumber_Encrypted varbinary(128);   
GO  

-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY CreditCards_Key1  
   DECRYPTION BY CERTIFICATE CreditCard;  

-- Encrypt the value in column CardNumber using the symmetric key CreditCards_Key1.  
UPDATE SalesLT.Customer  
SET CardNumber_Encrypted = EncryptByKey(Key_GUID('CreditCards_Key1'), CardNumber_Encrypted );  
GO  

-- Save the result in column CardNumber_Encrypted.    
UPDATE SalesLT.Customer 
SET CardNumber_Encrypted = 12345678
WHERE CustomerID = 1

-- Verify
SELECT * FROM SalesLT.Customer
