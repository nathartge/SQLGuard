/*
This Alert also includes automation to correct a TLog full event. This is set to all and you may like to custom this for individual databases

*/

SET NOCOUNT ON

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Transaction Log Full >85%', 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=0, 
		@performance_condition=N'SQLServer:Databases|Log File(s) Used Size (KB)|_Total|>|85' 
		--,@job_id=N'1a2d79ed-a794-4408-95b5-56f2ba22b1b3'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Transaction Log Full >85%', @operator_name=N'SQLGuardDBAOperator', @notification_method = 1
GO

