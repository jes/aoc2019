#!/usr/bin/perl

use strict;
use warnings;

use IPC::Open3;

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

    for my $i (5..9) {
        next if $used->{$i};
        $used->{$i} = 1;
        dfs($pos+1, $used, @order, $i);
        $used->{$i} = 0;
    }
}

sub run_amplifiers {
    my (@order) = @_;

    my $cmdline = join(' | ', map { "./run-program $_ 7.in" } @order);

    my $pid = open3(\*C_IN, \*C_OUT, \*C_ERR, $cmdline)
        or die "open3: $!\n";

    print C_IN "0\n";

    my $last_r;

    while (<C_OUT>) {
        print C_IN $_;
        $last_r = $_;
    }

    return $last_r;
}
