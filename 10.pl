#!/usr/bin/perl

use strict;
use warnings;

my %map;
my $maxx = 0;
my $maxy = 0;

my $y = 0;

while (<>) {
    chomp;
    my $x = 0;
    for my $c (split //) {
        $map{"$x,$y"} = $c;
        $maxx = $x if $x > $maxx;
        $x++;
    }
    $maxy = $y;
    $y++;
}

my $best = 0;
my ($bx, $by);

for my $y (0 .. $maxy) {
    for my $x (0 .. $maxx) {
        next if $map{"$x,$y"} ne '#';
        my $n = count_visible_asteroids($x,$y);
        if ($n > $best) {
            $best = $n;
            $bx = $x;
            $by = $y;
        }
    }
}

print "$best ($bx,$by)\n";

sub count_visible_asteroids {
    my ($ox, $oy) = @_;

    my %seen;
    my $c = 0;

    for my $x (0 .. $maxx) {
        for my $y (0 .. $maxy) {
            next if $map{"$x,$y"} ne '#';
            next if "$x,$y" eq "$ox,$oy";

            my $xoff = $ox - $x;
            my $yoff = $oy - $y;
            my $xsign = $xoff > 0 ? '+' : '-';
            my $angle = $yoff ? sprintf("%.16f", $xoff/$yoff) : 'xxx';
            my $hashkey = "$xsign;$angle";

            $c++ if !$seen{$hashkey};
            $seen{$hashkey} = 1;
        }
    }

    return $c;
}
