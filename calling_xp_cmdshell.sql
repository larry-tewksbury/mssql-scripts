-- Configure advanced options to temporarily allow xp_cmdshell
exec sp_configure 'show advanced options',1;
reconfigure;
exec sp_configure 'xp_cmdshell',1;
reconfigure;
/*
Please note that complex commands (in this case, passing PowerShell to xp_cmdshell)
requires the use of DOS 8.3 notation because of xp_cmdshell's limitations. Quotes
should be avoided whenever possible, though there are ways to pass quotes in xp_cmdshell.
Example is shown below. Declaring @cmd lets you pass quotes and other special characters
inside the command call. Single quotes still escape t-sql though.
*/
-- Declare and execute the actual command
declare @cmd varchar(8000);
set @cmd = 'powershell.exe -command "get-childitem -path C:\PROGRA~2"';
set @cmd = 'CMD /S /C " ' + @cmd + '"';
-- Use the following to "check" the command that's being sent
-- select @cmd;
-- Set your advanced options back to where they were before
exec xp_cmdshell @cmd;
exec sp_configure 'xp_cmdshell',0;
reconfigure;

-- Alternatively, use single quotes to escape t-sql single quotes, like so:
-- set @cmd = 'powershell.exe -command "get-childitem -path ''C:\PROGRAM FILES (x86)''"';