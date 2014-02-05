use strict;
use warnings;
use ExtUtils::MakeMaker;

# The name of the distribution.

my $name = 'Data::Kanji::Kanjidic';

# The name, but hyphenated.

my $hyph = $name;
$hyph =~ s!::!-!g;

my $slash = $name;
$slash =~ s!::!/!g;

# The Perl module name.

my $pm = "lib/$slash.pm";

# The documentation file, in POD format.

my $pod = $pm;
$pod =~ s!\.pm$!.pod!;

# The repository.

my $repo = "https://github.com/benkasminbullock/$hyph";

WriteMakefile (
    NAME => $name,
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pod,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
    PREREQ_PM => {
	Encode => 0,
	Carp => 0,
    },
    LICENSE => 'perl',
    MIN_PERL_VERSION => '5.006001',
);
