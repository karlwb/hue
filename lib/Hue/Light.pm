package Hue::Light;
use Modern::Perl;
use Moo;

has manufacturername => (is => 'ro');
has modelid => (is => 'ro');
has name => (is => 'rw');
has productid => (is => 'ro');
has state => (is => 'rw');
has swconfigid => (is => 'ro');
has swversion => (is => 'ro');
has type => (is => 'ro');
has uniqueid => (is => 'ro');
has id => (is => 'ro');
has bridge => (is => 'ro');
has url => (is => 'lazy');

sub _build_url {
    my $self = shift;
    join( '/', $self->bridge->url, 'lights', $self->id );
}

sub rename {
}

sub set_state {
}

1;
