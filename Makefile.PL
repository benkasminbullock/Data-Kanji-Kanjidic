use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/Data/Kanji/Kanjidic.pm';
my $pod = 'lib/Data/Kanji/Kanjidic.pod';

WriteMakefile (
    NAME => 'Data::Kanji::Kanjidic',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pod,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
);
