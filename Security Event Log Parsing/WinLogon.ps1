﻿# Define the logon event ID (4624)
$eventID = 4624

# Query the Security Event Log for logon events
$logonEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

$outputDirectory = "$home\Desktop\CLaPT_Output\Security\"

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Check if there are logon events
if ($logonEvents.Count -eq 0) {
    Write-Host "No logon events found."
}
else {
    Write-Host "Logon Events:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the logon events
    $logonEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save logon events to a CSV file
    $logonEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\CLaPT_Output\Security\Logon_Events.csv" -NoTypeInformation

    Write-Host "Logon events have been processed and saved to Logon_Events.csv."
}