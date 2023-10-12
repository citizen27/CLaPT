# Function to map Event IDs to descriptions
function Get-EventDescription {
    param (
        [int]$EventID
    )

    $eventDescriptions = @{
        4624 = "An account was successfully logged on"
        4625 = "An account failed to log on"
        4626 = "User/Device claims information"
        4627 = "Group membership information"
        4634 = "An account was logged off"
        4646 = "IKE DoS-prevention mode started"
        4647 = "User initiated logoff"
        4648 = "A logon was attempted using explicit credentials"
        4649 = "A replay attack was detected"
        4650 = "An IPsec Main Mode security association was established"
        4651 = "An IPsec Main Mode security association was established"
        4652 = "An IPsec Main Mode negotiation failed"
        4653 = "An IPsec Main Mode negotiation failed"
        4654 = "An IPsec Quick Mode negotiation failed"
        4655 = "An IPsec Main Mode security association ended"
        4672 = "Special privileges assigned to new logon"
        4675 = "SIDs were filtered"
        4778 = "A session was reconnected to a Window Station"
        4779 = "A session was disconnected from a Window Station"
        4800 = "The workstation was locked"
        4801 = "The workstation was unlocked"
        4802 = "The screen saver was invoked"
        4803 = "The screen saver was dismissed"
        4964 = "Special groups have been assigned to a new logon"
        4976 = "During Main Mode negotiation, IPsec received an invalid negotiation packet."
        4977 = "During Quick Mode negotiation, IPsec received an invalid negotiation packet."
        4978 = "During Extended Mode negotiation, IPsec received an invalid negotiation packet."
        4979 = "IPsec Main Mode and Extended Mode security associations were established."
        4980 = "IPsec Main Mode and Extended Mode security associations were established"
        4981 = "IPsec Main Mode and Extended Mode security associations were established"
        4982 = "IPsec Main Mode and Extended Mode security associations were established"
        4983 = "An IPsec Extended Mode negotiation failed"
        4984 = "An IPsec Extended Mode negotiation failed"
        5378 = "The requested credentials delegation was disallowed by policy"
        5451 = "An IPsec Quick Mode security association was established"
        5452 = "An IPsec Quick Mode security association ended"
        5453 = "An IPsec negotiation with a remote computer failed because the IKE and AuthIP IPsec Keying Modules (IKEEXT) service is not started"
        5632 = "A request was made to authenticate to a wireless network"
        5633 = "A request was made to authenticate to a wired network"
        6272 = "Network Policy Server granted access to a user"
        6273 = "Network Policy Server denied access to a user"
        6274 = "Network Policy Server discarded the request for a user"
        6275 = "Network Policy Server discarded the accounting request for a user"
        6276 = "Network Policy Server quarantined a user"
        6277 = "Network Policy Server granted access to a user but put it on probation because the host did not meet the defined health policy"
        6278 = "Network Policy Server granted full access to a user because the host met the defined health policy"
        6279 = "Network Policy Server locked the user account due to repeated failed authentication attempts"
        6280 = "Network Policy Server unlocked the user account"
    }

    return $eventDescriptions[$EventID]
}


# Define the output CSV file path and filename
$outputDirectory = "$home\Desktop\CLaPT_Output\Security\LogOn-Logoff\"
$outputFileName = "Related_To_Logon-Logoff.csv"
$outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Define the log name and Event IDs you want to query
$logName = "Security"
$eventIDs = @(4624, 4625, 4626, 4627, 4634, 4646, 4647, 4648, 4649, 4650,
              4651, 4652, 4653, 4654, 4655, 4672, 4675, 4778, 4779, 4800,
              4801, 4802, 4803, 4964, 4976, 4977, 4978, 4979, 4980, 4981,
              4982, 4983, 4984, 5378, 5451, 5452, 5453, 5632, 5633, 6272,
              6273, 6274, 6275, 6276, 6277, 6278, 6279, 6280
              )  

# Query the Windows Event Log for the specified Event IDs
$logonEvents = Get-WinEvent -LogName $logName | Where-Object { $_.Id -in $eventIDs }

# Filter and sort the logon events by time
$logonEvents = $logonEvents | Sort-Object TimeCreated

# Create an array to store logon event objects
$logonEventObjects = @()

# Loop through each logon event and extract relevant information
foreach ($event in $logonEvents) {
    $time = $event.TimeCreated
    $eventID = $event.Id
    $eventDescription = Get-EventDescription -EventID $eventID
    $accountName = $event.Properties[5].Value  # Account Name

    # Create a custom object for the logon event
    $logonEventObject = [PSCustomObject]@{
        "Time" = $time
        "EventID" = $eventID
        "Description" = $eventDescription
        "AccountName" = $accountName
    }

    # Add the logon event object to the array
    $logonEventObjects += $logonEventObject
}

# Export the logon event information to a CSV file
$logonEventObjects | Select-Object -Unique "Time", "EventID", "Description", "AccountName" | Export-Csv -Path $outputFilePath -NoTypeInformation 

Write-Host "Logon events have been saved to $outputFilePath"