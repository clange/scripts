#!/usr/bin/env pwsh

# create-outlook-appointment.ps1: create an Outlook appointment

# Usage: .\create-outlook-appointment.ps1 -Subject "Team Meeting" -StartTime "2024-12-05T10:00" -Duration "02:00" -BusyStatus "Tentative"

# © Christoph Lange <math.semantic.web@gmail.com> 2024–

# Download and licensing information available at https://github.com/clange/scripts

param (
    [string]$Subject = "",
    [string]$StartTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm"),
    [string]$Duration = "", # formatted like HH:mm
    [string]$EndTime = "",
    [ValidateSet("Busy", "Free", "Tentative", "OutOfOffice")]
    [string]$BusyStatus = "Busy",
    [string]$RequiredAttendees = "",
    [string]$OptionalAttendees = ""
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
$TodayString = (Get-Date).ToString("yyyy-MM-dd")
if ($StartTime -match "^\d{2}:\d{2}$") {
    $StartTime = "${TodayString}T${StartTime}"
}
if ($EndTime -match "^\d{2}:\d{2}$") {
    $EndTime = "${TodayString}T${EndTime}"
}
$StartDateTime = ParseDateTime $StartTime @("yyyy-MM-dd", "yyyy-MM-ddTHH:mm")

if ($StartTime -match "^\d{4}-\d{2}-\d{2}$") {
    if ($EndTime -eq "" -and $Duration -eq "") {
        # All-day event for one day
        $EndDateTime = $StartDateTime.AddDays(1)
        $AllDayEvent = $true
    } elseif ($EndTime -match "^\d{4}-\d{2}-\d{2}$") {
        # All-day event from StartTime to EndTime
        $EndDateTime = (ParseDateTime $EndTime @("yyyy-MM-dd")).AddDays(1)
        $AllDayEvent = $true
    } else {
        Write-Error "Invalid combination of StartTime and EndTime."
        exit 1
    }
} elseif ($StartTime -match "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$") {
    if ($EndTime -ne "") {
        if ($EndTime -match "^\d{2}:\d{2}$") {
           $EndTime = "$( $StartDateTime.ToString("yyyy-MM-dd") )T${EndTime}"
        }
        $EndDateTime = ParseDateTime $EndTime @("yyyy-MM-ddTHH:mm")
    } else {
        if ($Duration -eq "") {
            # Default duration 1 hour if neither duration nor end time specified
            $Duration = "1:00"            
        }
        $DurationTimeSpan = [timespan]::Parse($Duration)
        $EndDateTime = $StartDateTime.Add($DurationTimeSpan)
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
$Appointment.BusyStatus = [Microsoft.Office.Interop.Outlook.OlBusyStatus]::"ol${BusyStatus}"
$Appointment.RequiredAttendees = $RequiredAttendees
$Appointment.OptionalAttendees = $OptionalAttendees 

# Display the appointment for further editing
$Appointment.Display($true)

# Bring the Outlook window to the front
$Shell = New-Object -ComObject WScript.Shell
$Shell.AppActivate("Microsoft Outlook")
