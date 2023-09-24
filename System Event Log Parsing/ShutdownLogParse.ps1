# Define the event IDs relating to Windows OS shutdown
$eventIDs = @(41, 1074, 6006, 6008)

# Query the System Event Log for shutdown events
$shutdownEvents = Get-WinEvent -LogName System | Where-Object { $_.Id -in $eventIDs }

# Check if there are shutdown events
if ($shutdownEvents.Count -eq 0) {
    Write-Host "No Windows shutdown events found."
} 
else {
    Write-Host "Windows Shutdown Events:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/-"

     # Sort the shutdown events by Event ID and timestamp
    $shutdownEvents = $shutdownEvents | Sort-Object Id, TimeCreated

    # Display relevant information from the shutdown events
    $shutdownEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Event ID: $($evt.Id)"
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/-"
    }

    # Save shutdown events to a CSV file
    $shutdownEvents | Select-Object Id, TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\Windows_Shutdown_Events.csv" -NoTypeInformation

    Write-Host "Windows shutdown events have been processed and saved to Windows_Shutdown_Events.csv."
}