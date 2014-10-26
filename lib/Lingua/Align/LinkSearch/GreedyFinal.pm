package Lingua::Align::LinkSearch::GreedyFinal;

use 5.005;
use strict;

use vars qw($VERSION @ISA);
@ISA = qw(Lingua::Align::LinkSearch::GreedyWellFormed);
$VERSION = '0.01';

use Lingua::Align::LinkSearch;


sub new{
    my $class=shift;
    my %attr=@_;

    my $self={};
    bless $self,$class;

    foreach (keys %attr){
	$self->{$_}=$attr{$_};
    }

    my $BaseSearch = $attr{-link_search} || 'greedy_final';
    $BaseSearch =~s/\_?[Ff]inal//;
    $attr{-link_search} = $BaseSearch;
    $self->{BASESEARCH} = new Lingua::Align::LinkSearch(%attr);

    # need to check wellformedness?
    if ($BaseSearch=~/well.*formed/i){
	$self->{-check_wellformedness}=1;
    }

    # for tree manipulation
    $self->{TREES} = new Lingua::Align::Corpus::Treebank();

    return $self;
}

sub search{
    my $self=shift;
    my ($linksST,$scores,$min_score,
	$src,$trg,
	$stree,$ttree,$linksTS)=@_;

    if (ref($linksTS) ne 'HASH'){$linksTS={};}

    # first do the base search algorithm
    $self->{BASESEARCH}->search($linksST,$scores,$min_score,
				$src,$trg,
				$stree,$ttree,$linksTS);

    # secondly: add remaining links for unlinked nodes
    #           (only if well-formed!)

    foreach my $n (sort {$$scores[$b] <=> $$scores[$a]} (0..$#{$scores})){
	last if ($$scores[$n] < $min_score);
	if (exists $$linksST{$$src[$n]}){
#	    next if (exists $$linksST{$$src[$n]}{$$trg[$n]});
#	    print STDERR "final: linked already ($$src[$n] & $$trg[$n])\n";
	    next if (exists $$linksTS{$$trg[$n]});
	}

	if ($self->{-check_wellformedness}){
	    if (not $self->{BASESEARCH}->is_wellformed($stree,$ttree,
						       $$src[$n],$$trg[$n],
						       $linksST)){
		next;
	    }
	}
#	if ($self->is_wellformed($stree,$ttree,$$src[$n],$$trg[$n],$linksST)){
#	if ($self->{BASESEARCH}->is_wellformed($stree,$ttree,
#					       $$src[$n],$$trg[$n],$linksST)){

#	print STDERR "final: add link between $$src[$n] & $$trg[$n]\n";
	$$linksST{$$src[$n]}{$$trg[$n]}=$$scores[$n];
	$$linksTS{$$trg[$n]}{$$src[$n]}=$$scores[$n];

#	}
#	else{
#	    print STDERR "final: not well-formed, skip $$src[$n] & $$trg[$n]\n";
#	}
    }
    return 1;
}


1;
__END__

=head1 NAME

YADWA - Perl modules for Yet Another Discriminative Word Aligner

=head1 SYNOPSIS

  use YADWA;

=head1 DESCRIPTION

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Joerg Tiedemann, E<lt>j.tiedemanh@rug.nl@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Joerg Tiedemann

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
