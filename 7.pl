#!/usr/bin/perl

use strict;
use warnings;

my $in = join('', <>);
my @initial_mem = split /,/, $in;

my @mem;

my $best_signal = 0;

dfs(0, {});

print "$best_signal\n";

sub dfs {
    my ($pos, $used, @order) = @_;

    if ($pos == 5) {
        my $signal = run_amplifiers(@order);
        $best_signal = $signal if $signal > $best_signal;
        return;
    }

    for my $i (0..4) {
        next if $used->{$i};
        $used->{$i} = 1;
        dfs($pos+1, $used, @order, $i);
        $used->{$i} = 0;
    }
}

sub run_amplifiers {
    my (@order) = @_;

    my $last_out = 0;

    for my $i (@order) {
        ($last_out) = run_program(\@initial_mem, $i, $last_out);
    }

    return $last_out;
}

sub run_program {
    my ($memory, @inputs) = @_;

my @outputs;

@mem = @$memory;
push @mem, (0)x100000;

my $pc = 0;

while (1) {
    my $op = $mem[$pc]%100;
    my $modea = int(($mem[$pc]%1000)/100);
    my $modeb = int(($mem[$pc]%10000)/1000);
    my $modec = int(($mem[$pc]%100000)/10000);

    my $a = param($modea, $mem[$pc+1]);
    my $b = param($modeb, $mem[$pc+2]);

    if ($op == 1) { # add
        $mem[$mem[$pc+3]] = $a + $b;
        $pc += 4;
    } elsif ($op == 2) { # mul
        $mem[$mem[$pc+3]] = $a * $b;
        $pc += 4;
    } elsif ($op == 3) { # inp
        $mem[$mem[$pc+1]] = shift @inputs;
        $pc += 2;
    } elsif ($op == 4) { # outp
        push @outputs, $a;
        $pc += 2;
    } elsif ($op == 5) { # jump-if-true
        if ($a != 0) {
            $pc = $b;
        } else {
            $pc += 3;
        }
    } elsif ($op == 6) { # jump-if-false
        if ($a == 0) {
            $pc = $b;
        } else {
            $pc += 3;
        }
    } elsif ($op == 7) { # less than
        if ($a < $b) {
            $mem[$mem[$pc+3]] = 1;
        } else {
            $mem[$mem[$pc+3]] = 0;
        }
        $pc += 4;
    } elsif ($op == 8) { # equals
        if ($a == $b) {
            $mem[$mem[$pc+3]] = 1;
        } else {
            $mem[$mem[$pc+3]] = 0;
        }
        $pc += 4;
    } elsif ($op == 99) { # halt
        last;
    } else {
        die "unexpected op! pc=$pc, op=$op\n";
    }
}
    return @outputs;
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
