#!/usr/bin/perl

use strict;
use warnings;
no warnings 'uninitialized';

my %map;
my ($x, $y) = (0, 0);
my ($maxx, $maxy) = (0, 0);
my ($mindepth, $maxdepth) = (0,0);

while (<>) {
	chomp;
	$x = 0;
	for my $c (split //) {
		$map{"0:$y,$x"} = $c;
		$maxx = $x if $x > $maxx;
		$x++;
	}
	$maxy = $y;
	$y++;
}

my %seen;

for (1..200) {
	%map = %{ tick(\%map) };
}
print count_bugs(\%map), "\n";

sub draw {
	my ($map, $d) = @_;
	for my $y (0 .. $maxy) {
		for my $x (0 .. $maxx) {
			print $map{"$d:$y,$x"};
		}
		print "\n";
	}
}

sub tick {
	my ($map) = @_;
	my $new = {%$map};
	for my $d ($mindepth-1 .. $maxdepth+1) {
		for my $y (0 .. $maxy) {
			for my $x (0 .. $maxx) {
				$new->{"$d:$y,$x"} //= '.';
				next if $x == 2 && $y == 2;
				my $nbugs = count_adjacent($map, $d, $x, $y);
				if ($map->{"$d:$y,$x"} eq '#') {
					$new->{"$d:$y,$x"} = '.' unless $nbugs == 1;
				} else {
					if ($nbugs == 1 || $nbugs == 2) {
						$new->{"$d:$y,$x"} = '#';
						$mindepth = $d if $d < $mindepth;
						$maxdepth = $d if $d > $maxdepth;
					}
				}
			}
		}
	}
	return $new;
}

sub count_adjacent {
	my ($map, $depth, $x, $y) = @_;

	my $bugs = 0;

	my $upd = $depth-1; # around outside
	my $downd = $depth+1; # in centre

	my @dx = (0, 1, 0, -1);
	my @dy = (1, 0, -1, 0);
	for my $d (0..3) {
		my $nx = $x + $dx[$d];
		my $ny = $y + $dy[$d];
		if ($nx < 0) {
			$bugs++ if $map->{"$upd:2,1"} eq '#';
		} elsif ($nx > $maxx) {
			$bugs++ if $map->{"$upd:2,3"} eq '#';
		} elsif ($ny < 0) {
			$bugs++ if $map->{"$upd:1,2"} eq '#';
		} elsif ($ny > $maxy) {
			$bugs++ if $map->{"$upd:3,2"} eq '#';
		} elsif ($nx == 2 && $ny == 2) {
			if ($d == 0) { # +y
				$bugs += $map->{"$downd:0,$_"} eq '#' for (0..4);
			} elsif ($d == 1) { # +x
				$bugs += $map->{"$downd:$_,0"} eq '#' for (0..4);
			} elsif ($d == 2) { # -y
				$bugs += $map->{"$downd:4,$_"} eq '#' for (0..4);
			} elsif ($d == 3) { # -x
				$bugs += $map->{"$downd:$_,4"} eq '#' for (0..4);
			}
		} else {
			$bugs++ if $map->{"$depth:$ny,$nx"} eq '#';
		}
	}

	return $bugs;
}

sub count_bugs {
	my ($map) = @_;
	my $c = 0;
	for my $n (values %$map) {
		$c++ if $n eq '#';
	}
	return $c;
}
