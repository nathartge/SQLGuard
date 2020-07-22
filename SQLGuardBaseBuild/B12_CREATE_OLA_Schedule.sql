/*

--This scrip sets the schedule for the Ola jobs

You may like to schedule different @active_start_time values. 

*/

USE msdb
GO

SET NOCOUNT ON
GO

-- DatabaseBackup - SYSTEM_DATABASES - FULL (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'SysDB Full')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'SysDB Full')
				

If @Count = 1 GOTO End_SysDB_Full_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'SysDB Full');
			PRINT 'All SysDB Full schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'SysDB Full'
		BREAK
		
		
	END
		EXEC dbo.sp_add_schedule @schedule_name=N'SysDB Full', 
				@enabled=1, 
				@freq_type=4, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=0,  
				@active_start_time=33000 

		EXEC sp_attach_schedule
				@job_name = N'DatabaseBackup - SYSTEM_DATABASES - FULL',
				@schedule_name = N'SysDB Full';
	
	
		SELECT 'SysDB Full Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'SysDB Full has been Recreated'
		GOTO End_SysDB_Full_2


End_SysDB_Full_1:
SELECT 'SysDB Full Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
PRINT'A new SysDB Full schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_SysDB_Full_2:


GO
-- Output File Cleanup (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'OutputClean')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'OutputClean')
				

If @Count = 1 GOTO End_OutputClean_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'OutputClean');
			PRINT 'All OutputClean schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'OutputClean'
		BREAK

	END
		EXEC dbo.sp_add_schedule @schedule_name=N'OutputClean', 
				@enabled=1, 
				@freq_type=16, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=1, 
				@active_start_time=60000 
				
		EXEC sp_attach_schedule
				@job_name = N'Output File Cleanup',
				@schedule_name = N'OutputClean';

		SELECT 'OutputClean Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'OutputClean has been Recreated'
		GOTO End_OutputClean_2


End_OutputClean_1:
	SELECT 'OutputClean Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new OutputClean schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_OutputClean_2:

GO


-- sp_purge_jobhistory (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'purgehistory')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'purgehistory')
				

If @Count = 1 GOTO End_purgehistory_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'purgehistory');
			PRINT 'All purgehistory schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'purgehistory'
		BREAK
	END
		EXEC dbo.sp_add_schedule @schedule_name=N'purgehistory', 
				@enabled=1, 
				@freq_type=8, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=1,  
				@active_start_time=0 
				
		EXEC sp_attach_schedule
				@job_name = N'sp_purge_jobhistory',
				@schedule_name = N'purgehistory';

		SELECT 'purgehistory Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'purgehistory has been Recreated'
		GOTO End_purgehistory_2


End_purgehistory_1:
	SELECT 'purgehistory Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new purgehistory schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_purgehistory_2:

GO

-- DatabaseBackup - CommandLog Cleanup (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'CommandLogClean')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'CommandLogClean')
				

If @Count = 1 GOTO End_CommandLogClean_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'CommandLogClean');
			PRINT 'All CommandLogClean schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'CommandLogClean'
		BREAK

	END
		EXEC dbo.sp_add_schedule @schedule_name=N'CommandLogClean', 
				@enabled=1, 
				@freq_type=16, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=1,  
				@active_start_time=60000 
				
		EXEC sp_attach_schedule
				@job_name = N'CommandLog Cleanup',
				@schedule_name = N'CommandLogClean';

		SELECT 'CommandLogClean Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'CommandLogClean has been Recreated'
		GOTO End_CommandLogClean_2


End_CommandLogClean_1:
	SELECT 'CommandLogClean Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new CommandLogClean schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_CommandLogClean_2:

GO

-- DatabaseIntegrityCheck - SYSTEM_DATABASES (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'DBCCSysDB')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'DBCCSysDB')
				

If @Count = 1 GOTO End_DBCCSysDB_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'DBCCSysDB');
			PRINT 'All DBCCSysDB schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'DBCCSysDB'
		BREAK
	END
		EXEC dbo.sp_add_schedule @schedule_name=N'DBCCSysDB', 
				@enabled=1, 
				@freq_type=8, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=1,   
				@active_start_time=100000 

		EXEC sp_attach_schedule
				@job_name = N'DatabaseIntegrityCheck - SYSTEM_DATABASES',
				@schedule_name = N'DBCCSysDB';
		
		SELECT 'DBCCSysDB Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'DBCCSysDB has been Recreated'
		GOTO End_DBCCSysDB_2

End_DBCCSysDB_1:
	SELECT 'DBCCSysDB Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new DBCCSysDB schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_DBCCSysDB_2:

GO

-- DatabaseBackup - USER_DATABASES - DIFF (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'UserDiffBak')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'UserDiffBak')
				

If @Count = 1 GOTO End_UserDiffBak_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'UserDiffBak');
			PRINT 'All UserDiffBak schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'UserDiffBak'
		BREAK
	END

-- Disable Differential backup job
			EXEC dbo.sp_update_job @job_name=N'DatabaseBackup - USER_DATABASES - DIFF', 
			@enabled=0

			SELECT 'UserDiffBak Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
			PRINT'UserDiffBak has been Recreated'
			GOTO End_UserDiffBak_2

End_UserDiffBak_1:
	SELECT 'UserDiffBak Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new UserDiffBak schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_UserDiffBak_2:

GO

-- DatabaseBackup - USER_DATABASES - LOG (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'UserTLogBak')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'UserTLogBak')
				

