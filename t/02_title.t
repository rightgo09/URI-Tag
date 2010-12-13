use strict;
use utf8;

use Test::More tests => 4;

use URI::Tag;

ok my $uri_tag = URI::Tag->new('http://google.com/');
ok my $title = $uri_tag->title;
is $title, 'Google';
is $uri_tag->title, 'Google';


__END__

