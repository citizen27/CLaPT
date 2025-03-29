# Define the event IDs for Security and System logs for potential tampering events
$securityEventID = @(1102, 4719)
$systemEventID = @(104)

# Build XPath filters for Security and System Event IDs
$securityXPathFilter = "System[(" + ($securityEventID -join " or ") + ")]"
$systemXPathFilter = "System[(" + ($systemEventID -join " or ") + ")]"

# Query the Security Event Log for potential evidence of tampering events
$tamperingEventsSecurity = Get-WinEvent -LogName Security -FilterXPath $securityXPathFilter

# Query the System Event Log for potential evidence of tampering events
$tamperingEventsSystem = Get-WinEvent -LogName System -FilterXPath $systemXPathFilter

# Output directories for Security and System logs
$securityOutputDirectory = "$home\Desktop\CLaPT_Output\Security\"
$systemOutputDirectory = "$home\Desktop\CLaPT_Output\System\"

# Create output directories if they don't exist
if (-not (Test-Path -Path $securityOutputDirectory)) {
    New-Item -Path $securityOutputDirectory -ItemType Directory
}

if (-not (Test-Path -Path $systemOutputDirectory)) {
    New-Item -Path $systemOutputDirectory -ItemType Directory
}

# Check if there are tampering events in Security log
if ($tamperingEventsSecurity.Count -eq 0) {
    Write-Host "No potential tampering events found in Security log."
} 
else {
    Write-Host "Potential Tampering Events in Security Log:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the potential tampering events in Security log
    $tamperingEventsSecurity | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save potential tampering events in Security log to a CSV file
    $tamperingEventsSecurity | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$securityOutputDirectory\Potential_Tampering_Events_Security.csv" -NoTypeInformation

    Write-Host "Potential tampering events in Security log have been processed and saved to tamperingEventsSecurity.csv."
}

# Check if there are potential evidence of tampering events in System log
if ($tamperingEventsSystem.Count -eq 0) {
    Write-Host "No potential tampering events found in System log."
} 
else {
    Write-Host "Potential Tampering Events in System Log:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the Event ID 104 events in System log
    $tamperingEventsSystem | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $message = $evt.Message
        Write-Host "Time: $timeCreated"
        Write-Host "Message: $message"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save potential evidence of tampering events in System log to a CSV file
    $tamperingEventsSystem | Select-Object TimeCreated, Message | Export-Csv -Path "$systemOutputDirectory\Potential_Tampering_Events_System.csv" -NoTypeInformation

    Write-Host "Potential tampering events in the System log have been processed and saved to Potential_Tampering_Events_System.csv."
}
