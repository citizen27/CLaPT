# Specify the root directory where you want to start the search
$rootDirectory = "$home\Desktop\CLaPT"

# Get a list of all script files recursively within the root directory
$scriptFiles = Get-ChildItem -Path $rootDirectory -Filter *.ps1 -File -Recurse

# Loop through and execute each script file
foreach ($scriptFile in $scriptFiles) {
    Write-Host "Executing script: $($scriptFile.FullName)"
    
    # Execute the script
    Invoke-Expression -Command (Get-Content -Path $scriptFile.FullName -Raw)
    
    # Add a separator for clarity
    Write-Host "------------------------------------------------------"
}
