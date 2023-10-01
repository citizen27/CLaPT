# Define the user account lockout event ID (4740)
$eventID = 4740

# Query the Security Event Log for user account lockout events
$userlockoutEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

$outputDirectory = "$home\Desktop\CLaPT_Output\Security\"

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Check if there are system time change events
if ($userlockoutEvents.Count -eq 0) {
    Write-Host "No User Account Lockout events found."
}
else {
    Write-Host "User Account Lockout Events:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the user account lockout events
    $userlockoutEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save user account lockout events to a CSV file
    $userlockoutEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\CLaPT_Output\Security\User_Account_Lockout.csv" -NoTypeInformation

    Write-Host "User Account Lockout events have been processed and saved to User_Account_Lockout.csv."
}