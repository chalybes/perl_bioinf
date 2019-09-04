#!/usr/bin/perl

use warnings;
use strict;

/* This file finds all potential 12-mer CRISPR sites within the
   Drosophila melanogaster genome. */

my %crisprHash = ();
my %last12 = ();

# Call subroutine to load Drosophila sequencing data 2L
my $sequenceRef = loadSequence("/scratch/Drosophila/dmel-all-chromosome-r6.02.fasta");

# File I/O for the output text
open (OUTFASTA, ">", '12-merEndingGG.fasta') or die "Could not open file $!";

my $windowSize = 21;        # Set the size of the sliding window
my $stepSize   = 1;         # Set the step size
my $count   = 1;         # Initialize my maximum score to zero

sub loadSequence {
    #Get my sequence file name from the parameter array
    my ($sequenceFile) = @_;

    #Initialize my sequence to the empty string]
    my $sequence = "";

    #Open the sequence file
    unless (open( FASTA, "<", $sequenceFile)) {
        die $!;        #Die and tell me what's wrong if file can't be opened.
    }

    #Loop throught the file line-by-line
    while (<FASTA>) {

            #Assign the line, which is in the default variable, to a named variable
            #for readability.
            my $line = $_;

            #Chomp to get rid of end-of-line characters
            chomp($line);

            #Check to see if this is a FASTA header line
            if ( $line !~ /^>/ ) {

                    #If it's not a header line append it to my sequence
                    $sequence .= $line;
            }
    }
    # Return a reference to the sequence
    return \$sequence;
}

sub KmerCounter {
    my $lim = length($$sequenceRef);
    my $ckey = "";
    my $cvalue = "";

    for (my $i = 0; $i <= ($lim - $windowSize); $i += $stepSize) {

      my $windowSeq = substr($$sequenceRef, $i, $windowSize);

      # regex for matching kmers of nucleotide length 21, ending with GG
      # AND is also undefined (not existent) in hash
      if ($windowSeq =~ /([ATGC]{9}([ATGC]{10}GG$))/gi) {
          $cvalue = $1;
          $ckey = $2;

          if (!defined($crisprHash{$ckey})) {
             $crisprHash{$ckey} = $cvalue;
             $last12{$ckey} = 1;
          } else {
             $last12{$ckey}++;
          }
       }
    }
}

sub PrintKmers {

  # While there are keys-values within hash, so long as the values
  # equal to 1 (meaning that the key is unique) then output the keys
  # to 12-merEndingGG.fasta
  while( my( $key, $value ) = each %last12 ) {
     #print OUTFILE join("\t", $key, $value), "\n";
     if ($value == 1) {
       print OUTFASTA ">crispr_$count \n$crisprHash{$key}\n";
       $count++;
     }
  }
}

KmerCounter();
PrintKmers();
