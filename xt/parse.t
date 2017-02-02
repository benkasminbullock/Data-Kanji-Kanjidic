use warnings;
use strict;
use Data::Kanji::Kanjidic 'parse_kanjidic';
use utf8;
use Test::More;
binmode STDOUT, ":encoding(utf8)";
my %codes = %Data::Kanji::Kanjidic::codes;
my $kfile = '/home/ben/data/edrdg/kanjidic';
my $k;
$Data::Kanji::Kanjidic::AUTHOR = 1;
eval {
    $k = parse_kanjidic ($kfile);
};
ok (! $@, "no errors parsing $kfile");
done_testing ();
