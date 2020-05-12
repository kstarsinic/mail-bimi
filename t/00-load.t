#!perl -T
use 5.20.0;
use strict;
use warnings FATAL => 'all';
BEGIN { $ENV{MAIL_BIMI_CACHE_BACKEND} = 'Null' };
use Mail::BIMI::Pragmas;
use Test::More;

BEGIN {
    use_ok( 'Mail::BIMI' ) || print "Bail out! ";
    use_ok( 'Mail::BIMI::Record' ) || print "Bail out! ";
    use_ok( 'Mail::BIMI::Result' ) || print "Bail out! ";
}

diag( "Testing Mail::BIMI $Mail::BIMI::VERSION, Perl $], $^X" );

done_testing;
