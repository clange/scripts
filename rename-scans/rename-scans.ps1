# rename-scans.ps1: sanitise the names of the output files of the Windows Scan app

# © Christoph Lange <math.semantic.web@gmail.com> 2017–

# Download and licensing information available at https://github.com/clange/scripts

param ( [switch] $Install = $false )

# install in startup folder
if ($Install) {
    . '..\lib\install-in-startup.ps1'
    installInStartup
    exit
}

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$scanDir = "$env:USERPROFILE\Pictures\Scans"

# set up the watcher for file (2)
$watcher2Props = @{
    Path = $scanDir
    Filter = 'Scan_???????? (2).png'
    IncludeSubdirectories = $true
    NotifyFilter = [IO.NotifyFilters]'FileName'
    EnableRaisingEvents = $true
}
$watcher2 = New-Object IO.FileSystemWatcher -Property $watcher2Props

# set up the watcher for file (10)
$watcher10Props = @{
    Path = $scanDir
    Filter = 'Scan_???????? (10).png'
    IncludeSubdirectories = $true
    NotifyFilter = [IO.NotifyFilters]'FileName'
    EnableRaisingEvents = $true
}
$watcher10 = New-Object IO.FileSystemWatcher -Property $watcher10Props

# set up the event handlers
$rename2Action = {
    $name2 = $Event.SourceEventArgs.Name
    $directory = (Get-Item $Event.SourceEventArgs.FullPath).Directory.FullName
    Set-Location $directory
    $name = $name2 -Replace " \(2\)\.png", ".png"
    $name1 = $name2 -Replace " \(2\)\.png", " (1).png"
    if (Test-Path $name) {
        if (-Not (Test-Path $name1)) {
            Rename-Item $name $name1
        } else {
            [System.Windows.Forms.MessageBox]::Show("${directory}: $name1 already exists.", "Warning")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("${directory}: $name2 exists but $name does not exist.", "Warning")
    }
}

$rename10Action = {
    $directory = (Get-Item $Event.SourceEventArgs.FullPath).Directory.FullName
    [System.Windows.Forms.MessageBox]::Show($directory)
    # TODO go to directory; prepend a leading 0 to every (#)
}

# register the event handlers
$created2 = Register-ObjectEvent -InputObject $watcher2 -EventName 'Created' -Action $rename2Action
$created10 = Register-ObjectEvent -InputObject $watcher10 -EventName 'Created' -Action $rename10Action

# unregister the event handler when the shell is terminated
trap {
    Unregister-Event $created2.Id
    Unregister-Event $created10.Id
}
