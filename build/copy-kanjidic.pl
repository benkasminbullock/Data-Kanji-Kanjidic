#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use FindBin;
use Deploy 'older';

my $max_lines = 20;
my $infile = '/home/ben/data/edrdg/kanjidic';
my $outfile = "$FindBin::Bin/../t/kanjidic-sample";

if (older ($outfile, $infile)) {
    print "$outfile is older than $infile.\n";
    print "Printing $max_lines of $infile into $outfile.\n";
    open my $in, "<:raw", $infile or die $!;
    open my $out, ">:raw", $outfile or die $!;
    my $lines = 0;
    while (<$in>) {
        print $out $_;
        $lines++;
        if ($lines >= $max_lines) {
            last;
        }
    }
    close $in or die $!;
    close $out or die $!;
}

