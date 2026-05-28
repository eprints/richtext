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

	$frag->appendChild( $session->make_element( "script", src=> "/javascript/tinymce.min.js" ) );

	if( $self->get_property( "multiple" ) )
	{
		# This method will call initTinyMCE for each textarea rendered
		# not in a document.ready as document.ready doesn't call in AJAX contexts
		$frag->appendChild( $session->make_javascript( 'initMultipleTinyMCEs("' . $basename . '");' ) );
	}
	else
	{
		$frag->appendChild( $session->make_javascript( "document.addEventListener('DOMContentLoaded', (_) => { initTinyMCE('#$basename'); } );" ) );
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

sub get_property_defaults
{
	my( $self ) = @_;
	my %defaults = $self->SUPER::get_property_defaults;

	# Don't show the options to re-order richtext fields (as it is majorly broken)
	$defaults{input_ordered} = 0;

	return %defaults;
}

######################################################################
1;

=head1 COPYRIGHT AND LICENSE

=begin COPYRIGHT_AND_LICENSE

Copyright University of Southampton under the GNU Lesser General Public License. See https://github.com/eprints/richtext/README.md for further information.

Richtext ingredient is supplied by EPrints Services.

=end COPYRIGHT_AND_LICENSE
