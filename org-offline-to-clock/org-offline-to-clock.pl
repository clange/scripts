#!/usr/bin/perl
# org-offline-to-clock: convert clock log notes taken offline to Org-mode syntax

# © Christoph Lange <math.semantic.web@gmail.com> 2017–

# Download and licensing information available at https://github.com/clange/scripts

use strict;
use warnings;
use v5.10;
use List::MoreUtils qw(firstidx);
use POSIX qw(mktime strftime);

my ($year, $weekday, $weekday_strftime, $day, $month, $from_str, $to_str, $from, $to, $diff, $diff_minutes, @clocks);
my @MONTHS = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

while (<>) {
    if (/^([0-9]{4})$/) {
        # start of a "year" block
        $year = $1;
        print;
    } elsif (/^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) ([0-9]{1,2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/) {
        # start of a "day" block
        # collect matched substrings
        $weekday = $1;
        $day = $2;
        $month = (firstidx { $_ eq $3 } @MONTHS);
        # check week day for consistency
        $weekday_strftime = strftime('%a', 0, 0, 0, $day, $month, $year - 1900);
        if ($1 ne $weekday_strftime) {
            printf STDERR "$day $3: Noted week day (%s) is different from actual week day of date (%s); using the latter.\n", $1, $weekday_strftime;
        }
        # output heading for this day
        printf("* [%s]\n", strftime('%Y-%m-%d %a', 0, 0, 0, $day, $month, $year - 1900));
    } elsif (/^(.*?) ((?:[0-9]{1,2}:[0-9]{2}-[0-9]{1,2}:[0-9]{2}, ?)+)/) {
        # an event with clock logs
        # open LOGBOOK drawer
        printf "** %s\n   :LOGBOOK:\n", $1;
        # split multiple log intervals
        @clocks = split /, ?/, $2;
        foreach (reverse @clocks) {
            # for each interval (most recent first)
            if (/([0-9]{1,2}):([0-9]{2})-([0-9]{1,2}):([0-9]{2})/) {
                $from = mktime(0, $2, $1, $day, $month, $year - 1900);
                $to = mktime(0, $4, $3, $day, $month, $year - 1900);
                $diff = $to - $from;
                # if end is less than start then we assume it's on the next day
                if ($diff < 0) { $diff += 60 * 60 * 24; }
                $diff_minutes = $diff / 60;
                $from_str = strftime('%Y-%m-%d %a %H:%M', 0, $2, $1, $day, $month, $year - 1900);
                $to_str = strftime('%Y-%m-%d %a %H:%M', 0, $4, $3, $day, $month, $year - 1900);
                printf("   CLOCK: [%s]--[%s] => %2d:%02d\n", $from_str, $to_str, $diff_minutes / 60, $diff_minutes % 60);
            }
        }
        # close LOGBOOK drawer
        print "   :END:\n";
    } else {
        # any other line
        print;
    }
}
