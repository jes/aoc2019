#!/usr/bin/perl

use strict;
use warnings;

my $in = join('', <>);
my @initial_mem = split /,/, $in;

push @initial_mem, (0)x100000;

for my $noun (0..10000) {
for my $verb (0..$noun) {

my @mem = @initial_mem;

$mem[1] = $noun;
$mem[2] = $verb;

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

if ($mem[0] == 19690720) {
    print "$noun$verb\n";
    exit;
}

}
}
