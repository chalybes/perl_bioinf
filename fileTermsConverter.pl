#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

/* This Perl script will convert the EGF Symbol to its corresponding
   gene ontology term in the FlyRNAi_baseline text file. */

# Files to be read in and used to build hash map
open (DROPHTSV, "<", '/scratch/Drosophila/fb_synonym_fb_2014_05.tsv') or die $!;
open (FLYRNAI, "<", '/scratch/Drosophila/FlyRNAi_baseline_vs_EGF.txt') or die $!;
open (GOAGASS, "<", '/scratch/Drosophila/gene_association.goa_fly') or die $!;
open (FLYEGF, "<", '~/FlyRNAi_baseline_vs_EGFSymbol.txt') or die $!;

# Output files
open (CONFILE, ">", 'FlyRNAi_baseline_vs_EGFSymbol.txt') or die "Could not open file $!";
open (FLYGO, ">", 'FlyRNAi_baseline_vs_EGF_GO.txt') or die "Could not open file $!";

# Initialize my base hash map for storing columns 1 and 2 of fb_synonym_fb as keys and their respective values
my %TSVhash = ();
my %EGFGoHash = ();

sub DataToGeneSym {

  # First while loop goes through "fb_synonym_fb_2014_05.tsv" and takes in first two tabular columns
  # to be used to create the hash map called "TSVHash"
  while (<DROPHTSV>) {
      chomp;

      # initialize my lines from DROPHTSV as scalars to be placed into hash map (%TSVhash)
      my ($Ids, $currSym) = split("\t", $_);

      if (defined $Ids) {
          # Takes $Ids as keys and assigns $currSym (gene symbol)
          # as the values to those keys in the map
          $TSVhash{$Ids} = $currSym;
      } else {
          next; #If $Ids is undef then this condition takes over and that scalar is not stored in hash
      }
  }

  # This while loops through the FlyRNAi_baseline_vs_EGF.txt and uses data from the first three
  # columns to make the resulting FlyRNAi_baseline_vs_EGFSymbol.txt.
  while (<FLYRNAI>) {
      chomp; #removes whitespace

      # Split the incoming lines based on tabular indents, there are three columns
      # whose data we need to pull
      my ($FbIds, $FlyBase, $FlyStim) = split("\t", $_);

      # if the ID from FlyRNAi is present and matches a key in %TSVhash, then the FlyRNAi
      # ID gets changed to the corresponding gene symbol value from the hash
      if (defined $TSVhash{$FbIds}) {
        $FbIds = $TSVhash{$FbIds};
      } else {
        # Skips over the ID and doesn't incorporated into FlyRNAi_baseline_vs_EGFSymbol.txt
        # Because no gene symbole for that ID exists
        next;
      }
        # outputs the new changes to the text file 'FlyRNAi_baseline_vs_EGFSymbol.txt' using file I/O
        print CONFILE join("\t", $FbIds, $FlyBase, $FlyStim), "\n";
    }

    close(CONFILE); #Closes File I/O

    #This while loop loops through "gene_association.goa_fly" in order to assign the columns (3 & 5)
    #into a hash map.
    while (my $goaLine = <GOAGASS>) {
        chomp $goaLine;

        my @columns = split("\t", $goaLine);

        my $flyKey = $columns[2]; #take column 3 and store into list (to be made into hash keys)
        my $flyValue = $columns[4];  #take column 5 and store into list (to be made into values of keys)

        if (defined $flyKey) {
            #Assigns $flyKey and $flyValue into hash map
            $EGFGoHash{$flyKey} = $flyValue;
        } else {
            next; #If flyKey is not valid AKA "uninitialized", then that scalar is skipped over
        }
    }

    # This while loop loops through the FlyEGF file made previously (FlyRNAi_baseline_vs_EGFSymbol.txt)
    # and reads in the columns from that file. If any of the IDS from FlyRNAi_baseline_vs_EGFSymbol.txt
    # matches the IDs stored in EGFGoHash, then the gene symbol IDs from RNAi_baseline_vs_EGFSymbol.txt
    # gets changed into the GO ID stored in EGFGoHash, producing final values for
    # FlyRNAi_baseline_vs_EGF_GO.txt
    while (<FLYEGF>) {
        chomp;

        # Splits the columns from the file into scalars
        my ($FlyIds, $FlyBase, $FlyStim) = split("\t", $_);

        if (defined $EGFGoHash{$FlyIds}) {  # If a match occurs between the txt file and EGFGoHash
            $FlyIds = $EGFGoHash{$FlyIds};  # Changes the gene symbol ID to GO ID

            # Finally print this change to new output file called "RNAi_baseline_vs_EGF_GO.txt"
            print FLYGO join("\t", $FlyIds, $FlyBase, $FlyStim), "\n";
        }
    }
    #Close the RNAi_baseline_vs_EGF_Go.txt file I/O
    close(FLYGO);

}

DataToGeneSym();
