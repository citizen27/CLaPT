# Define the path to the SetupAct.log file
$logFilePath = "C:\Windows\Panther\SetupAct.log"

# Define the path for the output CSV file
$outputCsvPath = "$home\Desktop\CLaPT_Output\Panther_SetupAct_Parsed.csv"

# Initialize an array to store parsed data
$parsedData = @()

# Initialize variables to store information about the current log entry
$timestamp = $null
$eventType = $null
$eventMessage = $null

# Read the log file line by line
Get-Content -Path $logFilePath | ForEach-Object {
    # Split each line into timestamp, event type, and event message
    $line = $_
    $parts = $line -split '\s+'
    
    if ($parts.Count -ge 3) {
        $timestamp = $parts[0]
        $eventType = $parts[1].Trim('[', ']')
        $eventMessage = $parts[2..($parts.Length - 1)] -join ' '

        # Create an object to store the parsed data
        $parsedEntry = [PSCustomObject]@{
            "Timestamp" = $timestamp
            "EventType" = $eventType
            "EventMessage" = $eventMessage
        }

        # Add the parsed entry to the array
        $parsedData += $parsedEntry
    }
}

# Save the parsed data to a CSV file
$parsedData | Export-Csv -Path $outputCsvPath -NoTypeInformatio

# Display a message indicating the process is complete
Write-Host "Log parsing complete. Results saved to $outputCsvPath."
