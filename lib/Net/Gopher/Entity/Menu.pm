package Net::Gopher::Entity::Menu;
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

  $str .= $_->as_menu_line for @{ $self->entities };
  $str .= ".\x0d\x0a";

  return $str;
}

1;
