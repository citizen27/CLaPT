# Specify the directory containing ETL files
$etlDirectory = "C:\Windows\Panther\"

# Specify the output directory for CSV files
$outputDirectory = "$home\Desktop\CLaPT_Output\Panther\Panther_ETL_Logs\"

# Ensure the output directory exists; create it if it doesn't
if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Set the working directory to the ETL directory
Set-Location -Path $etlDirectory

# Get a list of ETL files in the specified directory
$etlFiles = Get-ChildItem -Path . -Filter *.etl

# Loop through each ETL file and convert it to CSV
foreach ($etlFile in $etlFiles) {
    # Define the name for the CSV output file
    $csvFileName = [System.IO.Path]::ChangeExtension($etlFile.Name, "csv")
    $csvFilePath = Join-Path -Path $outputDirectory -ChildPath $csvFileName

    # Use tracerpt to convert the ETL file to CSV
    try {
        $process = Start-Process -FilePath "tracerpt.exe" -ArgumentList "`"$etlFile`" /o `"$csvFilePath`" /of CSV" -Wait -NoNewWindow -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Host "ETL file '$etlFile' successfully converted to CSV and saved as '$csvFilePath'."
        } else {
            Write-Error "Error converting ETL file '$etlFile' to CSV. Tracerpt exited with code $($process.ExitCode)."
        }
    } catch {
        Write-Error "Error running tracerpt.exe: $_"
    }
}
