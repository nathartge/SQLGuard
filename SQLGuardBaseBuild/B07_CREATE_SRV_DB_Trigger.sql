/*
Update lines 36 to 38 as needed. 

This is a server level trigger. Use with caution and do not use if SMTP is not configured as it will cause DB create and drop to fail
Tested on SQL 2012 and 2014, this can be handy in some environments where players play. 

*/

SET NOCOUNT ON

USE [master]
GO

/****** Object:  DdlTrigger [DDL_Database_Modified]    Script Date: 20/07/2015 3:25:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TRIGGER [DDL_Database_Modified]
ON ALL SERVER 
FOR CREATE_DATABASE, DROP_DATABASE
AS
	DECLARE @Results varchar(max)
	DECLARE @SubjectText varchar(max)
	DECLARE @DatabaseName varchar(255)

	SET @SubjectText = 'Database Modified on ' + @@SERVERNAME + ' by ' + SUSER_NAME()
	SET @Results = 
		(SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)'))
	SET @DatabaseName = 
		(SELECT EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(255)'))

---Comment out the text below if you do not wish to be alerted via email

IF @DatabaseName NOT LIKE '%Snapshot%'
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'SQLGuardDBA',
                   @from_address = 'mail_SQLGuardDBA@domain.local',
	@Recipients = 'mail_SQLGuardDBA@domain.local',
	--@Copy_Recipients = 'email address needed',
	@Subject = @SubjectText,
	@Body = @Results,
	@Exclude_query_output = 1 --- Suppress ' Mail Queued Message'


GO

ENABLE TRIGGER [DDL_Database_Modified] ON ALL SERVER
GO


