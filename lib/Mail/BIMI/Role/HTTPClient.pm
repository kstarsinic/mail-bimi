package Mail::BIMI::Role::HTTPClient;
# ABSTRACT: Class to model a DNS resolver
# VERSION
use 5.20.0;
use Moo::Role;
use Mail::BIMI::Pragmas;
use HTTP::Tiny::Paranoid;
  has http_client => ( is => 'rw', lazy => 1, builder => '_build_http_client',
    documentation => 'HTTP::Tiny::Paranoid (or similar) object used for HTTP operations' );
  has http_client_response => ( is => 'rw',
    documentation => 'HTTP Response as returned by client' );
  requires 'http_client_max_fetch_size';

{
  my $http_client;
  sub _build_http_client($self) {
    return $http_client if $http_client;
    my $agent = 'Mail::BIMI ' . ( $Mail::BIMI::Version // 'dev' );
    $http_client = HTTP::Tiny::Paranoid->new(
      agent => $agent,
      max_size => $self->http_client_max_fetch_size,
      timeout => $self->bimi_object->OPT_HTTP_CLIENT_TIMEOUT,
      verify_SSL => 1,     # Certificates MUST verify
    );
    return $http_client;
  }
}

=method I<http_client_get($url)>

Issue a get request for $url

Returns the response content and sets http_client_response

=cut

sub http_client_get($self,$url) {
  my $response = $self->http_client->get($url);
  $self->http_client_response($response);
  return $response->{content};
}

1;
