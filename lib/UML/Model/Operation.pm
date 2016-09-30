package UML::Model::Operation;

use strict;
use warnings;

use UML::Model::Member;
use UML::Model::Parameter;
use UML::Model::ReturnType;

use vars qw(@ISA);
@ISA = qw(UML::Model::Member);

sub return_type
{
   my ($self) = @_;

   if ( not exists $self->{_return} )
   {
      my ($rt) =
        $self->xpc()
        ->findnodes(
             'uml:BehavioralFeature.parameter/uml:Parameter[@kind = "return"]');

		if (defined $rt)
		{
      	$self->{_return} = UML::Model::ReturnType->new($rt);
		}
   }

   return $self->{_return};
}

sub parameters
{
   my ($self) = @_;

   if ( not exists $self->{parameters} )
   {
      $self->{parameters} = [];

      foreach my $param (
         $self->xpc()->findnodes(
'uml:BehavioralFeature.parameter/uml:Parameter[not(@kind) or @kind != "return"]'
         )
        )
      {
         push @{ $self->{parameters} }, UML::Model::Parameter->new($param);
      }
   }

   return wantarray ? @{ $self->{parameters} } : $self->{parameters};
}

1;
