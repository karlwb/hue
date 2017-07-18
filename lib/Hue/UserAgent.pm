package Hue::UserAgent;
use Modern::Perl;
use Mojo::UserAgent;
use Moo::Role;

sub _ua { state $o = Mojo::UserAgent->new }

sub _headers { state $o = { Accept => '*/*' } }

sub __req {
    my $self = shift;
    my $method = shift;
    my $url  = shift;
    my $data = shift;
    my $tx = $data ? $self->_ua->$method($url => $self->_headers => json => $data)
 	           : $self->_ua->$method($url => $self->_headers);
    $tx->result->json;

}

sub _get { shift->__req('get', @_) }
sub _post { shift->__req('post', @_) }
sub _put { shift->__req('put', @_) }
sub _delete { shift->__req('delete', @_) }


1;
