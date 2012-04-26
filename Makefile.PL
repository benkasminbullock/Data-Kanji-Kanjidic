use strict;
use warnings;
use ExtUtils::MakeMaker;

my $name = 'Data::Kanji::Kanjidic';
my $pm = "lib/$name.pm";
$pm =~ s!::!/!g;
my $pod = $pm;
$pod =~ s!\.pm$!.pod!;
my $repo = "https://github.com/benkasminbullock/$name";
$repo =~ s!::!-!g;

WriteMakefile (
    NAME => 'Data::Kanji::Kanjidic',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pod,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
);