If @Count = 1 GOTO End_UserTLogBak_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'UserTLogBak');
			PRINT 'All UserTLogBak schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'UserTLogBak'
		BREAK
	END

	EXEC dbo.sp_add_schedule @schedule_name=N'UserTLogBak', 
			@enabled=1, 
			@freq_type=4, 
			@freq_interval=1, 
			@freq_subday_type=4, 
			@freq_subday_interval=20, 
			@freq_relative_interval=0, 
			@freq_recurrence_factor=0,  
			@active_start_time=80000 

	EXEC sp_attach_schedule
			@job_name = N'DatabaseBackup - USER_DATABASES - LOG',
			@schedule_name = N'UserTLogBak';

		SELECT 'UserTLogBak Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'UserTLogBak has been Recreated'
		GOTO End_UserTLogBak_2

End_UserTLogBak_1:
	SELECT 'UserTLogBak Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new UserTLogBak schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_UserTLogBak_2:

GO

-- IndexOptimize - USER_DATABASES (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'UserDB Indexing')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'UserDB Indexing')
				

If @Count = 1 GOTO End_Indexing_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'UserDB Indexing');
			PRINT 'All UserDB Indexing schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'UserDB Indexing'
		BREAK
	END

		EXEC dbo.sp_add_schedule @schedule_name=N'UserDB Indexing', 
				@enabled=1, 
				@freq_type=4, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=0,  
				@active_start_time=10000 
				
		EXEC sp_attach_schedule
				@job_name = N'IndexOptimize - USER_DATABASES',
				@schedule_name = N'UserDB Indexing';


	SELECT 'UserDB Indexing Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'UserDB Indexing has been Recreated'
		GOTO End_Indexing_2

End_Indexing_1:
	SELECT 'UserDB Indexing Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new UserDB Indexing schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_Indexing_2:

GO

-- sp_delete_backuphistory (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'DeleteBakHistory')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'DeleteBakHistory')
				

If @Count = 1 GOTO End_DeleteBakHistory_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'DeleteBakHistory');
			PRINT 'All DeleteBakHistory schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'DeleteBakHistory'
		BREAK
	END

		EXEC dbo.sp_add_schedule @schedule_name=N'DeleteBakHistory', 
				@enabled=1, 
				@freq_type=16, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=1,   
				@active_start_time=100000 

		EXEC sp_attach_schedule
				@job_name = N'sp_delete_backuphistory',
				@schedule_name = N'DeleteBakHistory';

	SELECT 'DeleteBakHistory Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'DeleteBakHistory has been Recreated'
		GOTO End_DeleteBakHistory_2

End_DeleteBakHistory_1:
	SELECT 'DeleteBakHistory Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new DeleteBakHistory schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_DeleteBakHistory_2:

GO

-- DatabaseIntegrityCheck - USER_DATABASES (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'DBCCUserDB')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'DBCCUserDB')
				

If @Count = 1 GOTO End_DBCCUserDB_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'DBCCUserDB');
			PRINT 'All DBCCUserDB schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'DBCCUserDB'
		BREAK
	END

		EXEC dbo.sp_add_schedule @schedule_name=N'DBCCUserDB', 
				@enabled=1, 
				@freq_type=8, 
				@freq_interval=74, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=1,   
				@active_start_time=223000 

		EXEC sp_attach_schedule
				@job_name = N'DatabaseIntegrityCheck - USER_DATABASES',
				@schedule_name = N'DBCCUserDB';

	SELECT 'DBCCUserDB Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'DBCCUserDB has been Recreated'
		GOTO End_DBCCUserDB_2

End_DBCCUserDB_1:
	SELECT 'UserTLogBak Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new UserTLogBak schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_DBCCUserDB_2:

GO

--DatabaseBackup - USER_DATABASES - FULL (Schedule Modification)
DECLARE @Count int

SET @Count = (SELECT COUNT(ssc.schedule_uid)
				FROM sysjobschedules sjs RIGHT OUTER JOIN sysschedules ssc
					ON sjs.schedule_id = ssc.schedule_id
				WHERE ssc.name = 'UserDB Full')

DECLARE @SSCount int

SET @SSCount = (SELECT COUNT(*)FROM sysschedules WHERE name = 'UserDB Full')
				

If @Count = 1 GOTO End_UserDB_Full_1
		WHILE @Count >=1
	BEGIN
			DELETE FROM sysjobschedules WHERE EXISTS (SELECT *	FROM sysjobschedules AS sjs
																	JOIN sysschedules AS ss
																		ON ss.schedule_id = sjs.schedule_id
																	WHERE ss.name = 'UserDB Full');
			PRINT 'All UserDB Full schedules have been deleted'
		IF @SSCount >= 0
			DELETE FROM sysschedules WHERE name = 'UserDB Full'
		BREAK
	END

		EXEC dbo.sp_add_schedule @schedule_name=N'UserDB Full', 
				@enabled=1, 
				@freq_type=4, 
				@freq_interval=1, 
				@freq_subday_type=1, 
				@freq_subday_interval=0, 
				@freq_relative_interval=0, 
				@freq_recurrence_factor=0, 
				@active_start_time=40000 

		EXEC sp_attach_schedule
				@job_name = N'DatabaseBackup - USER_DATABASES - FULL',
				@schedule_name = N'UserDB Full';

	SELECT 'UserDB Full Schedule Count was = ' +  CAST(@Count AS varchar(10)) AS Total
		PRINT'UserDB Full has been Recreated'
		GOTO End_UserDB_Full_2

End_UserDB_Full_1:
	SELECT 'UserDB Full Schedule Count = ' +  CAST(@Count AS varchar(10)) AS Total
	PRINT'A new UserDB Full schedule has not been created as one with name exists, you may like to review the settings for this schedule'

End_UserDB_Full_2:

GO


