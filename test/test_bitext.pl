#!/usr/bin/perl
#-*-perl-*-


use strict;
use lib 'perl/Lingua-Align/lib';


use Lingua::Align::Corpus::Parallel;


my $bitext = new Lingua::Align::Corpus::Parallel(
    -src_file => 'example/hansards.head.e',
    -trg_file => 'example/hansards.head.f');

my @src=();
my @trg=();

while ($bitext->next_alignment(\@src,\@trg)){
    print '';
}
