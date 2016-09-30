package UML::TypeCache;

use strict;
use warnings;

use Class::Singleton;
use vars qw(@ISA);
@ISA = qw(Class::Singleton);

sub add
{
   my ( $self, $object ) = @_;

   $self->{_Cache_}->{ $object->ID() } = $object;
}

sub lookup
{
   my ( $self, $id ) = @_;

   if ( not exists $self->{_Cache_}->{$id} )
   {
      return '';
   }

   my $object = $self->{_Cache_}->{$id};

   my $name =
     $object->can('full_name') ? $object->full_name() : $object->name();

   return $name;
}

sub lookup_object
{
   my ( $self, $id ) = @_;

   return $self->{_Cache_}->{$id};
}

1;

