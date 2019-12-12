#!/usr/bin/perl

use strict;
use warnings;

my %edges;

while (<>) {
    chomp;
    my ($a,$b) = split /\)/;
    # $b directly orbits $a
    push @{ $edges{$a} }, $b;
    push @{ $edges{$b} }, $a;
}

print shortest_path('YOU', 'SAN') - 2;

sub shortest_path {
    my ($a, $b) = @_;

    my %visited;
    my @q = ([$a,0]);

    while (@q) {
        my ($node, $len) = @{ pop @q };
        return $len if $node eq $b;
        for my $nextnode (@{ $edges{$node} }) {
            next if $visited{$nextnode};
            push @q, [$nextnode, $len+1];
            $visited{$nextnode} = 1;
        }
    }

    die "didn't find route from $a to $b\n";
}
