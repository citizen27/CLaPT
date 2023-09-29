# Define the logon event ID (4663)
$eventID = 4663

# Query the Security Event Log for Object Access Attempt events
$OAAEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

# Check if there are Object Access Attempt events
if ($OAAEvents.Count -eq 0) {
    Write-Host "No logon events found."
}
else {
    Write-Host "Oject Access Attempt Events:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the Object Access Attempt events
    $OAAEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save logon events to a CSV file
    $OAAEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\CLaPT_Output\Security\Object_Access_Attempt_Events.csv" -NoTypeInformation

    Write-Host "Object Access Attempt events have been processed and saved to Object_Access_Attempt_Events.csv."
}