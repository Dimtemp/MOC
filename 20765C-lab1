
Lab: Using SQL Server Administrative Tools
Exercise 1: Using SQL Server Management Studio
Task 1: Prepare the Lab Environment
1. Ensure that the MIA-DC and MIA-SQL virtual machines are both running, and then log on to MIA-SQL as ADVENTUREWORKS\Student with the password Pa55w.rd.
2. In the D:\Labfiles\Lab01\Starter folder, right-click Setup.cmd and then click Run as administrator.
3. Click Yes when prompted to confirm that you want to run the command file, and then wait for the script to finish.

Task 2: Use Object Explorer in SQL Server Management Studio
1. On the task bar, start SQL Server Management Studio.
2. When prompted, connect to the MIA-SQL database engine using Windows authentication.
3. If Object Explorer is not visible, on the View menu, click Object Explorer.
4. In Object Explorer, under MIA-SQL, expand Databases and note the databases that are hosted on this database engine instance.
5. Right-click MIA-SQL, point to Reports, point to Standard Reports, and click Server Dashboard. Then view the server dashboard report for this instance.

Task 3: Create a Database
1. Under MIA-SQL right-click the Databases folder, and click New Database.
2. In the New Database dialog box, enter the database name AWDatabase. Then click OK.
3. 
View the databases listed under the Database folder and verify that the new database has been created.

Task 4: Run a Transact-SQL Query
1. In SQL Server Management Studio, on the toolbar, click New Query.
2. Enter the following Transact-SQL code: EXEC sp_helpdb AWDatabase;
3. Click Execute and view the results, which include information about the AWDatabase you created in the previous task.
4. Save the script file as GetDBInfo.sql in the D:\Labfiles\Lab01\Starter folder.

Task 5: Create a Project
1. In SQL Server Management Studio, on the File menu, point to New and click Project.
2. In the New Project dialog box, select SQL Server Scripts. Then and save the project as AWProject in the D:\Labfiles\Lab01\Starter folder.
3. If Solution Explorer is not visible, on the View menu, click Solution Explorer.
4. In Solution Explorer, right-click Connections and click New Connection. Then connect to the MIA-SQL database engine using Windows authentication.
5. In Solution Explorer, right-click Queries and click New Query. Then when the query is created, right-click SQLQuery1,sql and click Rename, and rename it to BackupDB.sql
6. In Object Explorer, right-click the AWDatabase database you created previously, point to Tasks, and click Back Up.
7. In the Back Up Database – AWDatabase dialog box, in the Script drop-down list, select Script Action to Clipboard. Then click Cancel.
8. Paste the contents of the clipboard into the empty BackupDB.sql script.
9. Edit the BackupDB.sql script to change the backup location to D:\Labfiles\Lab01\Starter\AWDatabase.bak
10. On the File menu, click Save All. Then on the File menu, click Close Solution.
11. Minimize SQL Server Management Studio.

Result: At the end of this exercise, you will have created a SQL Server Management Studio project containing script files.

Exercise 2: Using the sqlcmd Utility
Task 1: Use sqlcmd Interactively
1. Right-click the Start button and click Command Prompt.
2. In the command prompt window, enter the following command to view details of all sqlcmd parameters:
sqlcmd -?
3. Enter the following command to start sqlcmd and connect to MIA-SQL using Windows authentication:
sqlcmd -S MIA-SQL -E
4. In the sqlcmd command line, enter the following commands to view the databases on MIA-SQL. Verify that these include the AWDatabase database you created in the previous exercise.
SELECT name FROM sys.sysdatabases;
GO
5. Enter the following command to exit sqlcmd.
Exit

