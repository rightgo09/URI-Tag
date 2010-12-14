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
	$self->get_html;
	$self->_html =~ m{<title.*?>(.*?)(?:</title>|</head>)}im;
	$self->_title($1);
	return $self->_title;
}
sub get_html {
	my $self = shift;
	if (!$self->_html) {
		$self->_html($self->html);
	}
}
sub html {
	my $self = shift;
	my $ua = LWP::UserAgent->new(
		agent   => $self->useragent,
		timeout => 60,
	);
	$ua->env_proxy;
	my $res = $ua->get($self->uri);
	unless ($res->is_success) {
		croak "fetch html failed.[".$res->status_line."]";
	}
	return $res->content;
}

sub h1 {
	my $self = shift;
	if (ref($self) ne __PACKAGE__) {
		$self = __PACKAGE__->new(@_);
	}
	croak "URI is must be specified." unless $self->uri;
	return $self->_h1 if $self->_h1;
	$self->get_html;
	if ($self->_html =~ m{<h1.*?>(.*?)</h1>}im) {
		$self->_h1($1);
	}
#	elsif ($self->_html =~ m{<h1.*?>((?:<([^/]+?) ?.*?>.*?</\2>)*?)<[^/]+?>}mi) {
#		warn $1;
#	}
	return $self->_h1;
}


1;
__END__

