# Define the logoff event ID (1102, 4719)
$eventID = @(1102, 4625)

# Query the Security Event Log for potential evidence of Event Log Tampering events
$tamperingEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

# Check if there are tampering events
if ($tamperingEvents.Count -eq 0) {
    Write-Host "No potential tampering events found."
} 
else {
    Write-Host "Potential Tampering Events:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the potential tampering events
    $tamperingEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save potential tampering events to a CSV file
    $tamperingEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\CLaPT_Output\Potential_Tampering_Events.csv" -NoTypeInformation

    Write-Host "Failed logon events have been processed and saved to Potential_Tampering_Events.csv."
}