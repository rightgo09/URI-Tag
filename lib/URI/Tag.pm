package URI::Tag;

# $Id$

use strict;
use warnings;
use base qw/ Class::Accessor::Fast /;
use Carp qw/ croak /;

our $VERSION = '0.01';

use URI;
use LWP::UserAgent;

__PACKAGE__->mk_accessors(qw/ uri useragent _html _title _h1 /);

sub new {
	my ($class, $uri) = @_;
	my $self = bless {}, $class;
	if (defined $uri) {
		if (ref($uri) eq 'URI') {
			$self->uri($uri);
		}
		else {
			$self->uri(URI->new($uri));
		}
	}
	$self->useragent("URI::Tag/$VERSION");
	return $self;
}

sub title {
	my $self = shift;
	if (ref($self) ne __PACKAGE__) {
		$self = __PACKAGE__->new(@_);
	}
	croak "URI is must be specified." unless $self->uri;
	return $self->_title if $self->_title;
	if (!$self->_html) {
		$self->_html($self->html);
	}
	$self->_html =~ m|<title.*?>(.*?)</title>|im;
	$self->_title($1);
	return $self->_title;
}
sub html {
	my $self = shift;
	my $ua = LWP::UserAgent->new(
		agent   => "URI::Tag/$VERSION",
		timeout => 60,
	);
	$ua->env_proxy;
	my $res = $ua->get($self->uri);
	unless ($res->is_success) {
		croak "fetch html failed.[".$res->status_line."]";
	}
	return $res->content;
}


1;
__END__

