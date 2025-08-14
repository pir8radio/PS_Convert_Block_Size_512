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

Write-Host "Scanning..."
$drives = & sg_scan

Write-Host "Drives detected:"
$drives -split "`n" | ForEach-Object { Write-Host $_ }

do {
    $driveId = Read-Host -Prompt "Enter the drive ID to format (e.g., pd1, pd2)"
    sg_readcap $driveId

    $confirmation = Read-Host -Prompt "WARNING: All data on $driveId will be erased. Type 'YES' to confirm or 'NO' to cancel"

    if ($confirmation -eq 'YES') {
        Write-Host "Formatting $driveId to 512 block size..."
        & sg_format --format --size=512 -v $driveId

        # Extract disk number from sg_scan ID (e.g., pd1 ? 1)
        $diskNum = $driveId -replace '[^\d]', ''

        # Set disk to not read-only
        Set-Disk -Number $diskNum -IsReadOnly $false

        # Initialize as GPT (optional if you want to use outside Storage Spaces)
        Initialize-Disk -Number $diskNum -PartitionStyle GPT

        # Convert to RAW if needed
        $diskInfo = Get-Disk -Number $diskNum
        if ($diskInfo.PartitionStyle -ne 'RAW') {
            Clear-Disk -Number $diskNum -RemoveData -Confirm:$false
            Write-Host "Disk $diskNum wiped and set to RAW."
        } else {
            Write-Host "Disk $diskNum is already RAW. Skipping wipe."
        }

        # Reset Storage Spaces metadata
        $physDisk = Get-PhysicalDisk | Where-Object { ($_.DeviceId -eq $diskNum) -and ($_.Usage -eq 'Auto-Select') }
        if ($physDisk) {
            try {
                Reset-PhysicalDisk -FriendlyName $physDisk.FriendlyName -ErrorAction Stop
                Write-Host "Metadata reset completed."
            } catch {
                Write-Host "Metadata reset skipped or not applicable: $($_.Exception.Message)"
            }
        }

        Write-Host "`nNOTE: $driveId should now show as "CanPool" and ready for windows pooling, or whatever you have in mind for it!" -ForegroundColor Yellow
    } else {
        Write-Host "Operation cancelled. $driveId was not formatted."
    }

    $repeat = Read-Host -Prompt "Would you like to format another drive? Type 'YES' to continue or 'NO' to exit"
} while ($repeat -eq 'YES')

Start-Sleep -Seconds 2
