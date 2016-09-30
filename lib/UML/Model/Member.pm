package UML::Member;

use strict;
use warnings;

use UML::Item;

use vars qw(@ISA);
@ISA = qw(UML::Item);

sub member_type
{
	my ( $self ) = @_;

	my $type;
	if ( $self->isa('UML::Attribute') )
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
