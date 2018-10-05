#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Perl::Build;

perl_build (
    pre => 'build/copy-kanjidic.pl',
    make_pod => 'build/make-pod.pl',
    clean => './cleanup.pl',
);
