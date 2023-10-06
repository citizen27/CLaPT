# Define the root directory to start the search
$rootDirectory = "$home\Desktop\CLaPT\"

# Get the current date and time for the log file
$logDateTime = Get-Date -Format "yyyyMMddHHmmss"
$logFilePath = "$home\Desktop\CLaPT_Output\RunScriptLog_$logDateTime.csv"

# Create an empty array to store information about executed scripts
$executedScripts = @()

# Get all PowerShell script files in the specified directory and its subdirectories
$scriptFiles = Get-ChildItem -Path $rootDirectory -File -Recurse -Filter *.ps1

# Loop through each script file and execute it
foreach ($scriptFile in $scriptFiles) {
    # Check if the file is a PowerShell script and its name is not "NTUSER_Parse.ps1"
    if ($scriptFile.Extension -eq '.ps1' -and $scriptFile.Name -ne 'NTUSER_Live_Parse.ps1') {
        Write-Host "Executing script: $($scriptFile.FullName)"
        
        # Execute the script
        try {
            & "$($scriptFile.FullName)"
            Write-Host "Script execution completed successfully."
            
            # Add information about executed script to the array
            $executedScripts += [PSCustomObject]@{
                ScriptName = $scriptFile.Name
                Status = "Executed successfully"
            }
        }
        catch {
            Write-Host "Script execution failed: $_"
            
            # Add information about failed script to the array
            $executedScripts += [PSCustomObject]@{
                ScriptName = $scriptFile.Name
                Status = "Execution failed: $_"
            }
        }
    }
}

# Export the executed scripts information to a CSV file
$executedScripts | Export-Csv -Path $logFilePath -NoTypeInformation

# Display a message indicating where the log file was saved
Write-Host "Script log saved to: $logFilePath"

# Exit PowerShell
Exit
