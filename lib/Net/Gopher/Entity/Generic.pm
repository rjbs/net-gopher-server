package Net::Gopher::Entity::Generic;
use Moose;

has type_code => (
  is  => 'ro',
  isa => 'Str', # 1 char
  required => 1,
);

with 'Net::Gopher::Entity';

has content => (
  is  => 'ro',
  # isa => 'Str', # str, strref, code
  required => 1,
);

my %STUPID_CALLBACK_FOR = (
  ''       => sub { $_[0] },
  'SCALAR' => sub { ${ $_[0] } },
  'CODE'   => sub { $_[0]->()  },
);

sub as_response {
  my ($self) = @_;

  my $content = $self->content;
  my $ref = ref $content;
  return $STUPID_CALLBACK_FOR{ $ref }->( $content );
}

1;
