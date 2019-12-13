#!/usr/bin/perl

use strict;
use warnings;

$| = 1;

my $programfile = shift or die "usage: run-program PROGRAMFILE\n";

open(my $fh, '<', $programfile)
    or die "can't read $programfile: $!\n";
my $in = join('', <$fh>);
close $fh;

my @mem = split /,/, $in;

push @mem, (0)x100000;

my $pc = 0;
my $relbase = 0;
my $x = 0;
my $y = 0;
my $outstate = 0;
my %paint;
my ($minx, $miny, $maxx, $maxy) = (0,0,0,0);

while (1) {
    my $op = $mem[$pc]%100;
    my $modea = int(($mem[$pc]%1000)/100);
    my $modeb = int(($mem[$pc]%10000)/1000);
    my $modec = int(($mem[$pc]%100000)/10000);

    my $a = param($modea, $mem[$pc+1]);
    my $b = param($modeb, $mem[$pc+2]);

    if ($op == 1) { # add
        poke($modec, $mem[$pc+3], $a+$b);
        $pc += 4;
    } elsif ($op == 2) { # mul
        poke($modec, $mem[$pc+3], $a*$b);
        $pc += 4;
    } elsif ($op == 3) { # inp
        poke($modea, $mem[$pc+1], input());
        $pc += 2;
    } elsif ($op == 4) { # outp
        output($a);
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
            poke($modec, $mem[$pc+3], 1);
        } else {
            poke($modec, $mem[$pc+3], 0);
        }
        $pc += 4;
    } elsif ($op == 8) { # equals
        if ($a == $b) {
            poke($modec, $mem[$pc+3], 1);
        } else {
            poke($modec, $mem[$pc+3], 0);
        }
        $pc += 4;
    } elsif ($op == 9) { # set relbase
        $relbase += $a;
        $pc += 2;
    } elsif ($op == 99) { # halt
        last;
    } else {
        die "unexpected op! pc=$pc, op=$op\n";
    }
}

my $count = 0;
for my $k (keys %paint) {
    $count++ if $paint{$k} == 2;
}
print "$count\n";


sub param {
    my ($mode, $n) = @_;

    if ($mode == 0) { # position
        return $mem[$n];
    } elsif ($mode == 1) { # immediate
        return $n;
    } elsif ($mode == 2) { # relative
        return $mem[$n+$relbase];
    } else {
        die "unknown mode: $mode\n";
    }
}

sub poke {
    my ($mode, $addr, $val) = @_;

    if ($mode == 0) { # position
        $mem[$addr] = $val;
    } elsif ($mode == 2) { # relative
        $mem[$relbase+$addr] = $val;
    } else {
        die "unknown writing mode: $mode\n";
    }
}

sub input {
    return $paint{"$x,$y"}//0;
}

sub output {
    my ($n) = @_;
    if ($outstate == 0) {
        $x = $n;
    } elsif ($outstate == 1) {
        $y = $n;
    } else {
        $paint{"$x,$y"} = $n;
    }
    $outstate = ($outstate+1)%3;
}
