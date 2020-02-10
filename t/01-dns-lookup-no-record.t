#!perl
use 5.20.0;
use strict;
use warnings FATAL => 'all';
use lib 't';
use Mail::BIMI::Pragmas;
use Test::More;
use Mail::BIMI;
use Mail::BIMI::Record;
use Mail::DMARC::PurePerl;
use Net::DNS::Resolver::Mock;

my $bimi = Mail::BIMI->new;

my $resolver = Net::DNS::Resolver::Mock->new;
$resolver->zonefile_read('t/zonefile');
$bimi->resolver($resolver);

my $dmarc = Mail::DMARC::PurePerl->new;
$dmarc->result->result( 'pass' );
$dmarc->result->disposition( 'reject' );
$bimi->dmarc_object( $dmarc->result );

$bimi->domain( 'gallifreyburning.org' );
$bimi->selector( 'foobar' );

my $record = $bimi->record;

is_deeply(
    [ $record->is_valid(), $record->error() ],
    [ 0, ['no BIMI records found'] ],
    'Test record does not validate'
);

my $result = $bimi->result;
my $auth_results = $result->get_authentication_results;
my $expected_result = 'bimi=none (Domain is not BIMI enabled)';
is( $auth_results, $expected_result, 'Auth results correcct' );

done_testing;
