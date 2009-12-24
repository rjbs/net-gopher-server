use strict;
use warnings;
use Test::More;

our $QUERY;
our $REPLY;

{
  package Test::Gopherd;
  use base 'Net::Gopher::Server';
  sub _read_input_line { return $QUERY };
  sub _reply { $REPLY = $_[1] };

  sub entity_for {
    my ($self, $request) = @_;
    return $self->SUPER::entity_for($request) if length $request;
    return Net::Gopher::Listing->new({
      entities => [
        Net::Gopher::Entity->new({
          type_code   => 1,
          description => 'Totally Important Stuff',
          path        => 'README.1ST',
          host        => 'localhost',
          port        => 70,
        }),
        Net::Gopher::Entity->new({
          type_code   => 1,
          description => 'not really important whatevers',
          path        => 'README.LST',
          host        => 'localhost',
          port        => 70,
        }),
      ],
    });
  }
}

sub gopher {
  $QUERY = shift;
  Test::Gopherd->process_request;
  my $reply = $REPLY;
  undef $QUERY;
  undef $REPLY;
  return $reply;
}

diag gopher('');
