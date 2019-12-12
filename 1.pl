#!/usr/bin/perl

use strict;
use warnings;

my $fuel = 0;

while (<>) {
    chomp;
    my $mass = $_;
    $fuel += int($mass / 3) - 2;
}

print "$fuel\n";
