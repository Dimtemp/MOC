-- more info: https://docs.microsoft.com/en-us/sql/relational-databases/triggers/logon-triggers

USE master;
GO

CREATE LOGIN User1 WITH PASSWORD = '3KHJ6dhx(0xVYsdf' MUST_CHANGE,
    CHECK_EXPIRATION = ON;
GO  

GRANT VIEW SERVER STATE TO User1;
GO

CREATE TRIGGER connection_limit_trigger
ON ALL SERVER WITH EXECUTE AS 'User1'
FOR LOGON
AS
BEGIN
IF ORIGINAL_LOGIN()= 'User1' AND
    (SELECT COUNT(*) FROM sys.dm_exec_sessions
            WHERE is_user_process = 1 AND
                original_login_name = 'User1') > 3
    ROLLBACK;
END;
