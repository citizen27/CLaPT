#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\PantherParser\PantherELTParse.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\PantherParser\PantherSetupActParser.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\Security Event Log Parsing\EventLogTamper.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\Security Event Log Parsing\FailedLogon.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\ObjectAccess.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\SystemTimeChange.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\WinLogoff.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\WinLogon.ps1"
#Invoke-Command -FilePath "C:\Users\jacob\Desktop\CLaPT\ShutdownLog.ps1"


$Master = Split-Path $MyInvocation.MyCommand.Definition -Leaf
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
Get-ChildItem "$ScriptPath\*.ps1" | Where-Object{$_.Name -ne $Master} | ForEach-Object { & $_.FullName }