# Define destination folder on Desktop
$destinationFolder = "$home\Desktop\CLaPT_OutPut\MemoryLogs\CrashDMP\"

# Check if destination folder exists
if (!(Test-Path $destinationFolder)) 
{
  # Create folder if it doesn't exist
  New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

# Get current date and time for filename
$currentTime = Get-Date -Format "yyyyMMdd_HHmmss"

# Construct destination filename with timestamp
$destinationFile = Join-Path $destinationFolder -ChildPath "MEMORY_$currentTime.dmp"

# Check if source file (C:\Windows\MEMORY.DMP) exists
if (Test-Path "C:\Windows\MEMORY.DMP") 
{
  # Copy the file using Copy-Item with -Force parameter to overwrite existing files
  Copy-Item -Path "C:\Windows\MEMORY.DMP" -Destination $destinationFile -Force
  Write-Host "Successfully copied MEMORY.DMP to: $destinationFile"
} 

else 
{
  Write-Warning "MEMORY.DMP not found in C:\Windows\"
}