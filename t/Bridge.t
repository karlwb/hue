use Modern::Perl;
use Test::More;
use Test::MockModule;
use Data::Dump;

subtest import => sub {
    require_ok 'Hue::Bridge';
    use_ok 'Hue::Bridge';
};

subtest create => sub {
   SKIP: {
      skip "developer test",  1, unless $ENV{DEVELOPER_TEST};
      subtest upnp_discovery => sub {
	  my $o = Hue::Bridge->new(user=>'testuser');
	  is defined($o->host), 1, 'upnp: host';
      };
    }
    
    subtest env_vars => sub {
	$ENV{HUE_USER} = 'testuser';
	$ENV{HUE_HOST} = '10.10.10.10';
	my $o = Hue::Bridge->new;
	is $o->url, 'http://10.10.10.10/api/testuser', 'env';
    };

    subtest explicit_args => sub {
	my $o = Hue::Bridge->new(user=>'testuser', host=>'10.10.10.10');
	is $o->url, 'http://10.10.10.10/api/testuser', 'explicit';
    };

    subtest fail => sub {
	my $upnp = Test::MockModule->new('Hue::Bridge');
	$upnp->mock('discover_bridge' => sub{undef});

	delete $ENV{HUE_HOST};	
	delete $ENV{HUE_USER};

	eval { my $o = Hue::Bridge->new(user=>'test'); };
	like $@, qr/host is undef/, 'fail: host missing';

	eval { my $o = Hue::Bridge->new(host=>'10.10.10.10') };
	like $@, qr/user is undef/, 'fail: user missing';

	eval { my $o = Hue::Bridge->new };
	is defined($@), 1, 'fail: user & host missing';
    };
};


done_testing;


