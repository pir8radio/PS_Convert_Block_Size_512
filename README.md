A Windows PowerShell script designed to convert drives with unconventional block sizes, such as NetApp's 520-byte block size, to the standard 512-byte block size. This conversion enables the use of older JBOD-type RAID shelves with Windows and Windows Storage Pools.

This script will automatically install SG_Format (sg3_utils) if it is not already installed, scan for available drives, and list them. You can then select the drive you wish to convert, and the script will format the drive from its current block size to 512 bytes and initialize the disk as GPT.

Some disks perform quickly, while others take hours to complete. I am not entirely sure of the reason behind this, but it seems to be a common experience according to others online. If a disk starts off fast and then appears to be "stuck" at a certain percentage, it is advisable to let it run until it either completes or fails.

Download the PowerShell script, right-click and run it with PowerShell. You will probably need to run it as an administrator and agree to run scripts the first time you execute it. Good luck!

![image](https://github.com/user-attachments/assets/ef2a0b01-438f-47d8-9a5f-53d7602e8909)


# PS_Convert_Block_Size_512 Installation Guide

## Installation

The best way to **install** this script is by following these steps:

1. **Copy** the raw script from [this link](https://raw.githubusercontent.com/pir8radio/PS_Convert_Block_Size_512/refs/heads/main/PS_Convert_Block_Size_512.ps1).
2. **Create** a new text file on your PC.
3. **Paste** the script into the newly created text file.
4. **Rename** the text file to `PS_Convert_Block_Size_512.ps1`.

## Why This Method?

By creating this script locally, you avoid automatically running unknown scripts, enhancing security. Since you personally create the file, you can confidently approve its execution when prompted, ensuring your system stays secure.
