package UML::Model::Class;

use strict;
use warnings;

use UML::Model::Item;
use UML::Model::TypeCache;
use UML::Model::Attribute;
use UML::Model::Operation;
use UML::Model::Generalization;

use vars qw(@ISA);
@ISA = qw(UML::Model::Item);

our $DEBUG = 0;

sub new
{
   my ( $class, $node, $pack_name ) = @_;

   my $xpc = XML::LibXML::XPathContext->new($node);
   my $self = bless { xpc => $xpc, package => $pack_name }, $class;

   my $tc = UML::Model::TypeCache->instance();

   $tc->add($self);

   return $self;
}

sub members
{
   my ($self) = @_;

   if ( not exists $self->{members} )
   {
      $self->{members} = [];

      foreach my $member ( $self->xpc()->findnodes('uml:Classifier.feature/*') )
      {
         my $type = $self->xpc()->findvalue( 'local-name()', $member );

         if ( $type eq 'Attribute' )
         {
            push @{ $self->{members} }, UML::Model::Attribute->new($member);
         }
         elsif ( $type eq 'Operation' )
         {
            push @{ $self->{members} }, UML::Model::Operation->new($member);
         }
         else
         {
            next;
         }
      }
   }

   return wantarray ? @{ $self->{members} } : $self->{members};

}

sub relations
{
   my ($self) = @_;


   if ( not exists $self->{relations} )
   {
	   my %seen;
      $self->{relations} = [];

      foreach my $rel (
                $self->xpc()->findnodes(
                   'uml:GeneralizableElement.generalization/uml:Generalization')
        )
      {
			# print "ME: ", $self->full_name(),"\n";

         my $gen = UML::Model::Generalization->new($rel);
			# stop duplicates
         # stop it croaking when we have a weird type
			if ( defined $gen->parent() )
			{
				my $pname = $gen->parent()->can('full_name') ? 
				            $gen->parent()->full_name() : $gen->parent()->name();

				if (not $seen{$pname}++)
				{
         		push @{ $self->{relations} }, $gen;
				}
			}
			else
			{
				print "ME: ", $self->full_name(),"\n";
			}
      }
   }

   return wantarray ? @{ $self->{relations} } : $self->{relations};
}

sub composed_types
{
	my ( $self) = @_;

	print STDERR "composed_types for : ", $self->name(),"\n" if $DEBUG;
	if ( not exists $self->{composed_types} )
	{
		$self->{composed_types} = [];

		foreach my $member ( $self->members() )
		{
			print STDERR "member : ", $member->name(),"\n" if $DEBUG;
			my $tc = UML::Model::TypeCache->instance();
			my $typeid;

			if ( $member->isa('UML::Model::Attribute') )
			{
				$typeid = $member->typeID();
			}
			elsif ( $member->isa('UML::Model::Operation'))
			{
				if ( my $rt = $member->return_type() )
				{
					$typeid = $rt->typeID();
				}
			}
			else
			{
				next;
			}

			if ( $typeid )
			{
				my $type = $tc->lookup_object($typeid);

				if ( $type && $type->isa('UML::Model::Class'))
				{
					push @{$self->{composed_types}}, $type;
				}
			}
		}
	}

   return wantarray ? @{ $self->{composed_types} } : $self->{composed_types};
}

sub package
{
   my ($self) = @_;

   if ( not defined $self->{package} )
   {
      my $pack_name =
        $self->xpc()
        ->findvalue(
            '//uml:Package[uml:Class[@name = "' . $self->name() . '"]]/@name' );
      $self->{package} = $pack_name;
   }
   return $self->{package};
}

sub inner_classes
{
   my ($self) = @_;

   if ( not exists $self->{inner_classes} )
   {
      $self->{inner_classes} = [];

      foreach my $class ($self->xpc()->findnodes('uml:Namespace.ownedElement/uml:Class') )
      {
			my $inner_class = UML::Model::Class->new( $class, $self->full_name() );
         push @{ $self->{inner_classes} }, $inner_class, $inner_class->inner_classes();
      }
   }
   return wantarray ? @{ $self->{inner_classes} } : $self->{inner_classes};
}

	
sub full_name
{
   my ($self) = @_;

   return join '::', ( $self->package(), $self->name() );
}

1;

