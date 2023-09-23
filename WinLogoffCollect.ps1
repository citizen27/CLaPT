# Define the logoff event ID (4634)
$eventID = 4634

# Query the Security Event Log for logoff events
$logoffEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

# Check if there are logoff events
if ($logoffEvents.Count -eq 0) {
    Write-Host "No logoff events found."
} else {
    $logoffData = @()

    # Iterate through logoff events and extract information
    $logoffEvents | ForEach-Object {
        $event = $_
        $timeCreated = $event.TimeCreated
        $user = $event.Properties[1].Value  # Use Property index 1 for TargetUserName

        # Create a custom object with logoff event details
        $logoffEvent = New-Object PSObject -Property @{
            "Time" = $timeCreated
            "User" = $user
        }

        # Add the logoff event to the data array
        $logoffData += $logoffEvent
    }

    # Display logoff events in a well-formatted table
    $logoffData | Format-Table -AutoSize

    # Save logoff events to a CSV file
    $logoffData | Export-Csv -Path "$home\Desktop\LogoffEvents.csv" -NoTypeInformation

    Write-Host "Logoff events have been processed and saved to LogoffEvents.csv."
}
