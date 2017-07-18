package Hue::Bridge;
use Modern::Perl;
use Hue::UPNP;
use Hue::Light;
use Moo;
with ('Hue::UserAgent');

has host => (is => 'lazy');
has user => (is => 'lazy');
has url => (is => 'lazy');

sub _build_host { Hue::UPNP->discover_bridge }
sub _build_user { $ENV{HUE_USER} }

sub _build_url {
    my $self = shift;
    return 'http://' . join('/', $self->host, 'api', $self->user);
}

use Data::Dump;

sub get_lights {
    my $self = shift;
    my $matching = shift;
    my $res = $self->_get(join('/', $self->url, 'lights'));

    my @lights = ();
    foreach my $id (sort {$a <=> $b} keys %{$res}) {
	my %data = %{$res->{$id}};
	my $keep = 1;
	if ($matching) {
	    if ($data{name} !~ m/$matching/i) {
		$keep = 0;
	    }
	}
	push @lights, Hue::Light->new(%data, id=>$id, bridge=>$self) if $keep;
    }
    return @lights;
}

sub get_light {
}

sub set_light_attrs {
}

sub set_light_state {
}

sub delete_light {
}

sub search_for_lights {
}

sub found_lights {
}


sub get_groups {
}

sub get_group {
}

sub set_group_attrs {
}

sub set_group_state {
}

sub get_schedules {
}

sub get_schedule {
}

sub set_schedule {
}

sub delete_schedule {
}

sub get_scenes {
}

sub get_scene {
}

sub set_scene {
}

sub delete_scene {
}

sub get_sensors {
}

sub get_sensor {
}



sub get_rules {
}

sub get_rule {
}



sub create_user {
}

sub delete_user {
}

sub get_config {
}

sub set_config {
}

1;
