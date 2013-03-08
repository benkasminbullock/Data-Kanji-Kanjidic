use warnings;
use strict;
use Test::More;
use Data::Kanji::Kanjidic 'parse_kanjidic';
use FindBin;
use utf8;

my $kanji = parse_kanjidic ("$FindBin::Bin/kanjidic-sample");
ok ($kanji->{亜}, "Got entry for 亜");
my $a = $kanji->{亜};
cmp_ok ($a->{Q}->[0], '<', 100000, "Sane value for four corner code");

done_testing ();

# Local variables:
# mode: perl
# End:
