=head1 Data::Kanji::Kanjidic

Data::Kanji::Kanjidic

=cut
package Data::Kanji::Kanjidic;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/parse_kanjidic parse_entry kanji_dictionary_order
                grade_stroke_order/;
use warnings;
use strict;
our $VERSION = 0.01;


use strict;
use warnings;
use Encode;
use utf8;
#use encoding "euc-jp";

# This is a list of the letter codes used in kanjidic, plus more
# meaningful long names which will be used as the names of columns in
# a database.

our %codes = 
(
 'W' => 'KOREAN',
 'Y' => 'PINYIN',

# '{' => 'ENGLISH_START', 
# '}' => 'ENGLISH_END',

# Codes for kanji classification schemes.

 'B' => 'BUSHU',
 'C' => 'CLASSIC_RADICAL',
 'U' => 'UNICODE',

# The school grade at which the kanji is learnt. These need to be
# checked.

 'G' => 'GRADE',
 'Q' => 'FOUR_CORNER',
 'S' => 'STROKE_COUNT',
 'P' => 'SKIP', 

# Japanese proficiency test level

 'J' => 'JPROF',

# Codes for various books.

 'N' => 'NELSON',
 'V' => 'NEW_NELSON',
 'L' => 'HEISIG',

# The numbers used in P.G. O'Neill's "Japanese Names".

 'O' => 'ONEILL',
 'K' => 'GAKKEN',
 'E' => 'HENSHALL',
 'I' => 'SPAHN_HADAMITZKY',
 'IN' => 'SH_KANJI_KANA',

# 'M' => 'MOROHASHI',

 'MP' => 'MOROHASHI_PAGE',
 'MN' => 'MOROHASHI_INDEX',
 'H' => 'HALPERN',
 'F' => 'FREQUENCY',

 'X' => 'CROSS_REF',

# D-type book-specific numbers:

# the index numbers used in "Japanese For Busy People" vols I-III,
# published by the AJLT. The codes are the volume.chapter.

 'DB' => 'BUSY_PEOPLE', 

# the index numbers used in "The Kanji Way to Japanese Language Power"
# by Dale Crowley.

 'DC' => 'KANJI_WAY', 

# "Japanese Kanji Flashcards", by Max Hodges and Tomoko Okazaki (White Rabbit Press).

 'DF' => 'RABBIT',

# The index numbers used in the "Kodansha Compact Kanji Guide".

 'DG' => 'KODANSHA', 

# The index numbers used in the 3rd edition of "A Guide To Reading and
# Writing Japanese" edited by Ken Hensall et al.

 'DH' => 'HENSHALL',

# The index numbers used in the "Kanji in Context" by Nishiguchi and Kono.

 'DJ' => 'KANJIINCONTEXT', 

# The index numbers used by Jack Halpern in his Kanji Learners
# Dictionary, published by Kodansha in 1999. The numbers have been
# provided by Mr Halpern.

 'DK' => 'HALPERN',

# French "Remembering the kanji"

 'DM' => 'FRENCHHEISIG',

# The index numbers used in P.G. O'Neill's Essential Kanji. The
# numbers have been provided by Glenn Rosenthal.

 'DO' => 'ONEILL',

# These are the codes developed by Father Joseph De Roo, and published
# in his book "2001 Kanji" (Bonjinsha). Fr De Roo has given his
# permission for these codes to be included.

 'DR' => 'DEROO',

# The index numbers used in the early editions of "A Guide To Reading
# and Writing Japanese" edited by Florence Sakade.

 'DS' => 'SAKADE',

# The index numbers used in the Tuttle Kanji Cards, compiled by
# Alexander Kask.

 'DT' => 'KASK',

# Cross references:

 'XJ' => 'CROSSREF',
 'XO' => 'CROSSREF',
 'XH' => 'CROSSREF',
 'XI' => 'CROSSREF',
 'XN' => 'NELSONCROSSREF',
 'XDR' => 'DEROOCROSSREF',
 'T' => 'SPECIAL',

# To-do: give these more meaningful names.

 'ZPP' => 'MISCLASSIFICATIONpp',
 'ZRP' => 'MISCLASSIFICATIONrp',
 'ZSP' => 'MISCLASSIFICATIONsp',
 'ZBP' => 'MISCLASSIFICATIONrp',
);

# Parse one string from kanjidic and return it in an associative array.

#$| = 1;

