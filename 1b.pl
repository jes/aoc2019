#!/usr/bin/perl

use strict;
use warnings;

my $fuel = 0;

while (<>) {
    chomp;
    my $mass = $_;
    my $newfuel = int($mass / 3) - 2;

    my $totaladdmass = $newfuel;
    my $addmass = $newfuel;

    do {
        $addmass = int($addmass / 3) - 2;
        $addmass = 0 if $addmass < 0;
        $totaladdmass += $addmass;
    } while ($addmass > 0);

    $fuel += $totaladdmass;
}

print "$fuel\n";
