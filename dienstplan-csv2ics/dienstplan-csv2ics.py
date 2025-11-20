#!/usr/bin/python
import csv
import re
import sys
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

# To use this with Excel, pipe the output of the following into this script:
# python -c "import sys, pandas as pd; pd.read_excel(sys.argv[1], sheet_name=0, engine='openpyxl').to_csv(sys.stdout, index=False)" input.xlsx | 

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
def generate_ical_event(start, end, organizer, uid):
    return f"""
BEGIN:VEVENT
UID:{uid}
SUMMARY:Dienst
DTSTART;TZID=Europe/Berlin:{start.strftime('%Y%m%dT%H%M%S')}
DTEND;TZID=Europe/Berlin:{end.strftime('%Y%m%dT%H%M%S')}
{organizer}
TRANSP:TRANSPARENT
END:VEVENT
"""

def format_organizer(input_str):
    match = re.match(r'^(.*?)\s*<([^>]+)>$', input_str.strip())
    if match:
        name = match.group(1).strip()
        email = match.group(2).strip()
        return f'ORGANIZER;CN="{name}":mailto:{email}'
    else:
        raise ValueError("Input string is not in the expected format.")

# Main function to read CSV and generate iCalendar entries
def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py 'Organizer Name <organizer@email.tld>'")
        return

    organizer = format_organizer(sys.argv[1])

    print("BEGIN:VCALENDAR")
    print(vtimezone_berlin)
    reader = csv.DictReader(sys.stdin)
    for row in reader:
        date_str = row['Datum']
        dienst = row['Dienst']

        if dienst in dienst_times:
            start_time_str, end_time_str = dienst_times[dienst]
        elif dienst.lower() in dienst_times:
            start_time_str, end_time_str = dienst_times[dienst.lower()]
        else:
            match = re.match(r'^(\d{2}:\d{2})-(\d{2}:\d{2})$', dienst)
            if match:
                start_time_str, end_time_str = match.groups()
            else:
                continue  # Skip invalid format
        
        start_dt = datetime.strptime(f"{date_str} {start_time_str}", "%Y-%m-%d %H:%M").replace(tzinfo=cet)
        end_dt = datetime.strptime(f"{date_str} {end_time_str}", "%Y-%m-%d %H:%M").replace(tzinfo=cet)

        # If end time is earlier than start time, it means the event ends the next day
        if end_dt <= start_dt:
            end_dt += timedelta(days=1)

        print(generate_ical_event(start_dt, end_dt, organizer, uid=date_str))
    print("END:VCALENDAR")

# Run the main function
main()
