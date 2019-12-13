#!/usr/bin/perl

use strict;
use warnings;

my %map;
my $maxx = 0;
my $maxy = 0;

my $y = 0;

my $pi = 3.14159265358979323846264338350288;

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

my ($bx, $by) = (22,19);

my %visibles;

examine_visible_asteroids($bx, $by);

for my $angle (keys %visibles) {
    $visibles{$angle} = [ sort { dist(@$a) <=> dist(@$b) } @{ $visibles{$angle} } ];
}

vapourise_asteroids();

sub examine_visible_asteroids {
    my ($ox, $oy) = @_;

    my %seen;
    my $c = 0;

    for my $x (0 .. $maxx) {
        for my $y (0 .. $maxy) {
            next if $map{"$x,$y"} ne '#';
            next if "$x,$y" eq "$ox,$oy";

            my $xoff = $ox - $x;
            my $yoff = $oy - $y;
            my $angle = atan2($yoff, $xoff) - $pi/2;
            $angle += 2*$pi while ($angle < 0);
            $angle = sprintf("%.16f", $angle);
            push @{ $visibles{$angle} }, [$x,$y];
        }
    }
}

sub dist {
    my ($x, $y) = @_;

    $x -= $bx;
    $y -= $by;
    return sqrt($x*$x + $y*$y);
}

sub vapourise_asteroids {
    my $done = 0;
    my $doneany = 1;

    while ($doneany) {
        $doneany = 0;
        for my $angle (sort keys %visibles) {
            my $ast = shift @{ $visibles{$angle} };
            delete $visibles{$angle} if !@{ $visibles{$angle} };
            #print "Vapourised at " . join(',', @$ast) . "\n";
            $done++;
            $doneany = 1;
            if ($done == 200) {
                my ($x, $y) = @$ast;
                print "" . (100*$x+$y) . "\n";
            }
        }
    }
}
