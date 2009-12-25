package Net::Gopher::Entity::Generic;
use Moose;

has type_code => (
  is  => 'ro',
  isa => 'Str', # 1 char
  required => 1,
);

with 'Net::Gopher::Entity';

has is_dot_terminated => (
  is   => 'ro',
  isa  => 'Bool',
  lazy => 1,
  default => sub {
    my ($self) = @_;
    return not($self->type_code =~ /\A[59]\z/);
  },
);

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
  my $str = $STUPID_CALLBACK_FOR{ $ref }->( $content );
  $str .= "\x0d\x0a" unless $str =~ /\x0d\x0a\z/;
  return($str . ($self->is_dot_terminated ? ".\x0d\x0a" : ''));
}

1;
