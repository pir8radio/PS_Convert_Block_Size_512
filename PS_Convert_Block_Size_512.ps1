# Give me a star on github :-)
# https://github.com/pir8radio/PS_Convert_Block_Size_512

# Function to check if sg_format is installed
function Check-SGFormat {
    $sgFormatPath = Get-Command sg_format -ErrorAction SilentlyContinue
    return $sgFormatPath -ne $null
}

# Function to install sg_format
function Install-SGFormat {
    Write-Host "Installing sg_format..."
    if ($PSVersionTable.PSVersion.Major -ge 5) {
        # Use PowerShellGet to install sg_format on Windows if available
        Install-Package sg3_utils
    } else {
        Write-Host "Automatic installation is not supported on this version of PowerShell. Please install sg3_utils manually."
    }
}

# Check if sg_format is installed
if (-not (Check-SGFormat)) {
    Install-SGFormat
} else {
    Write-Host "sg_format is already installed."
}

# Display scanning message
Write-Host "Scanning..."

# Run sg_scan and store the output
$drives = & sg_scan

# Display the list of drives with each drive on a new line
Write-Host "Drives detected:"
$drives -split "`n" | ForEach-Object { Write-Host $_ }

# Prompt the user to enter the drive number they want to format
$driveNumber = Read-Host -Prompt "Enter the drive number you want to format (e.g., pd1, pd2)"

# Confirm with the user that the selected drive will be erased
$confirmation = Read-Host -Prompt "WARNING: All data on $driveNumber will be erased. Type 'YES' to confirm or 'NO' to cancel"

if ($confirmation -eq 'YES') {
    # Format the selected drive
    Write-Host "Formatting the drive $driveNumber..."
    & sg_format --format --size=512 -v $driveNumber

    # Confirm the process is complete
    Write-Host "Drive $driveNumber has been reformatted. Now removing read-only and initializing disk as GPT."

    # Set the disk to not read-only
    $disk = Get-Disk | Where-Object { $_.Number -eq $driveNumber.Substring(2) }
    Set-Disk -Number $disk.Number -IsReadOnly $false

    # Initialize the disk with GPT partition style
    Initialize-Disk -Number $disk.Number -PartitionStyle GPT

    Write-Host "`n"
    Write-Host "Drive $driveNumber has been initialized with a GPT partition style. The disk is now ready to use!"
    Write-Host "NOTE: You may need to physically pull and reseat the drive before it will be storage pool ready." -ForegroundColor Yellow
} else {
    # Cancel the operation
    Write-Host "Operation cancelled. $driveNumber was not formatted."
}

# To pause for a specific number of seconds
Start-Sleep -Seconds 5

# Wait for user to press any key to exit
Write-Host "`n"
Write-Host "`n"
Write-Host "Press any key to exit..."
$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
