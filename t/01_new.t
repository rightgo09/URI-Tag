use strict;
use utf8;

use Test::More tests => 6;

use URI::Tag;

ok my $uri_tag1 = URI::Tag->new;
ok my $uri_tag2 = URI::Tag->new('http://google.com/');

ok ! $uri_tag1->uri;
ok my $uri2 = $uri_tag2->uri;
isa_ok $uri2, 'URI';
is $uri2, 'http://google.com/';


__END__

