/*
Alter SA name, display as text will show the print message
Chage the name to equal the new sa name

*/

--- Check old or current sa account name as it may have been renamed
SELECT name
FROM sys.sql_logins
WHERE sid = 0x01;

--- It may be best to rename this account or create a new account with the same permissions then disable

SET NOCOUNT ON

If EXISTS(SELECT name FROM sys.syslogins WHERE name = 'sa') 
	BEGIN
		ALTER LOGIN [sa] WITH name = [JediMaster] 
		ALTER LOGIN [JediMaster] ENABLE
		PRINT'sa has been modified to the new name'
	END
	ELSE
		SELECT name FROM sys.syslogins WHERE sysadmin = 1
		Print'sa should not exist in the above list'
GO