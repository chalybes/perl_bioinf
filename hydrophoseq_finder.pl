#!/usr/bin/perl

use strict;
use warnings;

/* This Perl script will run through a specified FASTA file to identify
hydrophobic regions within the sequence. */


# location of the FASTA file, assigned to a scalar
my $TestFasta = "/scratch/SampleDataFiles/test.fasta";

# This will throw an exception message if file could not be opened
unless ( open(HYDROPHO, "<", $TestFasta)) {
  die "Cannot open file ", $TestFasta, " ", $!;
}

local $/ = ">";

# While loop that will find location of hydrophobic regions so long as there are still lines to be read from file
while (<HYDROPHO>) {
  chomp;
  #Splits the FASTA into multiple lines to be processed
  if ($_ =~ /^(.*?)$(.*)$/ms) {
     my $header = $1;
     my $seq = $2;
     $seq =~ s/\n//g;

     #print $header, "\n";

     # Regex filter in while loop to match and print out the hydrophobic stretch of amino acids
     while ($seq =~ m/([VILMFWCA]{8,})/gi) {
         my $theLength = length($1);  #Finds the length of the hydrophobic stretch
         my $LengthPosition = pos($seq);   #Finds the ending position of hydrophobic stretch

         print "Hydrophobic region found in ", $header, "\n";
         print $1, " found at residue ", $LengthPosition - $theLength + 1, "\n";
     }
  }
}

#Closes file I/O
close HYDROPHO;
