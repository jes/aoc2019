#!/usr/bin/perl

use strict;
use warnings;

my $input = <>;
chomp $input;

my @pattern = (0, 1, 0, -1);

for my $i (1..100) {
    $input = fftphase($input);
    print "$input\n";
}
print "$input\n";

sub fftphase {
    my ($in) = @_;

    my @input = split //, $in;
    my @output;

    for my $d (1..@input) {
        my $patternidx = 1;
        my $out = 0;
        for my $c (@input) {
            my $o = $c*$pattern[$patternidx/$d];
            print "$c * $pattern[$patternidx/$d] = $o\n";
            $out += $o;

            $patternidx++;
            $patternidx = 0 if $patternidx == 4*$d;
        }

        $out = -$out if $out < 0;
        push @output, $out%10;
        print "\n\n";
    }

    return join('', @output);
}
