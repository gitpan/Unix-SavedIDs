
use strict;
use Test::More;
use Unix::SavedIDs;
use warnings;
use Data::Dumper;

if ( $< != 0 ) {
	plan skip_all => "Only root can change user, so please run these tests as root.";
}
else {
	plan tests => 48;
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

eval { setresgid() };
ok ( !$@ , "setresgid() - should do nothing" ) || diag($@); 
@gids = getresgid();
ok ( $gids[0] == 0, 'rgid is still 0' ) || diag("rgid is ".$gids[0]);
ok ( $gids[1] == 0, 'egid is still 0' ) || diag("egid is ".$gids[1]);
ok ( $gids[2] == 0, 'sgid is still 0' ) || diag("sgid is ".$gids[2]);

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

eval { setresgid(undef,undef,25) };
ok ( !$@, "setresgid(undef,undef,25) - set sgid only") || diag($@);
@gids = getresgid();
ok ( $gids[0] == 51, 'rgid is still 51' ) || diag("rgid is ".$gids[0]);
ok ( $gids[1] == 61, 'egid is still 61' ) || diag("egid is ".$gids[1]);
ok ( $gids[2] == 25, 'sgid is now 25' ) || diag("sgid is ".$gids[2]);

eval { setresgid(-1,-1,30) };
ok ( !$@ , "setresgid(-1,-1,30) - also set sgid only" ) || diag($@); 
@gids = getresgid();
ok ( $gids[0] == 51, 'rgid is 51' ) || diag("rgid is ".$gids[0]);
ok ( $gids[1] == 61, 'egid is 61' ) || diag("egid is ".$gids[1]);
ok ( $gids[2] == 30, 'sgid is 30' ) || diag("sgid is ".$gids[1]);

eval { setresuid() };
ok ( !$@, "setresuid() - do nothing ") || diag($@);
@uids = getresuid();
ok ( $uids[0] == 0, 'ruid is 0' ) || diag("ruid is ".$uids[0]);
ok ( $uids[1] == 0, 'euid is 0' ) || diag("euid is ".$uids[1]);
ok ( $uids[2] == 0, 'suid is 0' ) || diag("suid is ".$uids[2]);

setresuid(0,0,0);
eval { setresuid(undef,undef,25) };
ok ( !$@, "setresuid(undef,undef,25) - set suid only") || diag($@);
@uids = getresuid();
ok ( $uids[0] == 0, 'ruid is 0' ) || diag("ruid is ".$uids[0]);
ok ( $uids[1] == 0, 'euid is 0' ) || diag("euid is ".$uids[1]);
ok ( $uids[2] == 25, 'suid is 25' ) || diag("suid is ".$uids[2]);
setresuid(0,0,0);

eval { setresuid(-1,-1,30) };
ok ( !$@ , "setresuid(-1,-1,30) - also set suid only" ) || diag($@); 
@uids = getresuid();
ok ( $uids[0] == 0, 'ruid is 0' ) || diag("ruid is ".$uids[0]);
ok ( $uids[1] == 0, 'euid is 0' ) || diag("euid is ".$uids[1]);
ok ( $uids[2] == 30, 'suid is 30' ) || diag("suid is ".$uids[1]);

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
