# See Kanjidic.pod for documentation

package Data::Kanji::Kanjidic;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/parse_kanjidic
                parse_entry
                kanji_dictionary_order
                grade_stroke_order
                kanjidic_order/;
use warnings;
use strict;
our $VERSION = 0.01;
use strict;
use warnings;
use Encode;
use utf8;
use Carp;
# Parse one string from kanjidic and return it in an associative array.

#$| = 1;

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

# Fields which are allowed to have duplicates.

our %has_dupes = (
    'XJ' => 1,
);

sub parse_entry
{
    my ($input) = @_;

# Remove the English entries first.

    my $counter;
    my @english;
    my @onyomi;
    my @kunyomi;
    my @nanori;

    # Return value

    my %values;
    while ($input =~ s/\{([^\}]+)\}//) {
        my $meaning = $1;

# Construct a list of "kokuji" (characters made in Japan).

        if ($meaning =~ m/\(kokuji\)/) {
            $values{"kokuji"} = 1;
        }

# Construct a list of single-kanji counters.

        else {
            push (@english, $meaning);
        }
    }

    (my $kanji, $values{"jiscode"}, my @entries) = split (" ", $input);
    $values{kanji} = $kanji;
    # Flag to detect the start of nanori readings.
    my $in_nanori;
    foreach my $entry (@entries) {
        my $found;
        if ($entry =~ m/(^[A-Z]+)(.*)/ ) {
            if ($entry eq 'T1') {
                $in_nanori = 1;
                next;
            }
	    my $field = $1;
            my $value = $2;
            if ($codes{$field}) {
                if ($has_dupes{$field}) {
                    push @{$values{$field}}, $value;
                }
                else {
                    if (!$values{$field}) {
                        $values{$field} = $2;
                    }
                    elsif ($field eq "S") {
                        $values{S2} = $2;
                        #		    print "$values{kanji} has two secont is $2\n";
                    }
                }
		$found = 1;
            }
            else {
                die "Non-duplicate field '$field' has duplicate values";
            }
# Kanjidic contains hiragana, katakana, ".", "-" and "ー" (Japanese
# "chouon") characters.
	} 
        else {
            if ($in_nanori) {
                push @nanori, $entry;
                $found = 1;
            }
            else {
                if ($entry =~ m/^([あ-ん\.-]+)$/) {
                    push @kunyomi, $entry;
                    $found = 1;
                }
                elsif ($entry =~ m/^([ア-ンー\.-]+)$/) {
                    push @onyomi, $entry;
                    $found = 1;
                }
            }
        }
        if (! $found) {
            warn "$.: Mystery entry \"$entry\"\n";
        }
    }
    my %morohashi;
    if ($values{MP}) {
        @morohashi{qw/volume page/} = ($values{MP} =~ /(\d+)\.(\d+)/);
    }
    $morohashi{index} = $values{MN};

    if (@english) {
        $values{"english"} = \@english;
    }
    if (@onyomi) {
        $values{"onyomi"}  = \@onyomi;
    }
    if (@kunyomi) {
        $values{"kunyomi"} = \@kunyomi;
    }
    if (@nanori) {
        $values{"nanori"} = \@nanori;
    }
    $values{morohashi} = \%morohashi;

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
    my ($file_name) = @_;
    my $KANJIDIC;

    my %kanjidic;

    if (! -f $file_name) {
        croak "No such file '$file_name'";
    }

    open $KANJIDIC, "<:encoding(euc-jp)", $file_name
        or die "Could not open '$file_name': $!";
    binmode STDOUT,"utf8";
    while (<$KANJIDIC>) {
        # Skip the comment line.
        next if ( m/^\#/ );
        my %values = parse_entry ($_);
        my @skip = split ("-", $values{P});
        $values{skip} = \@skip;
        $kanjidic{$values{kanji}} = \%values;
    }
    close $KANJIDIC;
    return \%kanjidic;
}

# Return a list sorted by stroke order of the elements of
# \%kanjidic. Also add the field "kanji_id" to each of them so that
# the order can be reconstructed when referring to elements.

sub kanjidic_order
{
    my ($kanjidic_ref) = @_;
    my @kanjidic_order = 
        sort {
            $kanjidic_ref->{$a}->{S} <=> 
            $kanjidic_ref->{$b}->{S} ||
            $kanjidic_ref->{$a}->{B} <=> 
            $kanjidic_ref->{$b}->{B}
        }
            keys %$kanjidic_ref;
    my $count = 0;
    for my $kanji (@kanjidic_order) {
        $kanjidic_ref->{$kanji}->{kanji_id} = $count;
        $count++;
    }
    return @kanjidic_order;
}

sub new
{
    my ($package, $file) = @_;
    my $kanjidic = {};
    $kanjidic->{file} = $file;
    undef $file;
    $kanjidic->{data} = parse_kanjidic ($kanjidic->{file});
    bless $kanjidic;
    return $kanjidic;
}

# Make indices going from each type of key back to the data.

sub make_indices
{
    my ($kanjidic) = @_;
    my %indices;
    my $data = $kanjidic->{data};
    for my $kanji (keys %$data) {
        my $kdata = $data->{$kanji};
        for my $key (keys %$kdata) {
            $indices{$key}{$kdata->{$key}} = $kdata;
        }
    }
    $kanjidic->{indices} = \%indices;
}

sub find_key
{
    my ($kanjidic, $key, $value) = @_;
    if (! $kanjidic->{indices}) {
        make_indices ($kanjidic);
    }
    my $index = $kanjidic->{indices}{$key};
    return $index->{$value};
}

sub kanji_to_order
{
    my ($kanjidic, $kanji) = @_;
    if (! $kanjidic->{order}) {
        my @order = kanjidic_order ($kanjidic->{data});
        my %index;
        my $count = 0;
        for my $k (@order) {
            $index{$k} = $count;
            $count++;
        }
        $kanjidic->{order} = \@order;
        $kanjidic->{index} = \%index;
    }
    return $kanjidic->{index}->{$kanji};
}

1;

