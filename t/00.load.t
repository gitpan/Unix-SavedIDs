use Test::More tests => 1;


@INC = ('./blib/lib','./blib/arch');

BEGIN {
use_ok( 'Unix::SavedIDs' );
}

diag( "Testing Unix::SavedIDs $Unix::SavedIDs::VERSION" );
