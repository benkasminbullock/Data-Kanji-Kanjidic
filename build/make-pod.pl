#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Template;
use lib '../lib';
use Data::Kanji::Kanjidic;
use FindBin;

# Names of the input and output files containing the documentation.

my $pod = 'Kanjidic.pod';
my $input = "$FindBin::Bin/$pod.tmpl";
my $output = "$FindBin::Bin/../lib/Data/Kanji/$pod";

# Codes used in Kanjidic

my %codes = %Data::Kanji::Kanjidic::codes;

# Template toolkit variable holder

my %vars;

$vars{codes} = \%codes;

my $tt = Template->new (
    ABSOLUTE => 1,
    INCLUDE_PATH => [$FindBin::Bin, '/home/ben/projects/Perl-Build/templates'],
    ENCODING => 'UTF8',
);

$tt->process ($input, \%vars, $output, {binmode => 'utf8'})
    or die '' . $tt->error ();

