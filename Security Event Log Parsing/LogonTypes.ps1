# Define the log name (Security) and logon event ID (4624 for successful logons)
$logName = "Security"
$logonEventID = 4624

# Define the output CSV file path and filename
$outputDirectory = "$home\Desktop\CLaPT_Output\Security\"
$outputFileName = "Logon_Events.csv"
$outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Define a hashtable to map logon types to descriptions
$logonTypeDescriptions = @{
    2 = "Logon via Console"
    3 = "Network Logon"
    4 = "Batch Logon"
    5 = "Windows Service Logon"
    7 = "Workstation Unlock Logon"
    8 = "Network Cleartext Logon"
    9 = "Different Credentials Logon"
    10 = "RDP Logon"
    11 = "Cached Interactive Logon"
    12 = "Cached Remote Interactive Logon"
    13 = "Cached Unlock"
}

# Query the Windows Event Log for logon events
$logonEvents = Get-WinEvent -LogName $logName -FilterXPath "*[System[EventID=$logonEventID]]"

# Create an array to store logon event objects
$logonEventObjects = @()

# Loop through each logon event and extract relevant information
foreach ($event in $logonEvents) {
    $time = $event.TimeCreated
    $eventData = $event.Properties

    $logonType = [int]$eventData[8].Value  # Logon Type (cast to integer)
    $accountName = $eventData[5].Value  # Account Name
    $workstationName = $eventData[18].Value  # Workstation Name (Computer Name)

    # Get the logon type description
    $logonTypeDescription = $logonTypeDescriptions[$logonType]

    # Create a custom object for the logon event
    $logonEventObject = [PSCustomObject]@{
        "Time" = $time
        "LogonType" = "$logonType - $logonTypeDescription"
        "AccountName" = $accountName
        "WorkstationName" = $workstationName
    }

    # Add the logon event object to the array
    $logonEventObjects += $logonEventObject
}

# Export the logon event information to a CSV file
$logonEventObjects | Export-Csv -Path $outputFilePath -NoTypeInformation

Write-Host "Logon events have been saved to $outputFilePath"
