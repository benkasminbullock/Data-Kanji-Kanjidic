use strict;
use warnings;
use ExtUtils::MakeMaker;

# The name of the distribution.

my $name = 'Data::Kanji::Kanjidic';

# The name, but hyphenated.

my $hyph = $name;
$hyph =~ s!::!/!g;

# The Perl module name.

my $pm = "lib/$hyph.pm";

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
    LICENSE => 'perl',
);
