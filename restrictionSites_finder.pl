#!/usr/bin/perl

use warnings;
use strict;
use diagnostics;

/* This Perl script will run through whatever DNA sequence specified to search for potential restriction sites. */

my $dna1 = 'AACAGCACGGCAACGCTGTGCCTTGGGCACCATGCAGTACCAAACGGAACGATAGTGAAAACAATCACGAATGACCAAATTGAAGTTACTAATGCTACTGAGCTGGTTCAGAGTTCCTCAACAGGTGAAATATGCGACAGTCCTCATCAGATCCTTGATGGAGAAAACTGCACACTAATAGATGCTCTATTGGGAGACCCTCAGTGTGATGGCTTCCAAAATAAGAAATGGGACCTTTTTGTTGAACGCAGCAAAGCCTACAGCAACTGTTACCCTTATGATGTGCCGGATTATGCCTCCCTTAGGTCACTAGTTGCCTCATCCGGCACACTGGAATTTAACAATGAAAGCTTCAATTGGACTGGAGTCACTCAAAATGGAATCAGCTCTGCTTGCAAAAGGAGATCTAATAACAGTTTCTTTAGTAGATTGAATTGGTTGACCCACTTAAAATTCAAATACCCAGCATTGAACGTGACTATGCCAAACAATGAAAAATTTGACAAATTGTACATTTGGGGGGTTCACCACCCGGGTACGGACAATGACCAAATCTTCCTGTATGCTCAAGCATCAGGAAGAATCACAGTCTCTACCAAAAGAAGCCAACAGACTGTAATCCCGAATATCGGATCTAGACCCAGAGTAAGGAATATCCCCAGCAGAATAAGCATCTATTGGACAATAGTAAAACCGGGAGACATACTTTTGATTAACAGCACAGGGAATTTAATTGCTCCTAGGGGTTACTTCAAAATACGAAGTGGGAAAAGCTCAATAATGAGATCAGATGCACCCATTGGCAAATGCAATTCTGAATGCATCACTCCAAATGGAAGCATTCCCAATGACAAACCATTTCAAAATGTAAACAGGATCACATATGGGGCCTGGCCCAGATATGTTAAGCAAAACACTCTGAAATTGGCAACAGGGATGCGAAATGTACCAGAGAAACAAACTAGAGGCATATTTGGCGCAATCGCGGGTTTCATAGAAAATGGTTGGGAAGGAATGGTGGATGGTTGGTACGGTTT';

# Removes the whitespace from string input
$dna1 =~ s/\s//g;

# Subroutine that checks for two restriction site sequences to whatever is passed in, will print to console if those sequence are found
# In addition to printing out restriction site sequences it will also specify location along the sequence where the restriction sites
# were found
sub findPosition {
    my ($seqPass) = @_;

    # While there is still sequence lines to be matched, the filter for the restriction site will continue to match characters
    while ($seqPass =~ /(GA[ACT]TC)/gi) {
    	# Scalar below finds the overall length of GA[ACT]TC
        my $matchLength = length($1);

        # Scalar below finds the ending position of the located GA[ACT]TC
        my $position = pos($seqPass);

        #Prints to console the location of GA[ACT]TC
        print "The position of GA[ACT]TC is at residue ", $position - $matchLength + 1, "\n";
    }
    while ($seqPass =~ /(GCC[AT]GG)/gi) {
        #Scalar below finds the overall length of found restriction site sequence
        my $secondLength = length($1);
        #Scalar below finds the ending position of found restriction site sequence
        my $secPosition = pos($seqPass);

        #Prints to console the exact location of restriction site
        print "The position of GCC[AT]GG is at residue ", $secPosition - $secondLength + 1, "\n";
    }

}

findPosition($dna1);
