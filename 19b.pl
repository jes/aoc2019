#!/usr/bin/perl

use strict;
use warnings;

use IPC::Open3;

my %map;

my $c = 0;

my ($x,$y) = (1278,1525); # derived by hand by approximating the gradient of the left and right edges of the beam
my ($lastx, $lasty) = (0,0);

while ($lastx != $x || $lasty != $y) {
    ($lastx,$lasty) = ($x,$y);

    # shift the square left and right at different angles until we reach
    # a place where it can't be shifted any more
    for my $dx (0..10) {
        for my $dy (0..10) {
            next if $dx*$dy == 0;
            while (lookup($x, $y+99) == 1 && lookup($x+99,$y) == 1) {
                $x -= $dx; $y -= $dy;
            }
            $x += $dx; $y += $dy;
        }
    }
}

print "($x,$y)\n";
print "" . ($x*10000 + $y) . "\n";

sub lookup {
    my ($x, $y) = @_;

    my $pid = open3(\*C_IN, \*C_OUT, \*C_ERR, "./run-program-15 19.in")
        or die "open3: $!\n";
    print C_IN "$x\n$y\n";
    my $out = <C_OUT>;
    chomp $out;
    return $out;
}
