#!/usr/bin/perl

use strict;
use warnings;

my $in = join('', <>);
my @mem = split /,/, $in;

push @mem, (0)x100000;

my $pc = 0;

while (1) {
    my $op = $mem[$pc]%100;
    my $modea = int(($mem[$pc]%1000)/100);
    my $modeb = int(($mem[$pc]%10000)/1000);
    my $modec = int(($mem[$pc]%100000)/10000);

    if ($op == 1) { # add
        my $a = param($modea, $mem[$pc+1]);
        my $b = param($modeb, $mem[$pc+2]);
        $mem[$mem[$pc+3]] = $a + $b;
        $pc += 4;
    } elsif ($op == 2) { # mul
        my $a = param($modea, $mem[$pc+1]);
        my $b = param($modeb, $mem[$pc+2]);
        $mem[$mem[$pc+3]] = $a * $b;
        $pc += 4;
    } elsif ($op == 3) { # inp
        $mem[$mem[$pc+1]] = input();
        $pc += 2;
    } elsif ($op == 4) { # outp
        my $a = param($modea, $mem[$pc+1]);
        output($a);
        $pc += 2;
    } elsif ($op == 99) { # halt
        last;
    } else {
        die "unexpected op! pc=$pc, op=$op\n";
    }
}

sub param {
    my ($mode, $n) = @_;

    if ($mode == 0) {
        return $mem[$n];
    } elsif ($mode == 1) {
        return $n;
    } else {
        die "unknown mode: $mode\n";
    }
}

sub input {
    return 1;
}

sub output {
    my ($n) = @_;
    print "$n\n";
}
