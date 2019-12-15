#!/usr/bin/perl

use strict;
use warnings;

use IPC::Open3;

my $pid = open3(\*C_IN, \*C_OUT, \*C_ERR, "./run-program-15 15.in")
    or die "open3: $!\n";

my %map;
my ($x, $y) = (0, 0);

my ($oxx, $oxy) = (0,0);

$map{"0,0"} = 'D';

my @xdir = (0, 0, 1, -1);
my @ydir = (-1, 1, 0, 0);
my @inv = (1, 0, 3, 2);

dfs();
draw();
shortestpath();

sub shortestpath {
    my %visited;
    my @q = ([$oxx,$oxy,0]);

    my $longest = 0;

    $visited{"$oxx,$oxy"} = 1;
    while (@q) {
        my $node = pop @q;
        my ($x, $y, $len) = @$node;

        for my $d (0..3) {
            my $newx = $x + $xdir[$d];
            my $newy = $y + $ydir[$d];
            next if $map{"$newx,$newy"} eq '#';
            next if $visited{"$newx,$newy"};
            $visited{"$newx,$newy"} = 1;
            push @q, [$newx,$newy,$len+1];
            $longest = $len+1 if $len+1 > $longest;
        }
    }

    print "$longest\n";
}

sub dfs {
    for my $d (0..3) {
        my $newx = $x + $xdir[$d];
        my $newy = $y + $ydir[$d];
        next if $map{"$newx,$newy"};
        print C_IN "" . ($d+1) . "\n";
        my $r = <C_OUT>;
        chomp $r;
        if ($r == 0) {
            $map{"$newx,$newy"} = '#';
        } else {
            $map{"$newx,$newy"} = ($r == 1 ? '.' : 'O');
            ($oxx,$oxy)=($newx,$newy) if $r==2;
            ($x,$y) = ($newx,$newy);
            dfs();
            $x -= $xdir[$d];
            $y -= $ydir[$d];
            print C_IN "" . ($inv[$d]+1) . "\n";
            $r = <C_OUT>;
        }
    }
}

sub draw {
    my ($minx,$miny,$maxx,$maxy) = (0,0,0,0);
    for my $k (keys %map) {
        my ($x,$y) = split /,/, $k;
        $minx = $x if $x < $minx;
        $miny = $y if $y < $miny;
        $maxx = $x if $x > $maxx;
        $maxy = $y if $y > $maxy;
    }

    for my $y ($miny..$maxy) {
        for my $x ($minx..$maxx) {
            print $map{"$x,$y"}//' ';
        }
        print "\n";
    }
}
