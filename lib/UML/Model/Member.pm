package UML::Model::Member;

use strict;
use warnings;

use UML::Model::Item;

use vars qw(@ISA);
@ISA = qw(UML::Model::Item);

sub member_type
{
	my ( $self ) = @_;

	my $type;
	if ( $self->isa('UML::Model::Attribute') )
	{
		$type = 'Attribute';
	}
	else
	{
		$type = 'Operation';
	}
	return $type;
}

1;
