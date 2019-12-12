#!/usr/bin/perl

use strict;
use warnings;

my $in = join('', <>);

my @layers;

while ($in =~ /(\d{150})/g) {
    push @layers, $1;
}

my @result;

for my $l (@layers) {
    my @c = split //, $l;
    if (!@result) {
        @result = @c;
    } else {
        for my $i (0 .. $#c) {
            $result[$i] = $c[$i] if $result[$i] == 2;
        }
    }
}

my $s = join('', @result);
while ($s =~ /(.{25})/g) {
    print "$1\n";
}
