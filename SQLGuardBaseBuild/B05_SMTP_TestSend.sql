/*
-- SMTP Test message
Ensure that the host is aloud to send SMTP through the messaging server

Update to suite your environment
*/

SET NOCOUNT ON

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SQLGuardDBA',
@recipients = 'mail_SQLGuardDBA@domain.local',
@subject = 'Test message send',
@body = 'This is an automated message only: This is a build test message, the SMTP configuration works';
GO