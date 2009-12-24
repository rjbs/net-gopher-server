package Net::Gopher::Entity::Directory;
use Moose;

has entities => (
  is  => 'ro',
  isa => 'ArrayRef[ Net::Gopher::Entity ]',
  required => 1,
);

sub type_code { '0' }

sub as_response {
  my ($self) = @_;
  my $str = '';
  $str .= $_->as_directory_line for @{ $self->entities };

  return $str;
}

1;
