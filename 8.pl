#!/usr/bin/perl

use strict;
use warnings;

my $in = join('', <>);

my @layers;

while ($in =~ /(\d{150})/g) {
    push @layers, $1;
}

my $bestlayer = '';
my $numzeroes = 10000;

for my $l (@layers) {
    my $z = count_digit($l, 0);
    if ($z < $numzeroes) {
        $bestlayer = $l;
        $numzeroes = $z;
    }
}

my $ones = count_digit($bestlayer, 1);
my $twos = count_digit($bestlayer, 2);
my $n = $ones*$twos;
print "$n\n";

sub count_digit {
    my ($s, $n) = @_;

    return scalar grep { $_ == $n } split //, $s;
}
