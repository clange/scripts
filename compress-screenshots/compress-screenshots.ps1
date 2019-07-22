# compress-screenshots.ps1: runs optipng (http://optipng.sourceforge.net) to compress all screenshots upon creation

# © Christoph Lange <math.semantic.web@gmail.com> 2015–2019

# Download and licensing information available at https://github.com/clange/scripts

# Source: http://superuser.com/questions/226828/how-to-monitor-a-folder-and-trigger-a-command-line-action-when-a-file-is-created

param ( [switch] $Install = $false )

# install in startup folder
if ($Install) {
    . '..\lib\install-in-startup.ps1'
    installInStartup
    exit
}

$screenshotDir = "$env:USERPROFILE\Pictures\Screenshots"
Set-Location $screenshotDir

# set up the watcher
$watcherProps = @{
    Path = $screenshotDir
    Filter = '*.png'
    IncludeSubdirectories = $true
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
    EnableRaisingEvents = $true
}
$watcher = New-Object IO.FileSystemWatcher -Property $watcherProps

# set up the event handler
$compressAction = {
    $name = $Event.SourceEventArgs.Name
    $sizeBefore = (Get-Item $name).Length / 1024
    # compress the image
    & optipng -o5 $name
    $sizeAfter = (Get-Item $name).Length / 1024
    # display notification
    Add-Type -AssemblyName System.Windows.Forms 
    $global:balloon = New-Object System.Windows.Forms.NotifyIcon
    $shellPath = (Get-Process -id $pid).Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($shellPath)
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info 
    $balloon.BalloonTipText = "Screenshot {0} reduced from {1:N2} KiB to {2:N2} KiB" -f $name, $sizeBefore, $sizeAfter
    $balloon.BalloonTipTitle = 'Compressed Screenshot'
    $balloon.Visible = $true 
    $balloon.ShowBalloonTip(5000)
}

# register the event handler
$created = Register-ObjectEvent -InputObject $watcher -EventName 'Created' -Action $compressAction
$changed = Register-ObjectEvent -InputObject $watcher -EventName 'Changed' -Action $compressAction

# unregister the event handler when the shell is terminated
trap {
    if ($changed) { Unregister-Event $changed.Id }
    if ($created) { Unregister-Event $created.Id }
}
