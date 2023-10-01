# Define the account name change event ID (4781)
$eventID = 4781

# Query the Security Event Log for account name change events
$namechangeEvents = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=$eventID)]]"

$outputDirectory = "$home\Desktop\CLaPT_Output\Security\"

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Check if there are account name change events
if ($namechangeEvents.Count -eq 0) {
    Write-Host "No account name change events found."
}
else {
    Write-Host "Account Name Change Events:"
    Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"

    # Display relevant information from the account name change events
    $namechangeEvents | ForEach-Object {
        $evt = $_
        $timeCreated = $evt.TimeCreated
        $user = $evt.Properties[5].Value
        Write-Host "Time: $timeCreated"
        Write-Host "User: $user"
        Write-Host "-/-/-/-/-/-/-/-/-/-/-/-/"
    }

    # Save account name change events to a CSV file
    $namechangeEvents | Select-Object TimeCreated, @{Name = "User"; Expression = { $_.Properties[5].Value } } | Export-Csv -Path "$home\Desktop\CLaPT_Output\Security\Account_Name_Change.csv" -NoTypeInformation

    Write-Host "Account name change events have been processed and saved to Account_Name_Change.csv."
}