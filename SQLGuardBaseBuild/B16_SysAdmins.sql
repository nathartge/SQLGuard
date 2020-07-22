/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2014 (12.0.5557)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2014
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/

--- Use the followign and adjust for any other infrastructure applications that may need acess to SQL, E.g. SCOM, SQLGuard, Backup service accounts and so on. 

USE [master]
GO

/****** Object:  Login [Domain\SQLGuardmonProxy]    Script Date: 27/03/2018 4:08:32 PM ******/
CREATE LOGIN [Domain\SQLGuardmonProxy] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [Domain\SQLGuardmonProxy]
GO





