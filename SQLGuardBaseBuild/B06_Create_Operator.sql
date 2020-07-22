/*
Update the opperator email address to suite your site

*/

SET NOCOUNT ON

USE [msdb]
GO


IF NOT EXISTS (SELECT name FROM dbo.sysoperators WHERE name = 'SQLGuardDBAOperator' AND email_address = 'SQLGuardDBA@domain.local')
	BEGIN
	/****** Object:  Operator [DatacomDBA TEAM]    Script Date: 20/07/2015 3:20:31 PM ******/
	EXEC msdb.dbo.sp_add_operator @name=N'SQLGuardDBAOperator', 
			@enabled=1, 
			@weekday_pager_start_time=90000, 
			@weekday_pager_end_time=180000, 
			@saturday_pager_start_time=90000, 
			@saturday_pager_end_time=180000, 
			@sunday_pager_start_time=90000, 
			@sunday_pager_end_time=180000, 
			@pager_days=0, 
			@email_address=N'mail_SQLGuardDBA@domain.local', 
			@category_name=N'[Uncategorized]'
	END
ELSE 
 Print 'The SQLGuardDBA Operator exists and has the correct email address'