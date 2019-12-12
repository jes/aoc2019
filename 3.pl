#!/usr/bin/perl

use strict;
use warnings;

my $line1 = <>;
my $line2 = <>;

my %visited;
my %othervisited;

chomp $line1;
chomp $line2;

interpret($line1);
%othervisited = %visited;
%visited = ();
interpret($line2);

my $mindist = 10000000000;
my @intersections;

for my $intersection (@intersections) {
    my ($x,$y) = @$intersection;
    my $dist = abs($x)+abs($y);
    $mindist = $dist if $dist < $mindist;
}

print "$mindist\n";

sub interpret {
    my ($in) = @_;
    my @steps = split /,/, $in;

    my $x = 0;
    my $y = 0;

    for my $step (@steps) {
        if ($step =~ /^(R|L|D|U)(\d+)$/) {
            my $dir = $1;
            my $dist = $2;

            my $xd = 0;
            my $yd = 0;

            if ($dir eq 'R') {
                $xd = 1;
            } elsif ($dir eq 'L') {
                $xd = -1;
            } elsif ($dir eq 'U') {
                $yd = -1;
            } elsif ($dir eq 'D') {
                $yd = 1;
            }

            for my $i (1..$dist) {
                $x += $xd;
                $y += $yd;
                if ($othervisited{"$x,$y"}) {
                    push @intersections, [$x,$y];
                }
                $visited{"$x,$y"} = 1;
            }

        } else {
            die "can't read: $step\n";
        }
    }
}
