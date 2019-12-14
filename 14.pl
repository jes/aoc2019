#!/usr/bin/perl

use strict;
use warnings;

use POSIX;

my %needfor;
my %spare;

while (<>) {
    chomp;
    my ($ins,$out) = split / => /;

    my @inparts_str = split /, /, $ins;
    my @inparts;
    for my $p (@inparts_str) {
        my ($n, $type) = split / /, $p;
        push @inparts, [$n, $type];
    }

    my ($n, $type) = split / /, $out;
    $needfor{$type} = {
        inputs => \@inparts,
        count => $n,
    };
}

print ore_required(1, 'FUEL'), "\n";

sub ore_required {
    my ($count, $type) = @_;

    if ($type eq 'ORE') {
        return $count;
    }

    if ($spare{$type} && $spare{$type} >= $count) {
        $spare{$type} -= $count;
        return 0;
    }

    my $ore = 0;

    $count -= $spare{$type}//0;
    my $want_generate = ceil($count / $needfor{$type}{count});

    for my $in (@{ $needfor{$type}{inputs} }) {
        my ($n, $intype) = @$in;
        my $o = ore_required($n*$want_generate, $intype);
        $ore += $o;
        print "Made " . ($want_generate*$n) . " $intype out of $o ORE\n";
    }

    $spare{$type} = $needfor{$type}{count}*$want_generate - $count;

    return $ore;
}
