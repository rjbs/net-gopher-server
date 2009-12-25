use strict;
use warnings;
package Net::Gopher::Server;
# ABSTRACT: a simple gopher server

use Net::Gopher::Entity::Generic;

use Package::Generator;
use Sub::Exporter -setup => {
  collectors => [ '-run' => \'_run_server' ]
};

my %already;
sub _run_server {
  my ($class, $value) = @_;
  $value ||= {};

  my %config = %$value;

  $config{port} ||= 70;

  my $pkg = $class;
  if (my $isa = delete $config{isa}) {
    eval "require $isa; 1" or die;
    $pkg = $already{ $class, $isa } ||= Package::Generator->new_package({
      base => $class,
      isa  => [ $class, $isa ],
    });
  }

  my $server = $pkg->new(%config);
  $server->run;
}

=head1 SYNOPSIS

  use Net::Gopher::Server -setup;
  __PACKAGE__->run;

That's it!  You might need to run with privs, since by default it will bind to
port 70.

You can also:

  use Net::Gopher::Server -setup => { port => 1170 };
  __PACKAGE__->run;

...if you want.

Actually, both of these are sort of moot unless you also provide an C<isa>
argument, which sets the base class for the created server.
Net::Gopher::Server is, for now, written to work as a Net::Server subclass.

=head1 DESCRIPTION

How can there be no F<Gopher> server on the CPAN in 2008?  Probably because
there wasn't one in 1996, and by then it was already too late.  (Was there even
a CPAN?  Barely.)  Gopher might be dead, but it's fun for playing around.

Right now Net::Gopher::Server uses L<Net::Server>, but that might not last.
Stick to the documented interface.

Speaking of the documented interface, you'll almost certainly want to subclass
Net::Gopher::Server to make it do something useful.

=cut

sub entity_for {
  my ($self, $request) = @_;

  return $self->unknown_reply;
}

sub unknown_reply {
  my ($self) = @_;

  return Net::Gopher::Entity::Generic->new({
    type_code   => 3,
    description => 'no such resource',
    content     => 'no such resource',
    path        => '',
    host        => '',
    port        => 70,
  });
}

sub _read_input_line { return scalar <STDIN> }

sub _reply { print $_[1] }

sub process_request {
  my ($self) = @_;
  my $path = $self->_read_input_line;

  $path =~ s/\x0d\x0a\z//;
  my $entity = $self->entity_for($path);

  $self->_reply( $entity->as_response );

  return;
}

1;
