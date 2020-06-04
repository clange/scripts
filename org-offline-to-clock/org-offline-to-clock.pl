#!/usr/bin/perl -w
# org-offline-to-clock: convert clock log notes taken offline to Org-mode syntax

# © Christoph Lange <math.semantic.web@gmail.com> 2017–

# Download and licensing information available at https://github.com/clange/scripts

use strict;
use warnings;
use List::MoreUtils qw(firstidx);
use POSIX qw(mktime strftime);
use Getopt::Long qw(GetOptions);
use Pod::Usage qw(pod2usage);

# parse command line options; determine grouping
my $help = 0;
GetOptions(
    'group-by=s' => \(my $group_by = 'name'),
    'help' => \$help
) or pod2usage(2);
pod2usage(2) if ($group_by !~ m/name|date/);
pod2usage(1) if $help;

# variables
my ($nl, $NODE, $END, $year, $weekday, $weekday_strftime, $day, $month, @timestamp, $from_str, $to_str, $from, $to, $diff, $diff_minutes, $name, @clocks, $clock);
my %names;

# "Vocabulary" of date representations
my $DAY_RE = "Mon|Tue|Wed|Thu|Fri|Sat|Sun";
my @MONTHS = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my $MONTHS_RE = join "|", @MONTHS;

while (<>) {
    if (/^([0-9]{4})\s*(\r?)$/) {
        # start of a "year" block
        # Example: 2020
        # conversion into Perl's year format
        $year = $1 - 1900;
        $nl = "$2\n";
        # initialize output templates
        $NODE = "** %s$nl   :LOGBOOK:$nl";
        $END = "   :END:$nl";
        print
    } elsif (/^(${DAY_RE}) ([0-9]{1,2}) (${MONTHS_RE})\s*\r?$/) {
        # start of a "day" block
        # Example: Thu 4 Jun
        # collect matched substrings
        $weekday = $1;
        $day = $2;
        $month = (firstidx { $_ eq $3 } @MONTHS);
        @timestamp = localtime(mktime(0, 0, 0, $day, $month, $year));
        # check week day for consistency
        $weekday_strftime = strftime('%a', @timestamp);
        if ($1 ne $weekday_strftime) {
            printf STDERR "$2 $3 %d: Noted week day (%s) is different from actual week day of date (%s); using the latter.\n", $year + 1900, $1, $weekday_strftime;
            exit;
        }
        # output heading for this day
        # also need to do this when grouping by name, as otherwise non-clock logs would lose their context in the output
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
        # Example: Perl coding 13:45-49, 23:59-0:15,
        $name = $1;
        if ($group_by eq 'date') {
            # start entry; open LOGBOOK drawer
            printf $NODE, $name;
        }
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
                $clock = sprintf("   CLOCK: [%s]--[%s] => %2d:%02d$nl", $from_str, $to_str, $diff_minutes / 60, $diff_minutes % 60);
                if ($group_by eq 'date') {
                    print $clock;
                } elsif ($group_by eq 'name') {
                    push(@{ $names{$name} }, $clock);
                }
            }
        }
        if ($group_by eq 'date') {
            # close LOGBOOK drawer
            print $END
        }
    } else {
        # any other line
        print;
    }
}

END {
    return unless ($group_by eq 'name');
    
    print "* Grouped by name$nl";
    foreach $name (sort keys %names) {
        printf $NODE, $name;
        foreach $clock (@{ $names{$name} }) {
            print $clock;
        }
        print $END;
    }
}

__END__

=head1 SYNOPSIS

org-offline-to-clock [options] [file]

 Options:
   -g, --group-by=date|name  group output by date or name (default: name)
