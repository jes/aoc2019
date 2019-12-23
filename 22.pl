#!/usr/bin/perl

use strict;
use warnings;

my $c = join('',<>);
my @steps = split /\n/, $c;

my @deck = (0..10006);

@deck = shuffle(@deck);
for my $i (0 .. $#deck) {
    print "$i\n" if $deck[$i] == 2019;
}

sub shuffle {
    my @deck = @_;

    my $N = @deck;

    for my $step (@steps) {
        if ($step =~ /deal into new stack/) {
            @deck = reverse @deck;
        } elsif ($step =~ /cut (-?\d+)/) {
            my $n = $1;
            $n = $N+$n if $n < 0;
            @deck = (@deck[$n .. $N-1], @deck[0 .. $n-1]);
        } elsif ($step =~ /deal with increment (\d+)/) {
            my $n = $1;
            my @new = ('x')x$N;
            my $pos = 0;
            for my $i (0..$N-1) {
                $new[$pos] = $deck[$i];
                $pos = ($pos + $n) % $N;
            }
            @deck = @new;
        } else {
            die "don't understand: $step\n";
        }
    }

    return @deck;
}
