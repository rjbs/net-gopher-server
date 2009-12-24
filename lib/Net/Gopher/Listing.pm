package Net::Gopher::Listing;
use Moose;

has entities => (
  is  => 'ro',
  isa => 'ArrayRef[ Net::Gopher::Entity ]',
  required => 1,
);

sub as_string {
  my ($self) = @_;
  my $str = '';
  $str .= $_->as_listing_line for @{ $self->entities };

  return $str;
}

1;
