#!/usr/bin/perl

use strict;
use warnings;

my %orbiters;

while (<>) {
    chomp;
    my ($a,$b) = split /\)/;
    # $b directly orbits $a
    push @{ $orbiters{$a} }, $b;
}

print count_orbiters('COM', 1);

sub count_orbiters {
    my ($place, $k) = @_;
    my $c = 0;
    for my $i (@{ $orbiters{$place} }) {
        $c += $k + count_orbiters($i, $k+1);
    }
    return $c;
}
