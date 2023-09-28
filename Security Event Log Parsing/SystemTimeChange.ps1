# Define the system time change event ID (4616)
$eventID = 4616

# Query the Security Event Log for system time change events
$systimechangeEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

# Check if there are system time change events
if ($systimechangeEvents.Count -eq 0) {
    Write-Host "No System Time Change events found."
}
else {
    Write-Host "System Time Change Events:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the system time change events
    $systimechangeEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save system time change events to a CSV file
    $systimechangeEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\CLaPT_Output\System_Time_Change.csv" -NoTypeInformation

    Write-Host "System Time Change events have been processed and saved to System_Time_Change.csv."
}