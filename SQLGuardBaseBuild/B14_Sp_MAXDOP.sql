/*
Execute sp_CheckMAXDOP after you execute this script
Written by Mr Stewart Murray DBA in Canberra in 2012 who is a keen dragon boat racer
*/

SET NOCOUNT ON

USE [SQLGuard_Ops]
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckMAXDOP]    Script Date: 21/07/2015 11:18:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CheckMAXDOP]

@MAXDOP INT = NULL OUTPUT,
@Action NVARCHAR(MAX) = 'QA'

AS
BEGIN

DECLARE @hyperthreadRatio INT
DECLARE @LogicalCPUs INT
DECLARE @HTEnabled INT
DECLARE @physicalCPU INT
DECLARE @logicalCPUPerNuma INT
DECLARE @NoOfNUMA INT
DECLARE @SuggestedMAXDOP INT
DECLARE @ServerMAXDOP INT
DECLARE @RequestedMAXDOP INT
DECLARE @EngineEdition INT

DECLARE @StartMessage nvarchar(max)
DECLARE @ErrorMessage nvarchar(max)
DECLARE @Error nvarchar(max)

SET @EngineEdition = CAST(SERVERPROPERTY('EngineEdition') as nvarchar)

SELECT  @LogicalCPUs = cpu_count  --AS LogicalCPUs
      , @hyperthreadRatio = hyperthread_ratio  --AS HyperthreadRatio
      , @physicalCPU = cpu_count / hyperthread_ratio  --AS PhysicalCPUs
      , @HTEnabled = CASE WHEN cpu_count > hyperthread_ratio THEN 1 ELSE 0 END --AS HTEnabled
      
FROM sys.dm_os_sys_info
OPTION (RECOMPILE)

SELECT @NoOfNUMA = ( SELECT COUNT(DISTINCT parent_node_id)  --AS NUMANodes
					 FROM sys.dm_os_schedulers -- find NO OF NUMA Nodes 
					 WHERE [status] = 'VISIBLE ONLINE'
					 AND parent_node_id < 64)

SELECT @SuggestedMAXDOP = CASE WHEN @EngineEdition <> 3 THEN 1
							   WHEN @NoOfNUMA = 1 AND @LogicalCPUs / 2 > 8 THEN 8
							   WHEN @NoOfNUMA = 1 THEN @LogicalCPUs / 2
                               WHEN @LogicalCPUs / @NoOfNUMA > 8 THEN 8
			                   ELSE @LogicalCPUs / @NoOfNUMA
                          END -- AS SuggestedMAXDOP
FROM sys.dm_os_sys_info

SELECT @ServerMAXDOP = CAST(Value AS nvarchar) FROM sys.configurations WHERE Name = 'max degree of parallelism'
SELECT @RequestedMAXDOP = @MAXDOP
SELECT @MAXDOP = CASE WHEN @MAXDOP IS NULL THEN @SuggestedMAXDOP 
                      WHEN @MAXDOP < 0 THEN 0
                      WHEN @MAXDOP > 1 AND @EngineEdition <> 3 THEN 1  -- Enterprise
                      WHEN @MAXDOP > @LogicalCPUs THEN @LogicalCPUs
                      ELSE @MAXDOP
                 END

SET @StartMessage = 'MAXDOP: Server default: ' + CAST(@ServerMAXDOP AS nvarchar) 
SET @StartMessage = @StartMessage + ', Logical CPUs: ' + CAST(@LogicalCPUs AS nvarchar) 
SET @StartMessage = @StartMessage + ', Hyperthread Ratio: ' + CAST(@hyperthreadRatio AS nvarchar) 
SET @StartMessage = @StartMessage + ', Physical CPUs: ' + CAST(@physicalCPU AS nvarchar)
SET @StartMessage = @StartMessage + ', Hyper Thread Enabled: ' + CAST(@HTEnabled AS nvarchar) 
SET @StartMessage = @StartMessage + ', Number of NUMA Nodes: ' + CAST(@NoOfNUMA AS nvarchar) 
SET @StartMessage = @StartMessage + ', Engine Edition: ' + CASE WHEN @EngineEdition = 2 THEN 'Standard' 
                                                                WHEN @EngineEdition = 3 THEN 'Enterprise' 
                                                                WHEN @EngineEdition = 4 THEN 'Express' 
                                                                ELSE 'Unknown' 
                                                           END  + CHAR(13) + CHAR(10)
SET @StartMessage = @StartMessage + '        Suggested MAXDOP value:     ' + CAST(@SuggestedMAXDOP AS nvarchar) + CHAR(13) + CHAR(10)
IF @Action  = 'REINDEX'
  BEGIN
	SET @StartMessage = @StartMessage + '        USING     MAXDOP RUN value: ' +  ISNULL(CAST(@MAXDOP AS nvarchar), 'NULL')  
																		       + ' (Requested value: ' + ISNULL(CAST(@RequestedMAXDOP AS nvarchar), 'NULL') 
	SET @StartMessage = @StartMessage + CASE WHEN @RequestedMAXDOP > 1 AND @EngineEdition <> 3
											   THEN ' is not supported. USE MAXDOP = 1' 
											 WHEN @RequestedMAXDOP < 0 OR @RequestedMAXDOP > 64 OR @RequestedMAXDOP > @LogicalCPUs OR (@RequestedMAXDOP > 1 AND SERVERPROPERTY('EngineEdition') <> 3) 
											   THEN ' is not supported.'
											 WHEN (@RequestedMAXDOP IN (0,1))AND @EngineEdition <> 3
											   THEN ''
											 WHEN (@RequestedMAXDOP IN (0,1))
											   THEN ' is NOT recommeded when rebuilding indexes.'
											 ELSE ''																		
										END
										
	SET @StartMessage = @StartMessage + ')' + CHAR(13) + CHAR(10)
  END
SET @StartMessage = REPLACE(@StartMessage,'%','%%') + CHAR(13) + CHAR(10)
RAISERROR(@StartMessage,10,1) WITH NOWAIT     
     
END
