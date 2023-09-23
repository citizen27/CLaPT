﻿# Define the logoff event ID (4634)
$eventID = 4634

# Query the Security Event Log for logoff events
$logoffEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

# Check if there are logon events
if ($logoffEvents.Count -eq 0) {
    Write-Host "No logoff events found."
} 
else {
    Write-Host "Logoff Events:"
    Write-Host "-------------------------"

    # Display relevant information from the logon events
    $logoffEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-------------------------"
    }

    # Save logon events to a CSV file
    $logoffEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\LogoffEvents.csv" -NoTypeInformation

    Write-Host "Logoff events have been processed and saved to LogonEvents.csv."
}
