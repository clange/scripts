#!/usr/bin/python
import csv
import sys
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

# Define CET timezone
cet = ZoneInfo("Europe/Berlin")

# Define appointment times for each Dienst type
dienst_times = {
    'F': ("06:00", "14:15"),
    'S': ("12:48", "21:00"),
    'N': ("20:20", "06:30")  # Ends next day
}

# VTIMEZONE component for Europe/Berlin
vtimezone_berlin = """
BEGIN:VTIMEZONE
TZID:Europe/Berlin
BEGIN:STANDARD
DTSTART:20241027T030000
RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
TZOFFSETFROM:+0200
TZOFFSETTO:+0100
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:20250330T020000
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
END:DAYLIGHT
END:VTIMEZONE
"""

# Function to generate iCalendar event with UID and correct TZID syntax
def generate_ical_event(start, end, uid):
    return f"""
BEGIN:VEVENT
UID:{uid}
DTSTART;TZID=Europe/Berlin:{start.strftime('%Y%m%dT%H%M%S')}
DTEND;TZID=Europe/Berlin:{end.strftime('%Y%m%dT%H%M%S')}
TRANSP:TRANSPARENT
END:VEVENT
"""

# Main function to read CSV and generate iCalendar entries
def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <csv_file>")
        return

    csv_file = sys.argv[1]

    print("BEGIN:VCALENDAR")
    print(vtimezone_berlin)
    with open(csv_file, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            date_str = row['Datum']
            dienst = row['Dienst']
            if dienst not in dienst_times:
                continue

            start_time_str, end_time_str = dienst_times[dienst]
            start_dt = datetime.strptime(f"{date_str} {start_time_str}", "%Y-%m-%d %H:%M").replace(tzinfo=cet)
            end_dt = datetime.strptime(f"{date_str} {end_time_str}", "%Y-%m-%d %H:%M").replace(tzinfo=cet)

            # If end time is earlier than start time, it means the event ends the next day
            if end_dt <= start_dt:
                end_dt += timedelta(days=1)

            print(generate_ical_event(start_dt, end_dt, uid=date_str))
    print("END:VCALENDAR")

# Run the main function
main()
