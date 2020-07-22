/*

Enable Database Features and set prameters where required.

*/
SET NOCOUNT ON

EXEC sys.sp_configure N'show advanced options', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

EXEC sp_configure 'optimize for ad hoc workloads',1 ;
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'
GO
RECONFIGURE WITH OVERRIDE
GO


USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', REG_DWORD, 30
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @jobhistory_max_rows=10000, 
		@jobhistory_max_rows_per_job=300
GO

USE master
GO

-- Enable SMTP

SET NOCOUNT ON;

EXEC sp_configure 'show advanced options', 1;
		
RECONFIGURE;
			
EXEC sp_configure 'Database Mail XPs', 1;
		
RECONFIGURE;
GO
PRINT 'SMTP has been enabled'
PRINT 'Ensure that the IP address has been added to the Allowed to Send SMTP through exchange internalaly.'


-- ENABLE DAC
Use master
GO
/* 0 = Allow Local Connection, 1 = Allow Remote Connections*/ 
sp_configure 'remote admin connections', 1 
GO
RECONFIGURE
GO
PRINT 'The SQL Server DAC has been enabled.'
GO

-- Enable Contained Databases at the Instance level, use with causion as this can cause security issues

--EXEC sys.sp_configure N'contained database authentication', N'1'
--GO
--RECONFIGURE WITH OVERRIDE
--GO

/*
-- Moddify Instance Log rotation

The default is 6 which can be an issue if you have many restarts in a short window.
*/

USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', REG_DWORD, 20
GO

/*

-- Enable Backup compression at the instance level

*/

USE master
GO

EXEC sys.sp_configure N'backup compression default', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO