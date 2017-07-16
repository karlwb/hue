use warnings;
use strict;
use Data::Dump;
use IO::Socket::Multicast;
use IO::Select;

sub discover_hue_bridge_ip {
    my $host = '239.255.255.250'; # ssdp ipv4 site-local addr
    my $port = 1900;
    my $hostport = "$host:$port";
    my $uuid_prefix = 'uuid:2f402f80-da50-11e1-9b23-';
    my $timeout = 60;
    
    my $sock = IO::Socket::Multicast->new(LocalPort=>$port, ReuseAddr=>1);
    my $io = new IO::Select;
    $io->add($sock);

    my $q = join("\r\n", ('M-SEARCH * HTTP/1.1',
			  "HOST: $hostport",
			  'MAN: "ssdp:discover"',
			  'MX: 120',
			  'ST: urn:schemas-upnp-org:device:basic:1',
			  ''));
    $sock->mcast_loopback(0);
    $sock->mcast_add($host);    
    $sock->mcast_send($q, $hostport);

    my $bridge = '';
    while ($io->can_read($timeout)) {
	my $msg = '';
	$sock->recv($msg, 1024);
	#print $msg . "\n\n";
	if ( $msg =~ /hue-bridgeid/ &&
	     $msg =~ /$uuid_prefix/ &&
	     $msg =~ m@LOCATION: http://([0-9.]+)@
	    )  {
	    $bridge = $1;
	    last;
	}
    }

    return $bridge;
}

dd discover_hue_bridge_ip;
