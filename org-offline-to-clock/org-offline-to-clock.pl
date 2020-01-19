#!/usr/bin/perl -w
# org-offline-to-clock: convert clock log notes taken offline to Org-mode syntax

# © Christoph Lange <math.semantic.web@gmail.com> 2017–

# Download and licensing information available at https://github.com/clange/scripts

use strict;
use warnings;
use List::MoreUtils qw(firstidx);
use POSIX qw(mktime strftime);

# variables
my ($nl, $year, $weekday, $weekday_strftime, $day, $month, @timestamp, $from_str, $to_str, $from, $to, $diff, $diff_minutes, @clocks);

# "Vocabulary" of date representations
my $DAY_RE = "Mon|Tue|Wed|Thu|Fri|Sat|Sun";
my @MONTHS = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my $MONTHS_RE = join "|", @MONTHS;

while (<>) {
    if (/^([0-9]{4})\s*(\r?)$/) {
        # start of a "year" block
        # conversion into Perl's year format
        $year = $1 - 1900;
        $nl = "$2\n";
        print;
    } elsif (/^(${DAY_RE}) ([0-9]{1,2}) (${MONTHS_RE})\s*\r?$/) {
        # start of a "day" block
        # collect matched substrings
        $weekday = $1;
        $day = $2;
        $month = (firstidx { $_ eq $3 } @MONTHS);
        @timestamp = localtime(mktime(0, 0, 0, $day, $month, $year));
        # check week day for consistency
        $weekday_strftime = strftime('%a', @timestamp);
        if ($1 ne $weekday_strftime) {
            printf STDERR "$2 $3: Noted week day (%s) is different from actual week day of date (%s); using the latter.\n", $1, $weekday_strftime;
            exit;
        }
        # output heading for this day
        printf("* [%s]$nl", strftime('%Y-%m-%d %a', @timestamp));
    } elsif (/^\* \[([0-9]{4})-([0-9]{2})-([0-9]{2}) (${DAY_RE})\]$/) {
        # start of an Org node that has already been generated by a previous round of processing (but that might contain unprocessed clock logs)
        print;
        chomp;
        if (($1 - 1900) ne $year) {
            print STDERR "In $_: expected year @{[ $year + 1900 ]}, found $1 – please reorder entries.\n";
            exit;
        } else {
            $day = $3;
            $month = $2 - 1;
        }
    } elsif (/^(.*?) ((?:[0-9]{1,2}:[0-9]{2}-(?:[0-9]{1,2}:)?[0-9]{2}, ?)+)$/) {
        # an event with clock logs
        # open LOGBOOK drawer
        printf "** %s$nl   :LOGBOOK:$nl", $1;
        # split multiple log intervals
        @clocks = split /, ?/, $2;
        foreach (reverse @clocks) {
            # for each interval (most recent first)
            if (/([0-9]{1,2}):([0-9]{2})-(?:([0-9]{1,2}):)?([0-9]{2})/) {
                # notation: HH:MM-HH:MM, or shorthand HH:MM-MM (same hour)
                $from = mktime(0, $2, $1, $day, $month, $year);
                $to = mktime(0, $4, $3 // $1, $day, $month, $year);
                # if end is less than start then we assume it's on the next day
                if ($to < $from) {
                    $to += 60 * 60 * 24;
                }
                $diff = $to - $from;
                $diff_minutes = $diff / 60;
                $from_str = strftime('%Y-%m-%d %a %H:%M', localtime($from));
                $to_str = strftime('%Y-%m-%d %a %H:%M', localtime($to));
                printf("   CLOCK: [%s]--[%s] => %2d:%02d$nl", $from_str, $to_str, $diff_minutes / 60, $diff_minutes % 60);
            }
        }
        # close LOGBOOK drawer
        print "   :END:$nl";
    } else {
        # any other line
        print;
    }
}
