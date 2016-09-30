package UML::Item;

use strict;
use warnings;

use Carp;
use XML::LibXML;
use XML::LibXML::XPathContext;
use UML::TypeCache;

sub new
{
   my ( $class, $node, $pack_name ) = @_;

   my $xpc = XML::LibXML::XPathContext->new($node);
   my $self = bless { xpc => $xpc }, $class;

   UML::TypeCache->instance()->add($self);

   return $self;
}

sub xpc
{
   my ($self) = @_;

   $self->{xpc}->registerNs( 'uml', "http://schema.omg.org/spec/UML/1.3" );
   return $self->{xpc};
}

sub name
{
   my ( $self, $name ) = @_;

   if ( defined $name )
   {
      $self->{name} = $name;
   }
   elsif ( not exists $self->{name} )
   {
      $self->{name} = $self->xpc()->findvalue('@name');
   }

   return $self->{name};
}

sub comment
{
   my ($self) = @_;

   if ( not exists $self->{comment} )
   {
      $self->{comment} = $self->xpc()->findvalue('@comment');
   }

   return $self->{comment};
}

sub ID
{
   my ($self) = @_;

   if ( not exists $self->{xmi_id} )
   {
		eval
		{
      	$self->{xmi_id} = $self->xpc()->findvalue('@xmi.id');
		};
		confess $@ if $@;
   }

   return $self->{xmi_id};
}

=for comment

Implementation methods

=cut

sub get_uml_node_by_id
{
   my ( $self, $id ) = @_;

   my $xpath = sprintf( '//uml:*[@xmi.id = "%s"]', $id );

   my ($node) = $self->xpc()->findnodes($xpath);

   return $node;
}

sub get_node_attribute
{
   my ( $self, $node, $attr ) = @_;

   my $xpath = sprintf( '@%s', $attr );
   my $val = $self->xpc()->findvalue( $xpath, $node );

   return $val;
}

1;
