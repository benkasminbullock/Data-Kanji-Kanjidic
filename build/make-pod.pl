#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Template;
use Perl::Build qw/get_info get_commit/;
BEGIN: {
    use FindBin '$Bin';
    use lib "$Bin/../lib";
};
use Data::Kanji::Kanjidic qw/%codes %has_dupes/;
use FindBin;

# Names of the input and output files containing the documentation.

my $pod = 'Kanjidic.pod';
my $input = "$Bin/$pod.tmpl";
my $output = "$Bin/../lib/Data/Kanji/$pod";
my $info = get_info (base => "$Bin/..");
my $commit = get_commit (base => "$Bin/..");
# Template toolkit variable holder

my %vars;

$vars{codes} = \%codes;
$vars{has_dupes} = \%has_dupes;
$vars{info} = $info;
$vars{commit} = $commit;

my $tt = Template->new (
    ABSOLUTE => 1,
    INCLUDE_PATH => [$Bin, '/home/ben/projects/Perl-Build/lib/Perl/Build/templates', "$Bin/../examples"],
    ENCODING => 'UTF8',
    FILTERS => {
        xtidy => [
            \& xtidy,
            0,
        ],
    },
);

if (-f $output) {
    chmod 0644, $output;
}

$tt->process ($input, \%vars, $output, {binmode => 'utf8'})
    or die '' . $tt->error ();

# Change the output file to read-only to prevent us wasting time
# trying to edit it.

chmod 0444, $output;

exit;

# This removes some obvious boilerplate from the examples, to shorten
# the documentation, and indents it to show POD that it is code.

sub xtidy
{
    my ($text) = @_;

    # Remove shebang.

    $text =~ s/^#!.*$//m;

    # Remove sobvious.

    $text =~ s/use\s+(strict|warnings|utf8);\s+//g;

    $text =~ s/binmode\s+STDOUT.*?utf8.*?\s+//;

    # Add indentation.

    $text =~ s/^(.*)/    $1/gm;

    # Change "local" form.

    $text =~ s!/home/ben/data/edrdg/kanjidic!/path/to/kanjidic!;

    return $text;
}