sub parse_entry
{
    my ($input) = @_;

# Remove the English entries first.

    my $counter;
    my @english;
    my @onyomi;
    my @kunyomi;
    my %values;
    while ($input =~ s/\{([^\}]+)\}//) {
        my $meaning = $1;

# Construct a list of "kokuji" (characters made in Japan).

        if ($meaning =~ m/\(kokuji\)/) {
            $values{"kokuji"} = 1;
        }

# Construct a list of single-kanji counters.

        elsif ($meaning =~ m/^counter for (.*)$/) {
            if ($values{"counter"}) {
                print "Warning: two counters in $input\n";
            }
            $values{"counter"} = $1;
        } else {
            push (@english, $meaning);
        }
    }

    (my $kanji, $values{"jiscode"}, my @entries) = split (" ", $input);
    $values{kanji} = $kanji;
    foreach my $entry (@entries) {
        my $found;
        if ($entry =~ m/(^[A-Z]+)(.*)/ ) {
	    my $field = $1;
            if ($codes{$field}) {
		if (!$values{$field}) {
		    $values{$field} = $2;
		} elsif ($field eq "S") {
		    $values{S2} = $2;
#		    print "$values{kanji} has two secont is $2\n";
		}

		$found = 1;
            }
# Kanjidic contains hiragana, katakana, ".", "-" and "ー" (Japanese
# "chouon") characters.
	} else {
	    my $utf8=$entry;
#	    print "utf8: ", $utf8, "\n";
	    if ($utf8 =~ m/^([あ-ん\.-]+)$/) {
		push (@kunyomi, $utf8);
		$found = 1;
	    } elsif ($utf8 =~ m/^([ア-ンー\.-]+)$/) {
		push (@onyomi, $utf8);
		$found = 1;
	    }
        }
        if (! $found) {
            warn "$.: Mystery entry \"$entry\"\n";
        }
    }

    $values{"english"} = \@english;
    $values{"onyomi"}  = \@onyomi;
    $values{"kunyomi"} = \@kunyomi;

# Kanjidic uses the bogus radical numbers of Nelson rather than the
# correct ones.

    $values{radical} = $values{B};
    $values{radical} = $values{C} if $values{C};

# Just in case there is a problem in kanjidic, this will tell us the
# line where the problem was:

    $values{"line_number"} = $.;
    return %values;
}

# Order of kanji in a kanji dictionary.

sub kanji_dictionary_order
{
    my ($kanjidic_ref, $a, $b) = @_;
    #    print "$a, $b,\n";
    my $valuea = $kanjidic_ref->{$a};
    my $valueb = $kanjidic_ref->{$b};
    my $radval = $$valuea{radical} - $$valueb{radical};
    return $radval if $radval;
    my $strokeval = $$valuea{S} - $$valueb{S};
    return $strokeval if $strokeval;
    my $jisval = hex ($$valuea{jiscode}) - hex ($$valueb{jiscode});
    return $jisval if $jisval;
    return 0;
}

# Comparison function to sort by grade and then stroke order, then JIS
# code value if those are both the same.

sub grade_stroke_order
{
    my ($kanjidic_ref, $a, $b) = @_;
    #    print "$a, $b,\n";
    my $valuea = $kanjidic_ref->{$a};
    my $valueb = $kanjidic_ref->{$b};
    if ($valuea->{G}) {
        if ($valueb->{G}) {
            my $gradeval = $$valuea{G} - $$valueb{G};
            return $gradeval if $gradeval;
        }
        else {
            return -1;
        }
    } elsif ($valueb->{G}) {
        return 1;
    }
    my $strokeval = $$valuea{S} - $$valueb{S};
    return $strokeval if $strokeval;
    my $jisval = hex ($$valuea{jiscode}) - hex ($$valueb{jiscode});
    return $jisval if $jisval;
    return 0;
}

sub parse_kanjidic
{
    my ($kanjidic_ref, $file_name) = @_;
    my $KANJIDIC;

    open $KANJIDIC, "<:encoding(euc-jp)", $file_name
        or die "Could not open '$file_name': $!";
    binmode STDOUT,"utf8";
    while (<$KANJIDIC>) {
        next if ( m/^\#/ );
        my %values = parse_entry ($_);
        my @skip = split ("-", $values{P});
        $values{skip} = \@skip;
        $kanjidic_ref->{$values{kanji}} = \%values;
    }
}

1;

__END__

=head1 NAME

Data::Kanji::Kanjidic - parse the "kanjidic" kanji data file

=head1 SYNOPSIS

=head1 FUNCTIONS

