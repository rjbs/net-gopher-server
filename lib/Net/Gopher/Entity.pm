package Net::Gopher::Entity;
use Moose;

use namespace::autoclean;

has type_code => (
  is  => 'ro',
  isa => 'Str', # 1 char
  required => 1,
);

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

sub as_listing_line {
  my ($self) = @_;
  return sprintf "%s%s\t%s\t%s\t%s\x0d\x0a",
    map {; $self->$_ } qw(type_code description path host port);
}

sub as_string { shift->as_listing_line }

1;
