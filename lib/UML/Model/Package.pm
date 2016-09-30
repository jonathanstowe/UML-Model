package UML::Model::Package;

use strict;
use warnings;

use UML::Model::Item;
use UML::Model::Class;

use vars qw(@ISA);
@ISA = qw(UML::Model::Item);

sub new
{
   my ( $class, $package, $parent ) = @_;

   my $xpc = XML::LibXML::XPathContext->new($package);

   my $self = bless { xpc => $xpc }, $class;

	$self->parent($parent);

   $self->classes();    # cache the names;

   return $self;
}

sub inner_packages
{
	my ( $self ) = @_;

	if ( not exists $self->{inner_packages} )
	{
		$self->{inner_packages} = [];

		foreach my $package ( $self->xpc()->findnodes('uml:Namespace.ownedElement/uml:Package'))
		{
			push @{$self->{inner_packages} }, UML::Model::Package->new($package, $self->full_name() );
		}
	}
   return wantarray ? @{ $self->{inner_packages} } : $self->{inner_packages};
}

sub parent
{
	my ( $self, $parent ) = @_;

	if ( defined $parent ) 
	{
		$self->{parent} = $parent;
	}

	return $self->{parent};
}

sub full_name
{
	   my ($self) = @_;

		return $self->parent() ? join '::', ( $self->parent(), $self->name() ) : $self->name();
}

sub classes
{
   my ($self) = @_;

   if ( not exists $self->{classes} )
   {
      $self->{classes} = [];

      foreach my $class ( $self->xpc->findnodes('uml:Namespace.ownedElement/uml:Class') )
      {
         push @{ $self->{classes} }, UML::Model::Class->new( $class, $self->full_name() );
      }
   }

   return wantarray ? @{ $self->{classes} } : $self->{classes};
}

1;
