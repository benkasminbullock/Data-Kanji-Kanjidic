use Data::Kanji::Kanjidic 'parse_kanjidic';
use FindBin;
binmode STDOUT, ":utf8";
my $kanji = parse_kanjidic ("$FindBin::Bin/../t/kanjidic-sample");
for my $k (sort keys %$kanji) {
    my $mo = $kanji->{$k}->{morohashi};
    if ($mo) {
        print "$k: volume $mo->{volume}, page $mo->{page}, index $mo->{index}.\n";
    }
}

