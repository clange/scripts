# create-outlook-appointment.ps1: create an Outlook appointment

# © Christoph Lange <math.semantic.web@gmail.com> 2024–

# Download and licensing information available at https://github.com/clange/scripts

param (
    [string]$Subject = "",
    [string]$StartTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm"),
    [string]$Duration = "01:00", # formatted like HH:mm
    [string]$EndTime = ""
)

# Fail if both EndTime and Duration are specified
if ($EndTime -ne "" -and $Duration -ne "") {
    Write-Error "Specify either EndTime or Duration, not both."
    exit 1
}

# Convert the start time and to a DateTime object
$StartDateTime = [datetime]::ParseExact($StartTime, "yyyy-MM-ddTHH:mm", $null)

# Calculate the end time based on the provided EndTime or Duration
if ($EndTime -ne "") {
    if ($EndTime -match "^\d{2}:\d{2}$") {
        # EndTime is in HH:mm format, use the same date as StartTime
        $EndDateTime = [datetime]::ParseExact("$($StartDateTime.ToString('yyyy-MM-dd'))T$EndTime", "yyyy-MM-ddTHH:mm", $null)
    } else {
        # EndTime is in yyyy-MM-ddTHH:mm format
        $EndDateTime = [datetime]::ParseExact($EndTime, "yyyy-MM-ddTHH:mm", $null)
    }
    $DurationTimeSpan = $EndDateTime - $StartDateTime
} else {
    # Use Duration to calculate the end time
    $DurationTimeSpan = [timespan]::Parse($Duration)
    $EndDateTime = $StartDateTime.Add($DurationTimeSpan)
}

# Create a new Outlook application object
$Outlook = New-Object -ComObject Outlook.Application

# Create a new appointment item
$Appointment = $Outlook.CreateItem('olAppointmentItem')

# Set the appointment properties
$Appointment.Subject = $Subject
$Appointment.Start = $StartDateTime
$Appointment.End = $EndDateTime
# $Appointment.Duration = $DurationTimeSpan.TotalMinutes

# Display the appointment for further editing
$Appointment.Display($true)

# Bring the Outlook window to the front
$Shell = New-Object -ComObject WScript.Shell
$Shell.AppActivate("Microsoft Outlook")
