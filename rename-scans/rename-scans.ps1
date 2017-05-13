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

# set up the watcher for file
$watcherProps = @{
    Path = $scanDir
    Filter = 'Scan_????????.png'
    IncludeSubdirectories = $true
    NotifyFilter = [IO.NotifyFilters]'FileName'
    EnableRaisingEvents = $true
}
$watcher = New-Object IO.FileSystemWatcher -Property $watcherProps

# set up the event handler:
# if (*) not present, rename to (1)
# else if (1)…(9) present, rename to (n+1)
$renameAction = {
    $name = $Event.SourceEventArgs.Name
    $directory = (Get-Item $Event.SourceEventArgs.FullPath).Directory.FullName
    Set-Location $directory
    $existing = Get-ChildItem "Scan_???????? (*).png" | Where-Object {$_.Name -Match "Scan_........ \([0-9]+\)\.png"}
    $maxIndex = 0
    # get all existing scan files with number suffixes
    if ($existing.Count -gt 0) {
        foreach ($file in $existing) {
            # extract the number suffix 
            $file -Match ' \(([0-9]+)\)\.png' | Out-Null
            [int]$index = [convert]::ToInt32($matches[1], 10)
            if ($index -gt $maxIndex) {
                $maxIndex = $index
            }
        }
    }
    $maxIndex++
    # string looks like 10+ ?
    # $l=[math]::log(1000)/[math]::log(10); $r=[int]$l; $rem=[math]::abs($l-$r); if ($rem -Lt [math]::pow(0.1,$r+1)) { "Exact power of" }
    Rename-Item $name ($name -Replace "\.png", " ($maxIndex).png")
    # [System.Windows.Forms.MessageBox]::Show("${directory}: $name1 already exists.", "Warning")
}

# register the event handler
$created = Register-ObjectEvent -InputObject $watcher -EventName 'Created' -Action $renameAction

# unregister the event handler when the shell is terminated
trap {
    Unregister-Event $created.Id
}
