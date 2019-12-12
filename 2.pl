#!/usr/bin/perl

use strict;
use warnings;

my $in = join('', <>);
my @mem = split /,/, $in;

push @mem, (0)x100000;

$mem[1] = 12;
$mem[2] = 2;

my $pc = 0;

while (1) {
    my $op = $mem[$pc];

    if ($op == 1) {
        my $a = $mem[$mem[$pc+1]];
        my $b = $mem[$mem[$pc+2]];
        $mem[$mem[$pc+3]] = $a + $b;
        $pc += 4;
    } elsif ($op == 2) {
        my $a = $mem[$mem[$pc+1]];
        my $b = $mem[$mem[$pc+2]];
        $mem[$mem[$pc+3]] = $a * $b;
        $pc += 4;
    } elsif ($op == 99) {
        last;
    } else {
        die "unexpected op! pc=$pc, op=$op\n";
    }
}

print "$mem[0]\n";
