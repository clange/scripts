# last-resume.ps1: output the time the system was last resumed from sleep

# © Christoph Lange <math.semantic.web@gmail.com> 2017–

# Download and licensing information available at https://github.com/clange/scripts

Get-WinEvent -LogName System `
  | Where { `
    $_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' `
    -and $_.Message -eq 'The system has resumed from sleep.' } | `
  Select -First 1 -Property TimeCreated
