# PS_Convert_Block_Size_512 Script

## Overview

A Windows PowerShell script designed to convert drives with unconventional block sizes, such as NetApp's 520-byte block size, to the standard 512-byte block size. This conversion enables the use of older JBOD-type RAID shelves with Windows and Windows Storage Pools.

## Features

- Automatically installs **SG_Format (sg3_utils)** if it is not already installed.
- Scans for available drives and lists them for selection.
- Converts the selected drive's block size to **512 bytes**.
- Initializes the disk as **GPT**.

## Notes

- **Performance**: Some drives convert quickly, while others may take hours. If a disk seems "stuck" at a certain percentage, allow it to run until it either completes or fails.
- **Execution**: You may need to run the script as an administrator and approve the execution of scripts the first time you use it.


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
