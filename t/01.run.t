
use strict;
use Test::More;
use Unix::SavedIDs;
use warnings;
use Data::Dumper;

if ( $< != 0 ) {
	plan skip_all => "Only root can change user, so please run these tests as root.";
}
else {
	plan tests => 24;
}

my @uids = eval { getresuid() };
ok ( !$@ , "getresuid didn't crash" ) || diag($@); 
ok ( @uids == 3 , "returned 3 elem array" ) || diag(Dumper(\@uids)); 
ok ( $uids[0] == 0, 'ruid is 0' ) || diag("ruid is ".$uids[0]);
ok ( $uids[1] == 0, 'euid is 0' ) || diag("euid is ".$uids[1]);
ok ( $uids[2] == 0, 'suid is 0' ) || diag("suid is ".$uids[2]);

my @gids = eval { getresgid() };
ok ( !$@ , "getresgid didn't crash" ) || diag($@); 
ok ( @gids == 3 , "returned 3 elem array" ) || diag(Dumper(\@gids)); 
ok ( $gids[0] == 0, 'rgid is 0' ) || diag("rgid is ".$gids[0]);
ok ( $gids[1] == 0, 'egid is 0' ) || diag("egid is ".$gids[1]);
ok ( $gids[2] == 0, 'sgid is 0' ) || diag("sgid is ".$gids[2]);

eval { setresgid(50,60,70) };
ok ( !$@ , "setresgid(50,60,70) didn't crash" ) || diag($@); 
@gids = getresgid();
ok ( $gids[0] == 50, 'rgid is 50' ) || diag("rgid is ".$gids[0]);
ok ( $gids[1] == 60, 'egid is 60' ) || diag("egid is ".$gids[1]);
ok ( $gids[2] == 70, 'sgid is 70' ) || diag("sgid is ".$gids[2]);

eval { setresgid(51,61) };
ok ( !$@ , "setresgid(51,61) ie not with 3 args " ) || diag($@); 
@gids = getresgid();
ok ( $gids[0] == 51, 'rgid is 51' ) || diag("rgid is ".$gids[0]);
ok ( $gids[1] == 61, 'egid is 61' ) || diag("egid is ".$gids[1]);
ok ( $gids[2] == 70, 'sgid is 70' ) || diag("sgid is ".$gids[2]);

eval { setresuid(50,60,70) };
ok ( !$@ , "setresuid(50,60,70) didn't crash" ) || diag($@); 
@uids = getresuid();
ok ( $uids[0] == 50, 'ruid is 50' ) || diag("ruid is ".$uids[0]);
ok ( $uids[1] == 60, 'euid is 60' ) || diag("euid is ".$uids[1]);
ok ( $uids[2] == 70, 'suid is 70' ) || diag("suid is ".$uids[2]);

eval { setresuid(55,66,77) };
ok ( $@ , "setresuid while not root should crash" ) 
	|| diag("Didn't crash while running setresuid(55,66,77) as non root user!"); 
eval { setresgid(55,66,77) };
ok ( $@ , "setresgid while not root should crash" ) 
	|| diag("Didn't crash while running setresgid(55,66,77) as non root user!");
