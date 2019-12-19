#!/usr/bin/perl

use strict;
use warnings;

use IPC::Open3;

my %map;

my $c = 0;

for my $y (0 .. 49) {
    for my $x (0 .. 49) {
        my $out = lookup($x,$y);
        $map{"$x,$y"} = $out;
        print "" . ($out ? '#' : '.');
        $c++ if $out;
    }
    print "\n";
}

print "$c\n";

sub lookup {
    my ($x, $y) = @_;

    my $pid = open3(\*C_IN, \*C_OUT, \*C_ERR, "./run-program-15 19.in")
        or die "open3: $!\n";
    print C_IN "$x\n$y\n";
    my $out = <C_OUT>;
    chomp $out;
    return $out;
}
