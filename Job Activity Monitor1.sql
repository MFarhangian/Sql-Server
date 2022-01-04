  /*

	Description:	Job Activity Monitor

    Author:			Mohsen Farhangian
	Email:			Mohsen.Farhangian@ymail.com
	Create date:	2021/09/18

*/

EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO
IF OBJECT_ID('tempdb..#Temp_Activity') IS NOT NULL  
    DROP TABLE #Temp_Activity;
GO
CREATE TABLE  #Temp_Activity 
(
    job_id NVARCHAR(MAX),
    originating_server NVARCHAR(MAX),
    NAME NVARCHAR(MAX),
    ENABLED NVARCHAR(MAX),
    description NVARCHAR(MAX),
    start_step_id NVARCHAR(MAX),
    category NVARCHAR(MAX),
    OWNER NVARCHAR(MAX),
    notify_level_eventlog NVARCHAR(MAX),
    notify_level_email NVARCHAR(MAX),
    notify_level_netsend NVARCHAR(MAX),
    notify_level_page NVARCHAR(MAX),
    notify_email_operator NVARCHAR(MAX),
    notify_netsend_operator NVARCHAR(MAX),
    notify_page_operator NVARCHAR(MAX),
    delete_level NVARCHAR(MAX),
    date_created NVARCHAR(MAX),
    date_modified NVARCHAR(MAX),
    version_number NVARCHAR(MAX),
    last_run_date NVARCHAR(MAX),
    last_run_time NVARCHAR(MAX),
    last_run_outcome NVARCHAR(MAX),
    next_run_date NVARCHAR(MAX),
    next_run_time NVARCHAR(MAX),
    next_run_schedule_id NVARCHAR(MAX),
    current_execution_status NVARCHAR(MAX),
    current_execution_step NVARCHAR(MAX),
    current_retry_attempt NVARCHAR(MAX),
    has_step NVARCHAR(MAX),
    has_schedule NVARCHAR(MAX),
    has_target NVARCHAR(MAX),
    type NVARCHAR(MAX)
);
INSERT INTO #Temp_Activity
SELECT *
FROM
    OPENROWSET('sqloledb',
               'server=localhost;trusted_connection=yes',
               'exec msdb.dbo.sp_help_job WITH RESULT SETS
((    job_id NVARCHAR(MAX),
    originating_server NVARCHAR(MAX),
    NAME NVARCHAR(MAX),
    ENABLED NVARCHAR(MAX),
    description NVARCHAR(MAX),
    start_step_id NVARCHAR(MAX),
    category NVARCHAR(MAX),
    OWNER NVARCHAR(MAX),
    notify_level_eventlog NVARCHAR(MAX),
    notify_level_email NVARCHAR(MAX),
    notify_level_netsend NVARCHAR(MAX),
    notify_level_page NVARCHAR(MAX),
    notify_email_operator NVARCHAR(MAX),
    notify_netsend_operator NVARCHAR(MAX),
    notify_page_operator NVARCHAR(MAX),
    delete_level NVARCHAR(MAX),
    date_created NVARCHAR(MAX),
    date_modified NVARCHAR(MAX),
    version_number NVARCHAR(MAX),
    last_run_date NVARCHAR(MAX),
    last_run_time NVARCHAR(MAX),
    last_run_outcome NVARCHAR(MAX),
    next_run_date NVARCHAR(MAX),
    next_run_time NVARCHAR(MAX),
    next_run_schedule_id NVARCHAR(MAX),
    current_execution_status NVARCHAR(MAX),
    current_execution_step NVARCHAR(MAX),
    current_retry_attempt NVARCHAR(MAX),
    has_step NVARCHAR(MAX),
    has_schedule NVARCHAR(MAX),
    has_target NVARCHAR(MAX),
    type NVARCHAR(MAX))
)'    );


SELECT *
FROM #Temp_Activity
ORDER BY next_run_date DESC;










