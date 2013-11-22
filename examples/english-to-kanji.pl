# The following "joke" program converts English into kanji.

# Call it like "english-to-kanji.pl /where/is/kanjidic english-text".

use Data::Kanji::Kanjidic 'parse_kanjidic';
use Convert::Moji 'make_regex';
my $kanji = parse_kanjidic ($ARGV[0]);
my %english;
for my $k (keys %$kanji) {
    my $english = $kanji->{$k}->{english};
    if ($english) {
        for (@$english) {
            push @{$english{$_}}, $k;
        }
    }
}
my $re = make_regex (keys %english);
open my $in, "<", $ARGV[1] or die $!;
while (<$in>) {
    s/\b($re)\b/$english{$1}[int rand (@{$english{$1}})]/ge;
    print;
}

