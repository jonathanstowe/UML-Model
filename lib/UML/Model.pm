package UML::Model;

use strict;
use warnings;

use Moose;
extends qw(
            UML::Moose::Item
          );

use XML::LibXML;
use XML::LibXML::XPathContext;

use UML::Model::DataType;
use UML::Model::Package;


has ns   => (
               is => 'rw',
               isa   => 'Str',
               default => "http://schema.omg.org/spec/UML/1.3",
            );

has filename   => (
                     is => 'rw',
                     isa   => 'Str',
                  );


has parser  =>  (
                  is => 'rw',
                  isa   => 'XML::LibXML',
                  lazy  => 1,
                  builder  => '_get_parser',
                  handles  => [qw(parse_file)],
                );
               
sub _get_parser
{
    my ( $self ) = @_;

    require XML::LibXML;
    my $parser = XML::LibXML->new();
    return $parser;
}

has doc  => (
               is => 'rw',
               isa   => 'XML::LibXML::Document',
               lazy  => 1,
               builder  => '_get_doc',
            );

sub _get_doc
{
    my ( $self ) = @_;

    my $doc = $self->parse_file($self->filename());
}

has xpc  => (
               is => 'rw',
               isa   => 'XML::LibXML::XPathContext',
               lazy  => 1,
               builder  => '_get_xpc',
               handles  => [qw(findnodes)],
            );

sub _get_xpc
{
    my ( $self ) = @_;

    require XML::LibXML::XPathContext;
	my $xpc = XML::LibXML::XPathContext->new($self->doc());
	$xpc->registerNs( 'uml', $self->ns() );
    return $xpc;
}

has datatypes  => (
                     is => 'ro',
                     isa   => 'ArrayRef',
                     lazy  => 1,
                     auto_deref  => 1,
                     builder => '_get_datatypes',
                  );

sub _get_datatypes
{
   my ($self) = @_;

   my $datatypes = [];

   foreach my $datatype ( $self->findnodes('//uml:DataType') )
   {
      push @{$datatypes} , UML::Model::DataType->new($datatype);
   }
   return $datatypes;
}


has packages   => (
                     is => 'rw',
                     isa   => 'ArrayRef',
                     lazy  => 1,
                     auto_deref  => 1,
                     builder  => '_get_packages',
                  );
sub _get_packages
{
   my ($self) = @_;

   my $packages = [];

   my $q = '//uml:Model[@name = "Logical View"]/uml:Namespace.ownedElement/uml:Package[not(@stereotype) or @stereotype != "folder"]';

   foreach my $package ( $self->findnodes( $q ))
   {
      my $p = UML::Model::Package->new($package);

      push @{$packages}, $p;
   }

   returm $packages;
}

1;
