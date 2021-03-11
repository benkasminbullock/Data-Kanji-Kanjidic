#!/home/ben/software/install/bin/perl
use Z;
use lib '/home/ben/projects/www-linkrot/lib';
use WWW::LinkRot ':all';
my $ok = GetOptions (
    verbose => \my $verbose,
);
# Some of the links are added by make-pod.pl
do_system ("$Bin/build/make-pod.pl", $verbose);
my $infile = "$Bin/lib/Data/Kanji/Kanjidic.pod";
#my $infile = "$Bin/build/Kanjidic.pod.tmpl";
my %links;
my $text = read_text ($infile);
while ($text =~ m!(https?://[^>]*)!g) {
    $links{$1} = [$infile];
}
my $rfile = "$Bin/dkk-links.json";
my $hfile = "/usr/local/www/data/dkk-links.html";
check_links (\%links, out => $rfile, nook => 1, verbose => $verbose,);
html_report (in => $rfile, out => $hfile, strip => "$Bin/lib",
	     url => "http://mikan/pod.cgi/", verbose => $verbose,);
