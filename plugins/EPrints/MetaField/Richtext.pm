######################################################################
#
# EPrints::MetaField::Richtext;
#
######################################################################
#
#
######################################################################

=pod

=head1 NAME

B<EPrints::MetaField::Richtext> - no description

=head1 DESCRIPTION

not done

=over 4

=cut

package EPrints::MetaField::Richtext;

use strict;
use warnings;

BEGIN
{
	our( @ISA );

	@ISA = qw( EPrints::MetaField::Longtext );
}

use EPrints::MetaField::Longtext;

#returns a longtext field without TinyMCY initialisation to allow custom TinyMCE initalisation
sub render_longtext
{
	my( $self, $session, $value, $dataset, $staff, $hidden_fields, $obj, $basename ) = @_;

        my $frag = $self->SUPER::render_input_field_actual( @_[1..$#_] );
}

sub render_input_field_actual
{
	my( $self, $session, $value, $dataset, $staff, $hidden_fields, $obj, $basename ) = @_;

	my $frag = $self->SUPER::render_input_field_actual( @_[1..$#_] );

	#$frag->appendChild( $session->make_element( "script", src => "//code.jquery.com/jquery-1.12.4.js" ) );
	$frag->appendChild( $session->make_element( "script", src=> "/javascript/tinymce.min.js" ) );

	if( $self->get_property( "multiple" ) )
	{
		# This method will call initTinyMCE for each textarea rendered
		# not in a document.ready as document.ready doesn't call in AJAX contexts
		$frag->appendChild( $session->make_javascript( 'initMultipleTinyMCEs("' . $basename . '");' ) );
	}
	else
	{
		$frag->appendChild( $session->make_javascript( 'jQuery( document ).ready(function($){ initTinyMCE("#' . $basename .'"); } );' ) );
	}

	return $frag;
}

sub render_single_value
{
	my( $self, $session, $value, $obj ) = @_;

	if( !defined $value ) { return $session->make_doc_fragment; }

	my $body = eval
	{
		my $dom = XML::LibXML->load_html(
			string => $value
		);

		my @nodelist = $dom->getElementsByTagName("body");
		return $nodelist[0];
	};

	# If you have non-richtext encoded characters like & here, can cause LibXML to fail and a 500 error
	# so catch this and just render plaintext
	if( $@ )
	{
		print STDERR "Exception trying to render richtext for $value: $@\n";
		return $session->make_text( $value );
	}

        return $body;
}

######################################################################
1;

=head1 COPYRIGHT

=for COPYRIGHT BEGIN

Copyright 2019 University of Southampton.
EPrints 3.4 is supplied by EPrints Services.

This software may be used with permission and must not be redistributed.
http://www.eprints.org/eprints-3.4/

=for COPYRIGHT END

=for LICENSE BEGIN

This file is part of EPrints 3.4 L<http://www.eprints.org/>.

EPrints 3.4 and this file are released under the terms of the
GNU Lesser General Public License version 3 as published by
the Free Software Foundation unless otherwise stated.

EPrints 3.4 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with EPrints 3.4.
If not, see L<http://www.gnu.org/licenses/>.

=for LICENSE END

