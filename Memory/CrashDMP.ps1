$sourcePath = "C:\Windows\MEMORY.DMP"
$destinationPath = "$home\Desktop\CLaPT\Memory\CrashDMP\"

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

# Copy the file to the destination
Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse