use strict;
use utf8;

use Test::More tests => 4;

use URI::Tag;

ok my $uri_tag = URI::Tag->new('http://www.yahoo.co.jp/');
$uri_tag->useragent('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; ja-jp) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16');
ok my $h1 = $uri_tag->h1;
is $h1, '<a href=s/52104><img src="http://k.yimg.jp/images/top/sp/ylogo_n.gif" alt="Yahoo! JAPAN" height="80" width="298" class="deco"></a>';
is $uri_tag->h1, '<a href=s/52104><img src="http://k.yimg.jp/images/top/sp/ylogo_n.gif" alt="Yahoo! JAPAN" height="80" width="298" class="deco"></a>';


__END__

