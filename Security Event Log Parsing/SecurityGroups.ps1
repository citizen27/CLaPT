# Define the event IDs for member actions on security enabled groups (4728, 4732, 4756)
$eventID = @(4728, 4732, 4733, 4735, 4756)

# Build the XPath filter for multiple Event IDs
$xPathFilter = "System[(" + ($eventID -join " or ") + ")]"

# Query the Security Event Log for potential evidence of "member actions on security enabled groups" events
$securitygroupEvents = Get-WinEvent -LogName Security -FilterXPath $xPathFilter

$outputDirectory = "$home\Desktop\CLaPT_Output\Security\"

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Check if there are tampering events
if ($securitygroupEvents.Count -eq 0) {
    Write-Host "No member actions on security enabled groups found."
} 
else {
    Write-Host "Member Actions on Security Enabled Groups:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the "member actions on security enabled groups" events
    $securitygroupEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save potential tampering events to a CSV file
    $securitygroupEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\CLaPT_Output\Security\Security_Group_Account_Management.csv" -NoTypeInformation

    Write-Host "Member actions on security enabled groups events have been processed and saved to Security_Group_Account_Management.csv."
}