# installInStartup: installs the script from which it is sourced in the user's startup folder.

# This type of setup is intended for scripts that run forever, waiting for certain events to occur.

# © Christoph Lange <math.semantic.web@gmail.com> 2015–

# Download and licensing information available at https://github.com/clange/scripts

function installInStartup() {
    # obtain full path of this script
    $path = $script:MyInvocation.MyCommand.Path
    $basename = $(Split-Path $path -Leaf)
    # obtain startup folder
    $startup = [Environment]::GetFolderPath('Startup')
    # create shell link to script in startup folder
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$startup\$basename.lnk")
    $Shortcut.TargetPath = 'powershell'
    $Shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -NoExit -NoLogo -WindowStyle Hidden -File `"$path`""
    $Shortcut.WindowStyle = 7 # Minimized
    $Shortcut.Save()
}
