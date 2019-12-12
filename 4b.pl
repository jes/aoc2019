#!/usr/bin/perl

use strict;
use warnings;

my $start = 353096;
my $end = 843212;

my $count = 0;

for my $i ($start..$end) {
    $count++ if ok($i) && new_ok($i);
}

print "$count\n";

sub ok {
    my ($n) = @_;

    my @c = split //, $n;
    return 0 if $c[0] != $c[1] && $c[1] != $c[2] && $c[2] != $c[3] && $c[3] != $c[4] && $c[4] != $c[5];
    return 0 if $c[1] < $c[0] || $c[2] < $c[1] || $c[3] < $c[2] || $c[4] < $c[3] || $c[5] < $c[4];
    return 1;
}

# return 1 if $n has a group of 2 adjacent like digits that are not a part of 3 adjacent like digits
# 0 otherwise
sub new_ok {
    my ($n) = @_;

    while ($n =~ /(0+|1+|2+|3+|4+|5+|6+|7+|8+|9+)/g) {
        return 1 if length($1) == 2;
    }

    return 0;
}
