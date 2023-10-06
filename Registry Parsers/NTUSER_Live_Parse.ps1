# Specify output directory
$outputDirectory = "$home\Desktop\CLaPT_Output\NTUSER\"

# Get the current user's SID
$userSID = (Get-LocalUser -Name $env:USERNAME).SID

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Define an array of registry keys you want to extract
$registryKeys = @(
    #Auto-Start
    "Software\Microsoft\Windows\CurrentVersion\Run",
    "Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "Software\Microsoft\Windows\CurrentVersion\Runonce",

    #Explorer Searches
    "Software\Microsoft\Windows\CurrentVersion\Explorer\WordwheelQuery",

    #Microsoft Office Server Connections
    "Software\Microsoft\Office\<Office Version>\Common\Open Find\Microsoft Office Server\Recent Server List",

    #MRUs
    "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\Policies\RunMR",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\",

    #Mount Points2 (User Assigned Drive Letters)
    "Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2",

    #Network Information
    "Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Unmanaged & Software\Microsoft\Windows",
    "Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles",
    "Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Managed & Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Nla\Cache",

    #Printer Jobs and Connections 
    "\Printers\Connections",

    #Recent Docs
    "Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs\",
    "Software\Microsoft\Office\*\*\FileMRU",
    "Software\Microsoft\Office\*\*\UserMRU\LiveID_###\FileMRU",

    #Shellbags
    "Software\Microsoft\Windows\Shell\BagMRU",
    "Software\Microsoft\Windows\Shell\Bags",
 
    #Typed Paths (Win 10 only)
    "Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths",

    #Typed URLs
    "Software\Microsoft\Internet Explorer\TypedURLs",

    #User Account Information
    "Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs",

    #User Assist 
    "Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\*\Count"
)

# Loop through the registry keys
foreach ($keyPath in $registryKeys) {
    $fullKeyPath = "Registry::HKEY_USERS\$userSID\$keyPath"

    # Check if the registry key exists
    if (Test-Path -Path $fullKeyPath) {
        $keyValues = Get-ItemProperty -Path $fullKeyPath | Select-Object -Property PSChildName, * -ExcludeProperty PS*

        # Initialize an array to store the collected data for this key
        $data = @()

        # Loop through the values in the registry key
        foreach ($valueName in $keyValues.PSObject.Properties | Where-Object { $_.Name -ne 'PSChildName' }) {
            # Initialize a variable to hold the decoded data
            $decodedData = $valueName.Value

            # Check if the data is binary
            if ($decodedData -is [byte[]]) {
                # Assuming the binary data represents UTF-16 encoded text, decode it
                $decodedData = [System.Text.Encoding]::Unicode.GetString($decodedData)
            }

            # Create a custom object with the collected data
            $entry = [PSCustomObject]@{
                KeyName   = $keyPath
                ValueName = $valueName.Name
                Data      = $decodedData
            }

            # Add the custom object to the data array for this key
            $data += $entry
        }

        # Get the last three components of the registry key path
        $keyPathComponents = $keyPath -split '\\'
        $keyName = ($keyPathComponents | Select-Object -Last 3) -join '-'

        # Replace invalid characters in the filename with underscores
        $keyName = $keyName -replace '[\\\/:*?"<>|]', '_'

        # Define the CSV file path using the modified naming convention
        $CSVFilePath = Join-Path -Path $outputDirectory -ChildPath "$keyName.csv"

        # Export the data for this key to a CSV file
        $data | Export-Csv -Path $CSVFilePath -NoTypeInformation

        Write-Host "Data for key $keyPath has been exported to $CSVFilePath"
    }
    else {
        # Write a message to the terminal if the registry key path doesn't exist and skip this key
        Write-Host "Registry key path does not exist: $fullKeyPath. Skipping..."
    }
}