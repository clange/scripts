# compress-screenshots.ps1: runs optipng (http://optipng.sourceforge.net) to compress all screenshots upon creation

# © Christoph Lange <math.semantic.web@gmail.com> 2015–

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
}
$watcher = New-Object IO.FileSystemWatcher -Property $watcherProps

# set up the event handler
$compressAction = {
    $name = $Event.SourceEventArgs.Name
    optipng -o5 $name
}

# register the event handler
$created = Register-ObjectEvent -InputObject $watcher -EventName 'Created' -Action $compressAction
$changed = Register-ObjectEvent -InputObject $watcher -EventName 'Changed' -Action $compressAction

# unregister the event handler when the shell is terminated
trap {
    Unregister-Event $changed.Id
    Unregister-Event $created.Id
}
