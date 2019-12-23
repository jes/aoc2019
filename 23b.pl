#!/usr/bin/perl

use strict;
use warnings;

$| = 1;

my $programfile = shift or die "usage: run-program PROGRAMFILE\n";

open(my $fh, '<', $programfile)
    or die "can't read $programfile: $!\n";
my $in = join('', <$fh>);
close $fh;

my @machine;
for my $i (0..49) {
    push @machine, {
        id => $i,
        mem => [split /,/, $in],
        pc => 0,
        relbase => 0,
        inqueue => [$i],
        outqueue => [],
        emptyrecv => 0,
    };
}

my $natpacket;
my $lastnaty = -1;

while (1) {
    tick($_) for @machine;

    my $nat = 1;
    for my $m (@machine) {
        $nat = 0 if @{ $m->{inqueue} } || $m->{emptyrecv} < 10;
    }
    if ($nat) {
        push @{ $machine[0]{inqueue} }, @$natpacket;
        if ($natpacket->[1] == $lastnaty) {
            print "$lastnaty\n";
            exit;
        }
        $lastnaty = $natpacket->[1];
    }
}

sub tick {
    my ($m) = @_;

    my $op = $m->{mem}[$m->{pc}]%100;
    my $modea = int(($m->{mem}[$m->{pc}]%1000)/100);
    my $modeb = int(($m->{mem}[$m->{pc}]%10000)/1000);
    my $modec = int(($m->{mem}[$m->{pc}]%100000)/10000);

    my $a = param($m, $modea, $m->{mem}[$m->{pc}+1]);
    my $b = param($m, $modeb, $m->{mem}[$m->{pc}+2]);

    if ($op == 1) { # add
        poke($m, $modec, $m->{mem}[$m->{pc}+3], $a+$b);
        $m->{pc} += 4;
    } elsif ($op == 2) { # mul
        poke($m, $modec, $m->{mem}[$m->{pc}+3], $a*$b);
        $m->{pc} += 4;
    } elsif ($op == 3) { # inp
        poke($m, $modea, $m->{mem}[$m->{pc}+1], input($m));
        $m->{pc} += 2;
    } elsif ($op == 4) { # outp
        output($m, $a);
        $m->{pc} += 2;
    } elsif ($op == 5) { # jump-if-true
        if ($a != 0) {
            $m->{pc} = $b;
        } else {
            $m->{pc} += 3;
        }
    } elsif ($op == 6) { # jump-if-false
        if ($a == 0) {
            $m->{pc} = $b;
        } else {
            $m->{pc} += 3;
        }
    } elsif ($op == 7) { # less than
        if ($a < $b) {
            poke($m, $modec, $m->{mem}[$m->{pc}+3], 1);
        } else {
            poke($m, $modec, $m->{mem}[$m->{pc}+3], 0);
        }
        $m->{pc} += 4;
    } elsif ($op == 8) { # equals
        if ($a == $b) {
            poke($m, $modec, $m->{mem}[$m->{pc}+3], 1);
        } else {
            poke($m, $modec, $m->{mem}[$m->{pc}+3], 0);
        }
        $m->{pc} += 4;
    } elsif ($op == 9) { # set relbase
        $m->{relbase} += $a;
        $m->{pc} += 2;
    } elsif ($op == 99) { # halt
        last;
    } else {
        die "unexpected op! id=$m->{id}, pc=$m->{pc}, op=$op\n";
    }
}

sub param {
    my ($m, $mode, $n) = @_;

    if ($mode == 0) { # position
        return $m->{mem}[$n];
    } elsif ($mode == 1) { # immediate
        return $n;
    } elsif ($mode == 2) { # relative
        return $m->{mem}[$n+$m->{relbase}];
    } else {
        die "unknown mode: $mode\n";
    }
}

sub poke {
    my ($m, $mode, $addr, $val) = @_;

    if ($mode == 0) { # position
        $m->{mem}[$addr] = $val;
    } elsif ($mode == 2) { # relative
        $m->{mem}[$m->{relbase}+$addr] = $val;
    } else {
        die "unknown writing mode: $mode\n";
    }
}

sub input {
    my ($m) = @_;
    if (@{ $m->{inqueue} }) {
        $m->{emptyrecv} = 0;
        return shift @{ $m->{inqueue} };
    } else {
        $m->{emptyrecv}++;
        return -1;
    }
}

sub output {
    my ($m, $n) = @_;
    push @{ $m->{outqueue} }, $n;
    if (@{ $m->{outqueue} } == 3) {
        my ($dest, $x, $y) = @{ $m->{outqueue} };
        $m->{outqueue} = [];
        if ($dest == 255) {
            $natpacket=[$x,$y];
        } else {
            push @{ $machine[$dest]{inqueue} }, ($x, $y);
        }
    }
}
