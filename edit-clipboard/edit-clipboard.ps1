# edit-clipboard.ps1: open the clipboard contents (as text) in an external editor

# © Christoph Lange <math.semantic.web@gmail.com> 2021–

# Download and licensing information available at https://github.com/clange/scripts

# Recommended usage:
# 1. create shortcut for C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -ExecutionPolicy Bypass -File C:\Path\To\edit-clipboard.ps1 in start menu or on desktop
# 2. assign shortcut key to that shortcut

# TODO: extend by creating a directory (https://stackoverflow.com/a/34559554/2397768) and giving the file a customizable name (e.g., to enable the editor to identify the file type)
$tempFile = New-TemporaryFile
Get-Clipboard > $tempFile
# TODO: use $EDITOR or some other variable
Start-Process -FilePath "C:\Users\langebev\Program Files\emax64\bin\emacsclientw.exe" -ArgumentList $tempFile -Wait
Get-Content $tempFile | Set-Clipboard
Remove-Item -Path $tempFile
