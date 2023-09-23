# Define the logoff event ID (4625)
$eventID = 4625

# Query the Security Event Log for logoff events
$logonfailEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

# Check if there are logon events
if ($logonfailEvents.Count -eq 0) {
    Write-Host "No failed logon events found."
} 
else {
    Write-Host "Failed Logon Events:"
    Write-Host "-------------------------"

    # Display relevant information from the failed logon events
    $logonfailEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-------------------------"
    }

    # Save logon events to a CSV file
    $logoffEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\Failed_Logon_Events.csv" -NoTypeInformation

    Write-Host "Failed logon events have been processed and saved to Failed_Logon_Events.csv."
}
