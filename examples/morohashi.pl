use Data::Kanji::Kanjidic 'parse_kanjidic';
use FindBin;
binmode STDOUT, ":utf8";
my $kanji = parse_kanjidic ("$FindBin::Bin/../t/kanjidic-sample");
for my $k (sort keys %$kanji) {
    my $morohashi = $kanji->{$k}->{morohashi};
    if ($morohashi) {
        print "$k: volume $morohashi->{volume}, page $morohashi->{page}, index $morohashi->{index}.\n";
    }
}

