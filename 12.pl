#!/usr/bin/perl

use strict;
use warnings;

my @positions;
my @velocities;

while (<>) {
    chomp;
    if (/<x=([-0-9]+), y=([-0-9]+), z=([-0-9]+)>/) {
        push @positions, [$1,$2,$3];
        push @velocities, [0,0,0];
    } else {
        die "don't recognise input: $_\n";
    }
}

for (1..1000) {
    tick();
}

print total_energy(), "\n";

sub tick {
    for my $a (0 .. $#positions-1) {
        my ($xa,$ya,$za) = @{ $positions[$a] };
        my ($vxa,$vya,$vza) = @{ $velocities[$a] };

        for my $b ($a+1 .. $#positions) {
            my ($xb,$yb,$zb) = @{ $positions[$b] };
            my ($vxb,$vyb,$vzb) = @{ $velocities[$b] };

            if ($xa > $xb) {
                $vxb++; $vxa--;
            } elsif ($xb > $xa) {
                $vxa++; $vxb--;
            }
            if ($ya > $yb) {
                $vyb++; $vya--;
            } elsif ($yb > $ya) {
                $vya++; $vyb--;
            }
            if ($za > $zb) {
                $vzb++; $vza--;
            } elsif ($zb > $za) {
                $vza++; $vzb--;
            }

            $velocities[$b] = [$vxb,$vyb,$vzb];
        }

        $velocities[$a] = [$vxa,$vya,$vza];
    }

    for my $i (0 .. $#positions) {
        my ($x,$y,$z) = @{ $positions[$i] };
        my ($vx,$vy,$vz) = @{ $velocities[$i] };
        $x += $vx; $y += $vy; $z += $vz;
        $positions[$i] = [ $x,$y,$z ];
    }
}

sub total_energy {
    my $e = 0;
    for my $i (0 .. $#positions) {
        my ($x,$y,$z) = @{ $positions[$i] };
        my ($vx,$vy,$vz) = @{ $velocities[$i] };
        my $this_e = abs($x) + abs($y) + abs($z);
        $this_e *= (abs($vx) + abs($vy) + abs($vz));
        $e += $this_e;
    }
    return $e;
}
