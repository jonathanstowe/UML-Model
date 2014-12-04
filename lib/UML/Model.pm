package UML::Model;

use strict;
use warnings;

use XML::LibXML;
use XML::LibXML::XPathContext;

use UML::Item;
use UML::DataType;
use UML::Package;

use vars qw(@ISA);
@ISA = qw(UML::Item);

$UML::NS = "http://schema.omg.org/spec/UML/1.3";

sub new
{
	my ( $class, $filename ) = @_;

	my $parser = XML::LibXML->new();

	my $doc = $parser->parse_file($filename);

	my $xpc = XML::LibXML::XPathContext->new($doc);

	$xpc->registerNs( 'uml', $UML::NS );

	my $self = bless {
							xpc => $xpc,
							doc => $doc,
							parser => $parser,
							filename => $filename
						  }, $class;

	$self->datatypes(); # cache the datatypes up front
	return $self;
}

sub datatypes
{
	my ( $self ) = @_;

	if (not exists $self->{datatypes})
	{
		$self->{datatypes} = [];

		foreach my $datatype ($self->xpc()->findnodes('//uml:DataType') )
		{
			push @{$self->{datatypes}}, UML::DataType->new($datatype);
		}
	}

	return wantarray ? @{$self->{datatypes}} : $self->{datatypes};
}

sub packages
{
	my ( $self ) = @_;

	if ( not exists $self->{packages} )
	{
		$self->{packages} = [];

		foreach my $package ($self->xpc()->findnodes('//uml:Model[@name = "Logical View"]/uml:Namespace.ownedElement/uml:Package[not(@stereotype) or @stereotype != "folder"]'))
		{
			my $p = UML::Package->new($package);

			push @{$self->{packages}}, $p;
		}
	}

	return wantarray ? @{$self->{packages}} : $self->{packages};
}

1;
