# Specify output directory
$outputDirectory = "$home\Desktop\CLaPT_Output\NTUSER\"

# Get the current user's SID
$userSID = (Get-LocalUser -Name $env:USERNAME).SID

if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Define an array of registry keys you want to extract
$registryKeys = @(
    # Auto-Start
    "Software\Microsoft\Windows\CurrentVersion\Run",
    "Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "Software\Microsoft\Windows\CurrentVersion\Runonce",

    # Explorer Searches
    "Software\Microsoft\Windows\CurrentVersion\Explorer\WordwheelQuery",

    # Microsoft Office Server Connections
    "Software\Microsoft\Office\<Office Version>\Common\Open Find\Microsoft Office Server\Recent Server List",

    # MRUs
    "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\Policies\RunMR",
    "Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\",

    # Mount Points2 (User Assigned Drive Letters)
    "Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2",

    # Network Information
    "Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Unmanaged & Software\Microsoft\Windows",
    "Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles",
    "Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Managed & Software\Microsoft\Windows NT\CurrentVersion\NetworkList\Nla\Cache",

    # Printer Jobs and Connections 
    "\Printers\Connections",

    # Recent Docs
    "Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs\",
    "Software\Microsoft\Office\*\*\FileMRU",
    "Software\Microsoft\Office\*\*\UserMRU\LiveID_###\FileMRU",

    # Shellbags
    "Software\Microsoft\Windows\Shell\BagMRU",
    "Software\Microsoft\Windows\Shell\Bags",
 
    # Typed Paths (Win 10 only)
    "Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths",

    # Typed URLs
    "Software\Microsoft\Internet Explorer\TypedURLs",

    # User Account Information
    "Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs",

    # User Assist 
    "Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\*\Count"
)

# Initialize an array to store skipped registry keys
$skippedKeys = @()

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

        # Check if the CSV file exists before attempting to move it
        if (Test-Path -Path $CSVFilePath) {
            # Check if the CSV file is empty, and if so, move it to the "No Responsive Results" subfolder with a random number appended to the filename
            if (!(Get-Content -Path $CSVFilePath)) {
                $NoResponsiveResultsFolder = Join-Path -Path $outputDirectory -ChildPath "No Responsive Results"
                if (-not (Test-Path -Path $NoResponsiveResultsFolder)) {
                    New-Item -Path $NoResponsiveResultsFolder -ItemType Directory
                }
                $RandomNumber = Get-Random -Minimum 1 -Maximum 10000
                $NewFileName = "$keyName-$RandomNumber.csv"
                $NewFilePath = Join-Path -Path $NoResponsiveResultsFolder -ChildPath $NewFileName
                Move-Item -Path $CSVFilePath -Destination $NewFilePath
                Write-Host "No data for key $keyPath. CSV file moved to $NewFilePath"
            }
            else {
                # Move the CSV file to the "Responsive Results" folder
                $ResponsiveResultsFolder = Join-Path -Path $outputDirectory -ChildPath "Responsive Results"
                if (-not (Test-Path -Path $ResponsiveResultsFolder)) {
                    New-Item -Path $ResponsiveResultsFolder -ItemType Directory
                }
                $ResponsiveFilePath = Join-Path -Path $ResponsiveResultsFolder -ChildPath "$keyName.csv"
                Move-Item -Path $CSVFilePath -Destination $ResponsiveFilePath
                Write-Host "Data for key $keyPath has been moved to Responsive Results folder: $ResponsiveFilePath"
            }
        }
    }
    else {
        # Add the skipped key to the array
        $skippedKeys += $fullKeyPath
        Write-Host "Registry key path does not exist: $fullKeyPath. Skipping..."
    }
}

# Define the path for the skipped keys file
$skippedKeysFilePath = Join-Path -Path $outputDirectory -ChildPath "NonExistingKeys.txt"

# Write the skipped keys to the file
$skippedKeys | Out-File -FilePath $skippedKeysFilePath

Write-Host "Skipped keys have been saved to: $skippedKeysFilePath"