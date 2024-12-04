#!/usr/bin/env pwsh

# create-outlook-appointment.ps1: create an Outlook appointment

# © Christoph Lange <math.semantic.web@gmail.com> 2024–

# Download and licensing information available at https://github.com/clange/scripts

param (
    [string]$Subject = "",
    [string]$StartTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm"),
    [string]$Duration = "01:00", # formatted like HH:mm
    [string]$EndTime = ""
)

# Function to parse date and time
function ParseDateTime($dateString, $formats) {
    foreach ($format in $formats) {
        try {
            return [datetime]::ParseExact($dateString, $format, $null)
        } catch {
            continue
        }
    }
    Write-Error "Invalid date format: $dateString"
    exit 1
}

# Validate input parameters
if ($Duration -ne "" -and $EndTime -ne "") {
    Write-Error "Specify either EndTime or Duration, not both."
    exit 1
}

# Determine the type of event and set properties accordingly
$AllDayEvent = $false
$StartDateTime = ParseDateTime $StartTime @("yyyy-MM-dd", "yyyy-MM-ddTHH:mm")

if ($StartTime -match "^\d{4}-\d{2}-\d{2}$") {
    if ($EndTime -eq "" -and $Duration -eq "") {
        # All-day event for one day
        $EndDateTime = $StartDateTime.AddDays(1)
        $AllDayEvent = $true
    } elseif ($EndTime -match "^\d{4}-\d{2}-\d{2}$") {
        # All-day event from StartTime to EndTime
        $EndDateTime = ParseDateTime $EndTime @("yyyy-MM-dd").AddDays(1)
        $AllDayEvent = $true
    } else {
        Write-Error "Invalid combination of StartTime and EndTime."
        exit 1
    }
} elseif ($StartTime -match "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$") {
    if ($EndTime -ne "") {
        $EndDateTime = ParseDateTime $EndTime @("yyyy-MM-ddTHH:mm")
    } elseif ($Duration -ne "") {
        $DurationTimeSpan = [timespan]::Parse($Duration)
        $EndDateTime = $StartDateTime.Add($DurationTimeSpan)
    } else {
        Write-Error "Either EndTime or Duration must be specified."
        exit 1
    }
} else {
    Write-Error "Invalid StartTime format."
    exit 1
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
$Appointment.AllDayEvent = $AllDayEvent

# Display the appointment for further editing
$Appointment.Display($true)

# Bring the Outlook window to the front
$Shell = New-Object -ComObject WScript.Shell
$Shell.AppActivate("Microsoft Outlook")
