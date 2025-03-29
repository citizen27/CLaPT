# Define the source directories
$firefoxSourcePath1 = "$home\AppData\Local\Mozilla\Firefox\"
$firefoxSourcePath2 = "$home\AppData\Roaming\Mozilla\Firefox\"

$chromeSourcePath1 = "$home\AppData\Local\Google\Chrome\User Data\Default\"

# Define custom names for the zip files
$firefoxZipName1 = "Local_Firefox.zip"
$firefoxZipName2 = "Roaming_Firefox.zip"
$chromeZipName1 = "Chrome_UserData.zip"

# Define the destination folder
$destinationFolder = "$home\Desktop\CLaPT_Output\Collected Internet Artifacts\"

# Create the destination folder if it doesn't exist
if (-not (Test-Path $destinationFolder -PathType Container)) {
    New-Item -Path $destinationFolder -ItemType Directory
}

# Function to copy folders and zip files with progress
function Copy-AndZipFolders {
    param (
        [string]$sourcePath,
        [string]$zipFileName
    )

    if (Test-Path $sourcePath) {
        
        # Define the zip file path with the custom name
        $zipFilePath = Join-Path -Path $destinationFolder -ChildPath $zipFileName

        # Compress the source folder and create the custom-named zip file
        Compress-Archive -Path $sourcePath -DestinationPath $zipFilePath
    }
}

# Call the function to copy and zip folders with custom names
Copy-AndZipFolders -sourcePath $firefoxSourcePath1 -zipFileName $firefoxZipName1
Copy-AndZipFolders -sourcePath $firefoxSourcePath2 -zipFileName $firefoxZipName2
Copy-AndZipFolders -sourcePath $chromeSourcePath1 -zipFileName $chromeZipName1