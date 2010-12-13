package URI::Tag;

# $Id$

use strict;
use warnings;
use base qw/ Class::Accessor::Fast /;
use Carp qw/ croak /;

our $VERSION = '0.01';

use URI;
use LWP::Simple qw/ get /;
use LWP::UserAgent;

__PACKAGE__->mk_accessors(qw/ uri _html _title /);

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
	$self->_html =~ m|<title>(.*?)</title>|im;
	$self->_title($1);
	return $self->_title;
}
sub html {
	my $self = shift;
	my $ua = LWP::UserAgent->new;
	$ua->agent("URI::Tag/$VERSION");
	my $req = HTTP::Request->new;
	$req->method('GET');
	$req->uri($self->uri);
	my $res = $ua->request($req);
	unless ($res->is_success) {
		croak "fetch html failed.[".$res->status_line."]";
	}
	return $res->content;
}


1;
__END__

