# create-outlook-appointment.ps1: create an Outlook appointment

# © Christoph Lange <math.semantic.web@gmail.com> 2024–

# Download and licensing information available at https://github.com/clange/scripts

param (
    [string]$Subject = "",
    [string]$StartTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm"),
    [string]$Duration = "01:00" # formatted like HH:mm
)

# Convert the start time and duration to DateTime objects
$StartDateTime = [datetime]::ParseExact($StartTime, "yyyy-MM-ddTHH:mm", $null)
$DurationTimeSpan = [timespan]::Parse($Duration)

# Create a new Outlook application object
$Outlook = New-Object -ComObject Outlook.Application

# Create a new appointment item
$Appointment = $Outlook.CreateItem('olAppointmentItem')

# Set the appointment properties
$Appointment.Subject = $Subject
$Appointment.Start = $StartDateTime
$Appointment.Duration = $DurationTimeSpan.TotalMinutes

# Display the appointment for further editing
$Appointment.Display($true)