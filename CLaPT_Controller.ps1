# Specify the root directory where you want to start the search
$rootDirectory = "$home\Desktop\CLaPT\"

# Specify the path for the error log file
$errorLogFile = "$home\Desktop\CLaPT_Output\ErrorLog.txt"

# Create an empty error log file or clear its contents if it already exists
$null = New-Item -Path $errorLogFile -ItemType File -Force

# Get a list of all script files recursively within the root directory
$scriptFiles = Get-ChildItem -Path $rootDirectory -Filter *.ps1 -File -Recurse

# Loop through and execute each script file
foreach ($scriptFile in $scriptFiles) {
    Write-Host "Executing script: $($scriptFile.FullName)"
    
    # Try to execute the script and capture any errors
    try {
        Invoke-Expression -Command (Get-Content -Path $scriptFile.FullName -Raw)
    }
    catch {
        $errorMessage = "Error in $($scriptFile.FullName): $_"
        Write-Host $errorMessage
        # Append the error message to the error log file
        Add-Content -Path $errorLogFile -Value $errorMessage
    }
    
    # Add a separator for clarity
    Write-Host "------------------------------------------------------"
}

# Exit PowerShell
Exit
