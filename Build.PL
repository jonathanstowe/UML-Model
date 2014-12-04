#!perl
#
use strict;
use warnings;

use Module::Build;

my @attributes = (
                   module_name   => 'UML::Model',
                   dist_author   => 'Jonathan Stowe <jns@gellfish.co.uk>',
                   dist_version_from   => 'lib/UML/Model.pm',
                   dist_abstract => 'Parse UML files and generate classes',
                   dist_version  => '0.01',
                   license => 'perl',
                   share_dir  => [qw(share)],
                   create_makefile_pl  => 'traditional',
                   requires   => {
                      'XML::LibXML' => undef,
                      'XML::LibXML::XPathContext'  => undef,
                      'Template' => undef,
                      'IO::File' => undef,
                      'File::Path'  => undef,
                      'File::Spec'  => undef,
                      'File::ShareDir' => undef,
                      'File::HomeDir'  => undef,
                      'Path::Class' => undef,
                   },
                   release_status   => 'unstable',
                   script_files  => 'bin',
                   meta_merge         => {
                     resources => { repository => 'https://github.com/jonathanstowe/UML-Model' }
                   },
                 );

my $builder = Module::Build->new(@attributes);

$builder->create_build_script();
