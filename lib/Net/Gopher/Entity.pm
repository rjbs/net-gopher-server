package Net::Gopher::Entity;
use Moose::Role;

use namespace::autoclean;

requires 'as_response';

requires 'type_code';

has [ qw(description path host) ] => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has port => (
  is  => 'ro',
  isa => 'Int',
  required => 1,
);

sub as_menu_line {
  my ($self) = @_;

  my $type_code = $self->type_code;

  Carp::cluck "illegal type code: '$type_code'"
    unless defined $type_code and length $type_code == 1;

  return sprintf "%s%s\t%s\t%s\t%s\x0d\x0a",
    $type_code,
    map {; $self->$_ } qw(description path host port);
}

1;
