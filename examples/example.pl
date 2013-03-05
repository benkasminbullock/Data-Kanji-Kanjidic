use Data::Kanji::Kanjidic 'parse_kanjidic';
my $kanji = parse_kanjidic ('/path/to/kanjidic');
for my $k (keys %$kanji) {
    print "$k has radical number $kanji->{C}.\n";
}
