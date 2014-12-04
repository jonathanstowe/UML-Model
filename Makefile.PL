use ExtUtils::MakeMaker;

WriteMakefile(
					NAME => 'UML',
					VERSION => '0.01',
					EXE_FILES => ['uml_generate']
				);

package MY;

sub postamble
{
	   return <<POST;
		
data_install ::
	\@\$(MKPATH) /opt/map/tools/generate
	\@\$(CP) *.tt /opt/map/tools/generate

POST
}

sub install
{
	my ( $self ) = @_;

	my $install = $self->SUPER::install();

	$install =~ s/^(install\s*::\s+.*)/$1 data_install/m;

	$install;
}

