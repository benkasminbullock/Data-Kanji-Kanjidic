use warnings;
use strict;
use Test::More;
use FindBin;
use Data::Kanji::Kanjidic qw/parse_kanjidic kanjidic_order/;

my $k = parse_kanjidic ("$FindBin::Bin/kanjidic-sample");
my @order = kanjidic_order ($k);
ok (@order == keys %$k);

done_testing ();
