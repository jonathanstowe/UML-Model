package UML::Model::Generalization;

use strict;
use warnings;

use UML::Model::Item;
use UML::Model::TypeCache;

use vars qw(@ISA);
@ISA = qw(UML::Model::Item);

sub new
{
   my ( $class, $node, $pack_name ) = @_;

   my $xpc = XML::LibXML::XPathContext->new($node);
   my $self = bless { xpc => $xpc }, $class;

   return $self;
}

sub link_node
{
   my ($self) = @_;

   if ( not exists $self->{link_node} )
   {
      $self->{link_node} = $self->get_uml_node_by_id( $self->idref() );
   }

   return $self->{link_node};
}

sub parent_id
{
   my ($self) = @_;

   if ( not exists $self->{parent_id} )
   {
      $self->{parent_id} =
        $self->get_node_attribute( $self->link_node(), 'parent' );
   }

   return $self->{parent_id};
}

sub idref
{
   my ($self) = @_;

   if ( not defined $self->{idref} )
   {
      $self->{idref} = $self->xpc()->findvalue('@xmi.idref');
   }

   return $self->{idref};
}

sub parent
{
   my ($self) = @_;

   if ( not exists $self->{_parent} )
   {
      $self->{_parent} =
        UML::Model::TypeCache->instance()->lookup_object( $self->parent_id() );

   }
	if ( $self->{_parent} )
	{
		# print "Parent:" , $self->{_parent}->full_name(),"\n";
	}
	else
	{
		print "failed to find ", $self->parent_id(),"\n";
	}

   return $self->{_parent};
}

1;
