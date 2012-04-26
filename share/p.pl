#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use JSON::Parse 'json_to_perl';
use Deploy 'file_slurp';
my $k = file_slurp ('kanjidic-codes.json');
my $p = json_to_perl ($k);
for my $k (keys %$p) {
    print "$k $p->{$k}{description}\n";
}
