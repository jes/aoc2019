#!/usr/bin/perl

use strict;
use warnings;

open(my $fh, '<', '17.path')
    or die "can't read 17.path: $!";

# left = positive
my @xd = (0,-1,0,1);
my @yd = (-1,0,1,0);

my $dir = 0;

my $in = <$fh>;
chomp $in;

my @instr = split /,/, $in;
my $realstr = '';
for my $i (@instr) {
    if ($i eq 'L') {
        $realstr .= $i;
    } elsif ($i eq 'R') {
        $realstr .= $i;
    } else {
        while ($i > 0) {
            $realstr .= '2';
            $i -= 2;
        }
    }
}

print "leninput = " . length($realstr) . "\n";

my $a;
my $b;

for my $lena (1 .. 40) {
    $a = substr($realstr, 0, $lena);
    for my $lenb (1 .. 40) {
        $b = substr($realstr, $lena, $lenb);

        my $str = $realstr;
        $str =~ s/$a/ /g;
        $str =~ s/$b/ /g;
        $str =~ s/^\s*//g;
        $str =~ s/\s*$//g;
        my @parts = split / +/, $str;
        my $shortestpart = 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
        for my $p (@parts) {
            $shortestpart = $p if length($p) < length($shortestpart);
        }
        $shortestpart = tryfactor($shortestpart,$_) for (1..10);
        my $ok = 1;
        for my $p (@parts) {
            $ok = 0 unless ($p =~ /^($shortestpart)+$/);
        }
        if ($ok) {
            my $nstr = $realstr;
            $nstr =~ s/$a/A/g;
            $nstr =~ s/$b/B/g;
            $nstr =~ s/$shortestpart/C/g;
            print "A=$a\nB=$b\nC=$shortestpart\n$nstr\n";
        }
    }
}

sub tryfactor {
    my ($s, $factor) = @_;

    return $s if length($s)%$factor != 0;

    my $thinglen = length($s)/$factor;

    my @a = split //, $s;
    for my $i (0 .. (@a/$factor)-1) {
        for my $j (1 .. $factor-1) {
            return $s if $a[$i] ne $a[$j*$thinglen+$i];
        }
    }

    return substr($s, 0, $thinglen);
}
