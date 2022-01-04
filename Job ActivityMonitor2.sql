  /*

	Description:	View the latest job execution status

    Author:			Mohsen Farhangian
	Email:			Mohsen.Farhangian@ymail.com
	Create date:	2021/09/18

*/

USE msdb;
SELECT myJob.name as JobName , myJobActivityMonitor.last_run_outcome
	,CASE myJobActivityMonitor.[last_run_outcome] 
		WHEN 0 THEN 'Fail'
		WHEN 1 THEN 'Succeed'
		WHEN 3 THEN 'Cancel'
		WHEN 5 THEN 'Does not Run'
	End as LastRunState
	,myJobActivityMonitor.[last_outcome_message]
	,CASE WHEN myJobActivityMonitor.[last_run_date] != 0 THEN CONVERT(Date,CAST(myJobActivityMonitor.[last_run_date] as nvarchar(8)),112) ELSE NULL END as LastRunDate
	,CASE WHEN myJobActivityMonitor.[last_run_date] != 0 THEN DateDiff(Day,CAST(getdate() as Date), CONVERT(Date,CAST(myJobActivityMonitor.[last_run_date] as nvarchar(8)),112)) ELSE NULL END as LastRunDaysAgo
	,myJobActivityMonitor.[last_run_time]
	,myJobActivityMonitor.[last_run_duration]
	,myJob.start_step_id as StartStep
FROM [msdb].[dbo].[sysjobservers] as myJobActivityMonitor
INNER JOIN [msdb].[dbo].[sysjobs] as myJob on myJobActivityMonitor.job_id=myJob.job_id
WHERE myJob.[enabled]=1
--	AND myJobActivityMonitor.last_run_outcome NOT IN (1,5)
ORDER BY myJobActivityMonitor.[last_run_outcome],5 Desc