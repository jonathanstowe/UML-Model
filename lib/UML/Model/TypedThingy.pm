package UML::Model::TypedThingy;

use strict;
use warnings;

use UML::Model::Item;
use UML::Model::TypeCache;

use vars qw(@ISA);
@ISA = qw(UML::Model::Item);

sub type
{
   my ($self) = @_;

   my $tc = UML::Model::TypeCache->instance();

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
