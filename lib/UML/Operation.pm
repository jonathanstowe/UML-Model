package UML::Operation;

use strict;
use warnings;

use UML::Member;
use UML::Parameter;
use UML::ReturnType;

use vars qw(@ISA);
@ISA = qw(UML::Member);

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
      	$self->{_return} = UML::ReturnType->new($rt);
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
         push @{ $self->{parameters} }, UML::Parameter->new($param);
      }
   }

   return wantarray ? @{ $self->{parameters} } : $self->{parameters};
}

1;
