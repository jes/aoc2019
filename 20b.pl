#!/usr/bin/perl

use strict;
use warnings;

my %map;
my %seen_portal; # map 'AA' to (x,y,levelchange)
my %portal; # map (x1,y1) to (x2,y2,levelchange)

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
    # add_portal takes ([name, location, levelchange])
    add_portal(@$_) for (
        [$map{"$x,0"}.$map{"$x,1"}, "$x,2", -1],
        [$map{"$x,33"}.$map{"$x,34"}, "$x,32", 1],
        [$map{"$x,88"}.$map{"$x,89"}, "$x,90", 1],
        [$map{"$x,121"}.$map{"$x,122"}, "$x,120", -1],
        [$map{"0,$x"}.$map{"1,$x"}, "2,$x", -1],
        [$map{"33,$x"}.$map{"34,$x"}, "32,$x", 1],
        [$map{"88,$x"}.$map{"89,$x"}, "90,$x", 1],
        [$map{"121,$x"}.$map{"122,$x"}, "120,$x", -1],
    );
}

my @q = ([$seen_portal{AA}[0], 0, 0]);
my %visited = ("0:$seen_portal{AA}[0]" => 1);
while (@q) {
    my ($loc, $len, $level) = @{ shift @q };
    my ($x,$y) = split /,/, $loc;

    if ($loc eq $seen_portal{ZZ}[0] && $level == 0) {
        print "$len\n";
        exit;
    }

    for my $newlocx (neighbours($loc)) {
        my ($newloc, $levelchange) = @$newlocx;
        my $newlevel = $level+$levelchange;
        next if $newlevel < 0;
        next if $visited{"$newlevel:$newloc"};
        $visited{"$newlevel:$newloc"} = 1;
        push @q, [$newloc, $len+1, $newlevel];
    }
}

sub add_portal {
    my ($name, $loc, $levelchange) = @_;

    return if $name !~ /^[A-Z]+$/;

    if ($seen_portal{$name}) {
        $portal{$loc} = [$seen_portal{$name}[0], $levelchange];
        $portal{$seen_portal{$name}[0]} = [$loc, -$levelchange];
    } else {
        $seen_portal{$name} = [$loc,$levelchange];
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
        push @r, ["$nx,$ny",0] if $map{"$nx,$ny"} eq '.';
    }

    push @r, $portal{$loc} if $portal{$loc};

    return @r;
}
