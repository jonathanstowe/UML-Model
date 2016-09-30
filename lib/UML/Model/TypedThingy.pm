package UML::TypedThingy;

use strict;
use warnings;

use UML::Item;
use UML::TypeCache;

use vars qw(@ISA);
@ISA = qw(UML::Item);

sub type
{
   my ($self) = @_;

   my $tc = UML::TypeCache->instance();

   if ( not defined $self->{type} )
   {
      $self->{type} = $tc->lookup( $self->typeID() );
   }

   return $self->{type};
}

sub typeID
{
   my ($self) = @_;

   if ( not defined $self->{type_id} )
   {
      $self->{type_id} = $self->xpc()->findvalue('@type');
   }

   return $self->{type_id};
}

1;
