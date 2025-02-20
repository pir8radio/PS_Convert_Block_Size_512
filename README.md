A Windows PowerShell script designed to convert drives with unconventional block sizes, such as NetApp's 520-byte block size, to the standard 512-byte block size. This conversion enables the use of older JBOD-type RAID shelves with Windows and Windows Storage Pools.

This script will automatically install SG_Format (sg3_utils) if it is not already installed, scan for available drives, and list them. You can then select the drive you wish to convert, and the script will format the drive from its current block size to 512 bytes and initialize the disk.
