use strict;
use warnings;
use Carp;
use Test::More;
use Unix::SavedIDs;
use POSIX qw(tmpnam);
use File::Spec::Functions qw(catdir);
use Module::Build;

my $build = Module::Build->current;
my $tt_ok = $build->notes('touchtest_ok');

if ( $tt_ok !~ /^y(es)?$/i ) {
	plan skip_all => "You didn't give me permission to touch and unlink a file";
}
if ( $< != 0 && $> != 0 ) {
	plan skip_all => "Only root can change user, so please run these tests as root.";
}
if ( ! -d '/tmp') {
	plan skip_all => "I was going to make a file in '/tmp/', but you don't"
		." seem to have a /tmp/ dir\n";
}

my $filename;
for my $i (0 ... 4) {
	$filename = tmpnam();
	if ( ! -e $filename ) {
		last;
	}
	print "File '$filename' exists, trying another\n";
	if ( $i == 4 ) {
		plan skip_all => "Can't find an unused temp file name to use";
	}
}
plan tests => 3;

ok( !system('touch',$filename), "root can touch $filename\n") || diag($!);
setresuid(-1,-1,50);
ok( !system('touch',$filename), "root can touch $filename even if saved"
	." id is 50\n") 
	|| diag($!);

pipe(my $from, my $to);
my $orig_handle = select();
select($to);
$| = 1;
select($from);
$| = 1;
select($orig_handle);

my $pid;
if ( $pid = fork() ) {
	close($to);
	ok( <$from>, "can NOT touch $filename if uid, euid and "
		."suid are 50\n") 
		|| diag("system('touch $filename') returned OK");
	waitpid($pid,0);
}
else {
	close($from);
	setresuid(50,50,50);
	print $to system('touch '.$filename.' 2>&1');
	exit;
}
unlink($filename) || die "Failed to unlink $filename\n";
