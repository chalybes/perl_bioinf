#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

/* This Perl script will pull the pertinent fields from the FASTA
  headers of Swiss-prot protein annotation file. */

#assigns the file directory to scalar called "infile"
my $infile = '/scratch/SampleDataFiles/example.sp';

#throws exception message if file cannot be opened
unless ( open(INFILE, "<", $infile)) {
	die "Can't open ", $infile, " for reading: $!";
}

#Change the record separator
$/ = "//\n";


# while there are still lines to be read from file the lines will be split
# and any lines with the annotation "AC", "OS", "OX", "GN", and "SQ" will be filtered by grep and printed
# to console. The actual amino acid sequence starts on lines without annotations, and so the if
# statement will attempt to pull and print those
while (<INFILE>) {
	chomp;
	my $swissProtRecord = $_;

        my @ProtLines = grep {/^(AC|OS|OX|GN|SQ|\s)\s+(.*?)/} split (/\n/, $swissProtRecord);


        print "> ", @ProtLines, "\n";

        #if ($swissProtRecord =~ /(\s+|^)/gi) {
            #print $1, "\n";
        #}

}

#Closes file I/O
close INFILE;
