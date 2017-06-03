# last-resume.ps1: output the times the system was most recently resumed from sleep

# © Christoph Lange <math.semantic.web@gmail.com> 2017–

# Download and licensing information available at https://github.com/clange/scripts

Get-WinEvent -LogName System `
  | Where { `
      ($_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' `
      -and $_.Message -eq 'The system has resumed from sleep.') `
    -or ($_.ProviderName -eq 'Microsoft-Windows-Power-Troubleshooter' `
      -and $_.Message -Match '^The system has returned from a low power state') } | `
  Select -First 10 -ExpandProperty TimeCreated
