# Specify the directory containing ETL files
$etlDirectory = "C:\Windows\System32\SleepStudy\"

# Specify the output directory for CSV files
$outputDirectory = "$home\Desktop\CLaPT_Output\SleepStudy"

# Ensure the output directory exists; create it if it doesn't
if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Check if the specified ETL directory exists
if (Test-Path -Path $etlDirectory) {
    # Get a list of ETL files in the specified directory and its subdirectories
    $etlFiles = Get-ChildItem -Path $etlDirectory -Filter *.etl -Recurse

    # Check if there are any ETL files in the directory
    if ($etlFiles.Count -gt 0) {
        # Loop through each ETL file and convert it to CSV
        foreach ($etlFile in $etlFiles) {
            # Define the name for the CSV output file
            $csvFileName = [System.IO.Path]::ChangeExtension($etlFile.Name, "csv")

            # Get the relative path of the ETL file from the SleepStudy directory
            $relativePath = $etlFile.FullName.Substring($etlDirectory.Length)
            
            # Construct the output directory based on the relative path
            $outputSubDirectory = Join-Path -Path $outputDirectory -ChildPath $relativePath | Split-Path -Parent

            # Ensure the output subdirectory exists; create it if it doesn't
            if (-not (Test-Path -Path $outputSubDirectory)) {
                New-Item -Path $outputSubDirectory -ItemType Directory
            }

            $csvFilePath = Join-Path -Path $outputSubDirectory -ChildPath $csvFileName

            # Use tracerpt to convert the ETL file to CSV
            try {
                $process = Start-Process -FilePath "tracerpt.exe" -ArgumentList "`"$($etlFile.FullName)`" /o `"$csvFilePath`" /of CSV" -Wait -NoNewWindow -PassThru
                if ($process.ExitCode -eq 0) {
                    Write-Host "ETL file '$($etlFile.FullName)' successfully converted to CSV and saved as '$csvFilePath'."
                } else {
                    Write-Error "Error converting ETL file '$($etlFile.FullName)' to CSV. Tracerpt exited with code $($process.ExitCode)."
                }
            } catch {
                Write-Error "Error running tracerpt.exe: $_"
            }
        }
    } else {
        Write-Warning "No ETL files found in the specified directory and its subdirectories: $etlDirectory"
    }
} else {
    Write-Error "Specified directory not found: $etlDirectory"
}