Task 2: Use sqlcmd to Run a Script
1. In the command prompt window, enter the following command to use sqlcmd to run the GetDBInfo.sql script you created earlier in MIA-SQL.
sqlcmd -S MIA-SQL -E -i D:\Labfiles\Lab01\Starter\GetDBInfo.sql
2. Note that the query results are returned, but they are difficult to read in the command prompt screen.
3. Enter the following command to store the query output in a text file:
sqlcmd -S MIA-SQL -E -i D:\Labfiles\Lab01\Starter\GetDBinfo.sql -o D:\Labfiles\Lab01\Starter\DBinfo.txt
4. Enter the following command to view the text file that was created by sqlcmd:
Notepad D:\Labfiles\Lab01\Starter\DBinfo.txt
5. View the results in the text file, and then close Notepad.
6. Close the command prompt window.
Result: At the end of this exercise, you will have used sqlcmd to manage a database.

Exercise 3: Using Windows PowerShell with SQL Server
Task 1: Use Windows PowerShell
1. On the taskbar, click the Windows PowerShell icon.
2. At the Windows PowerShell prompt, enter the following command:
Get-Process
3. Review the list of services. In the ProcessName column, note the SQL services.
4. Enter the following command to list only the services with names beginning “SQL”,:
Get-Process SQL*
5. To find a way to sort the list, enter the following command:
Get-Help Sort
6. Review the help information, then enter the following command:
Get-Process SQL* | Sort-Object Handles
7. Verify that the list is now sorted by number of handles.
8. Close Windows PowerShell.

Task 2: Using PowerShell in SQL Server Management Studio
1. In SQL Server Management Studio, in Object Explorer, right-click MIA-SQL, and then click Start PowerShell.
2. At the PowerShell prompt, enter the following command:
Get-Module
3. Verify that SQLPS and SQLASCMDLETS are listed.
4. At the Windows PowerShell prompt, enter the following command:
Set-location SQLServer:\SQL\MIA-SQL
5. At the Windows PowerShell prompt, enter the following command to display the SQL Server database engine instances on the server:
Get-ChildItem
6. At the Windows PowerShell prompt, enter the following command:
Set-location SQLServer:\SQL\MIA-SQL\DEFAULT\Databases
7. At the Windows PowerShell prompt, enter the following command to display the databases on the default instance:
Get-ChildItem
8. At the Windows PowerShell prompt, enter the following command:
Invoke-Sqlcmd "SELECT @@version"
9. Review the version information.
10. Close the SQL Server Powershell window and close SQL Server Management Studio without saving any files.

Task 3: Create a PowerShell Script
1. On the task bar, right-click the Windows PowerShell icon and click Windows PowerShell ISE.
2. In the PowerShell command prompt, enter the following command:
Get-Module
3. Verify that the SQLPS module is not loaded. Then enter the following command to load it:
Import-Module SQLPS -DisableNameChecking
4. Enter the following command to verify that the SQLPS module is now loaded.
Get-Module
5. If the Commands pane is not visible, on the View menu, click Show Command Add-on. Then in the Commands pane, in the Modules list, select SQLPS.
6. View the cmdlets in the module, noting that they include cmdlets to perform tasks such as backing up databases and starting SQL Server instances.
7. If the Script pane is not visible, click the Script drop-down arrow.
8. In the Script pane, type the following commands. (Hint: Use the IntelliSense feature.)
Import-Module SQLPS -DisableNameChecking
Set-location SQLServer:\SQL\MIA-SQL\Default\Databases
Get-Childitem | Select Name, Size, SpaceAvailable, IndexSpaceUsage | Out-GridView
9. Click Run Script. Then view the results in the window that is opened. (The script may take a few minutes to run.)
10. Close the window, and modify the script as shown in the following example:
Import-Module SQLPS -DisableNameChecking
Set-location SQLServer:\SQL\MIA-SQL\Default\Databases
Get-Childitem | Select Name, Size, SpaceAvailable, IndexSpaceUsage | Out-File 'D:\Labfiles\Lab01\Starter\Databases.txt'
11. Save the script as GetDatabases.ps1 in the D:\Labfiles\Lab01\Starter folder. Then close the PowerShell ISE.
12. In the D:\Labfiles\Lab01\Starter folder, right-click GetDatabases.ps1 and click Run with PowerShell.
13. When the script has completed, open Databases.txt in Notepad to view the results.
14. Close Notepad.

Result: At the end of this task, you will have a PowerShell script that retrieves information about databases from SQL Server.
