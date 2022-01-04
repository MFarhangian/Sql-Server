/*
    Description:        Auto generate SQL Server restore script from backup files in a directory
						The script below will read through the directory and create the restore script for us.  
						The only two parameters that would need to change are the @dbName and the @backupPath.
 
    Author:             Mohsen Farhangian
	Email:				Mohsen.Farhangian@ymail.com  
	Create date:		2020/05/10

 
*/

USE Master; 
GO  
SET NOCOUNT ON 

-- 1 - Variable declaration 
DECLARE @dbName sysname 
DECLARE @backupPath NVARCHAR(500) 
DECLARE @cmd NVARCHAR(500) 
DECLARE @fileList TABLE (backupFile NVARCHAR(255)) 
DECLARE @lastFullBackup NVARCHAR(500) 
DECLARE @lastDiffBackup NVARCHAR(500) 
DECLARE @backupFile NVARCHAR(500) 

-- 2 - Initialize variables 
SET @dbName = 'Common' 
SET @backupPath = 'D:\Backup_Databases\MyTest\' 

-- 3 - get list of files 
SET @cmd = 'DIR /b "' + @backupPath + '"'
--Print @cmd

INSERT INTO @fileList(backupFile) 
EXEC master.sys.xp_cmdshell @cmd 

--SELECT * FROM @fileList

-- 4 - Find latest full backup 
SELECT @lastFullBackup = MAX(backupFile)  
FROM @fileList  
WHERE backupFile LIKE '%.BAK'  
   AND backupFile LIKE  '%'+ @dbName + '%' 

SET @cmd = 'RESTORE DATABASE [' + @dbName + '] FROM DISK = '''  
       + @backupPath + @lastFullBackup + ''' WITH NORECOVERY, REPLACE' 
PRINT @cmd 

-- 4 - Find latest diff backup 
SELECT @lastDiffBackup = MAX(backupFile)  
FROM @fileList  
WHERE backupFile LIKE '%.DIF'  
   AND backupFile LIKE '%'+ @dbName + '%' 
   AND backupFile > @lastFullBackup 

-- check to make sure there is a diff backup 
IF @lastDiffBackup IS NOT NULL 
BEGIN 
   SET @cmd = 'RESTORE DATABASE [' + @dbName + '] FROM DISK = '''  
       + @backupPath + @lastDiffBackup + ''' WITH NORECOVERY' 
   PRINT @cmd 
   SET @lastFullBackup = @lastDiffBackup 
END 

-- 5 - check for log backups 
DECLARE backupFiles CURSOR FOR  
   SELECT backupFile  
   FROM @fileList 
   WHERE backupFile LIKE '%.TRN'  
   AND backupFile LIKE '%'+ @dbName + '%' 
   AND backupFile > @lastFullBackup 

OPEN backupFiles  

-- Loop through all the files for the database  
FETCH NEXT FROM backupFiles INTO @backupFile  

WHILE @@FETCH_STATUS = 0  
BEGIN  
   SET @cmd = 'RESTORE LOG [' + @dbName + '] FROM DISK = '''  
       + @backupPath + @backupFile + ''' WITH NORECOVERY' 
   PRINT @cmd 
   FETCH NEXT FROM backupFiles INTO @backupFile  
END 

CLOSE backupFiles  
DEALLOCATE backupFiles  

-- 6 - put database in a useable state 
SET @cmd = 'RESTORE DATABASE [' + @dbName + '] WITH RECOVERY' 
PRINT @cmd 