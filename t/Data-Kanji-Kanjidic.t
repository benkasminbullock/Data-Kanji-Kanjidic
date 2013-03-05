use warnings;
use strict;
use Test::More;
use Data::Kanji::Kanjidic 'parse_kanjidic';
use FindBin;
use utf8;

my $kanji = parse_kanjidic ("$FindBin::Bin/kanjidic-sample");
ok ($kanji->{亜}, "Got entry for 亜");

done_testing ();

# Local variables:
# mode: perl
# End:
