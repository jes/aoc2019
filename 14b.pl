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

my $min = 0;
my $max = 210000000;

my $onetrill = 1_000_000_000_000;

while ($min < $max) {
    my $mid = int(($min+$max)/2);
    %spare = ();
    my $o = ore_required($mid, 'FUEL');
    if ($o > $onetrill) {
        $max = $mid - 1;
    } elsif ($o < $onetrill) {
        $min = $mid+1;
    } else {
        print "$mid\n";
    }
}

print "$min,$max\n";

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
    }

    $spare{$type} = $needfor{$type}{count}*$want_generate - $count;

    return $ore;
}
