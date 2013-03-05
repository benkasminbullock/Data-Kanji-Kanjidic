#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Template;
BEGIN: {
    use FindBin;
    use lib "$FindBin::Bin/../lib";
};
use Data::Kanji::Kanjidic qw/%codes %has_dupes/;
use FindBin;

# Names of the input and output files containing the documentation.

my $pod = 'Kanjidic.pod';
my $input = "$FindBin::Bin/$pod.tmpl";
my $output = "$FindBin::Bin/../lib/Data/Kanji/$pod";

# Template toolkit variable holder

my %vars;

$vars{codes} = \%codes;
$vars{has_dupes} = \%has_dupes;

my $tt = Template->new (
    ABSOLUTE => 1,
    INCLUDE_PATH => [$FindBin::Bin, '/home/ben/projects/Perl-Build/lib/Perl/Build/templates', "$FindBin::Bin/../examples"],
    ENCODING => 'UTF8',
);

$tt->process ($input, \%vars, $output, {binmode => 'utf8'})
    or die '' . $tt->error ();

