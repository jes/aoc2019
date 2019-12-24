#!/usr/bin/perl

use strict;
use warnings;

my %map;
my ($x, $y) = (0, 0);
my ($maxx, $maxy) = (0, 0);

while (<>) {
	chomp;
	$x = 0;
	for my $c (split //) {
		$map{"$y,$x"} = $c;
		$maxx = $x if $x > $maxx;
		$x++;
	}
	$maxy = $y;
	$y++;
}

my %seen;

while (1) {
	%map = %{ tick(\%map) };
	if ($seen{strmap(\%map)}) {
		print biodiv(\%map), "\n";
		exit;
	}
	$seen{strmap(\%map)} = 1;
}

sub draw {
	my ($map) = @_;
	for my $y (0 .. $maxy) {
		for my $x (0 .. $maxx) {
			print $map{"$y,$x"};
		}
		print "\n";
	}
}

sub tick {
	my ($map) = @_;
	my $new = {};
	for my $y (0 .. $maxy) {
		for my $x (0 .. $maxx) {
			my $nbugs = count_adjacent($map, $x, $y);
			$new->{"$y,$x"} = $map->{"$y,$x"};
			if ($map->{"$y,$x"} eq '#') {
				$new->{"$y,$x"} = '.' unless $nbugs == 1;
			} else {
				$new->{"$y,$x"} = '#' if $nbugs == 1 || $nbugs == 2;
			}
		}
	}
	return $new;
}

sub count_adjacent {
	my ($map, $x, $y) = @_;

	my $bugs = 0;

	my @dx = (0, 1, 0, -1);
	my @dy = (1, 0, -1, 0);
	for my $d (0..3) {
		my $nx = $x + $dx[$d];
		my $ny = $y + $dy[$d];
		next if $nx < 0 || $ny < 0 || $nx > $maxx || $ny > $maxy;
		$bugs++ if $map->{"$ny,$nx"} eq '#';
	}

	return $bugs;
}

sub strmap {
	my ($map) = @_;
	my $s = '';
	for my $y (0 .. $maxy) {
		for my $x (0 .. $maxx) {
			$s .= $map{"$y,$x"};
		}
	}
	return $s;
}

sub biodiv {
	my ($map) = @_;
	my $n = 0;
	my $power2 = 1;
	for my $c (split //, strmap($map)) {
		$n += $power2 if $c eq '#';
		$power2 *= 2;
	}
	return $n;
}
