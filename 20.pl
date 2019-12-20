#!/usr/bin/perl

use strict;
use warnings;

my %map;
my %seen_portal; # map 'AA' to (x,y)
my %portal; # map (x1,y1) to (x2,y2)

my ($maxx,$maxy) = (0,0);
my $y = 0;

while (<>) {
    chomp;
    my $x = 0;
    for my $c (split //) {
        $map{"$y,$x"} = $c;
        $maxx = $x if $x > $maxx;
        $x++;
    }

    $maxy = $y if $y > $maxy;
    $y++;
}

# XXX: assume square maze , etc.
for my $x (0 .. $maxx) {
    # add_portal takes ([name, location])
    add_portal(@$_) for (
        [$map{"$x,0"}.$map{"$x,1"}, "$x,2"],
        [$map{"$x,33"}.$map{"$x,34"}, "$x,32"],
        [$map{"$x,88"}.$map{"$x,89"}, "$x,90"],
        [$map{"$x,121"}.$map{"$x,122"}, "$x,120"],
        [$map{"0,$x"}.$map{"1,$x"}, "2,$x"],
        [$map{"33,$x"}.$map{"34,$x"}, "32,$x"],
        [$map{"88,$x"}.$map{"89,$x"}, "90,$x"],
        [$map{"121,$x"}.$map{"122,$x"}, "120,$x"],
    );
}

my @q = ([$seen_portal{AA}, 0]);
my %visited = ($seen_portal{AA} => 1);
while (@q) {
    my ($loc, $len) = @{ shift @q };
    my ($x,$y) = split /,/, $loc;

    if ($loc eq $seen_portal{ZZ}) {
        print "$len\n";
        exit;
    }

    for my $newloc (neighbours($loc)) {
        next if $visited{$newloc};
        $visited{$newloc} = 1;
        push @q, [$newloc, $len+1];
    }
}

sub add_portal {
    my ($name, $loc) = @_;

    return if $name !~ /^[A-Z]+$/;

    if ($seen_portal{$name}) {
        $portal{$loc} = $seen_portal{$name};
        $portal{$seen_portal{$name}} = $loc;
    } else {
        $seen_portal{$name} = $loc;
    }
}

sub neighbours {
    my ($loc) = @_;    

    my @dx = (0, 1, 0, -1);
    my @dy = (1, 0, -1, 0);

    my @r;

    my ($x,$y) = split /,/, $loc;

    for my $d (0..3) {
        my $nx = $x+$dx[$d];
        my $ny = $y+$dy[$d];
        push @r, "$nx,$ny" if $map{"$nx,$ny"} eq '.';
    }

    push @r, $portal{$loc} if $portal{$loc};

    return @r;
}
