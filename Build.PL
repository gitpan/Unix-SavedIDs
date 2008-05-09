use strict;
use warnings;
use Module::Build;
use Config;

my $builder = Module::Build->new(
    module_name         => 'Unix::SavedIDs',
    license             => 'bsd',
    dist_author         => 'Dylan Martin <dmartin@sccd.ctc.edu>',
    dist_version_from   => 'lib/Unix/SavedIDs.pm',
    requires => {
        'Test::More' => 0,
		'version'	 => 0,
    },
    add_to_cleanup      => [ 'Unix-SavedIDs-*', ],
	create_makefile_pl	=> 'passthrough',
	create_readme		=> 1,
);

# is unixish is only in recent versions of Module::Build
my $is_unixy = eval{ $builder->is_unixish() };
if ( defined($is_unixy) && !$is_unixy ) { 
	die "Sorry!\n\nThis module only works on unix-like operating systems!\n\n";
}

if ( ! $Config{useposix} ) {
	die "Sorry!\n\nThis is not a POSIX system, so saved IDs probably won't work\n";
}

eval { require POSIX };
if ( $@ ) {
	die "Failed to load POSIX module.  If you can't do POSIX, I'm not even " 
		."going to try to do saved ids\n"; 
}

my $kernel = (POSIX::uname())[2];

if ( $^O eq 'linux' ) {
	if ( $kernel !~ /^(\d+)\.(\d+)\.(\d+)/ ) {
		warn "I don't know how to parse kernel version '$kernel' please"
			." contact dmartin\@cpan.org and include the kernel version"
			." string.\n";
	}
	my($maj,$min,$mic) = ($1,$2,$3);
	my $kernel_version_mesg = "Kernels older than 2.1.44 don't"
		." have saved ids\n";
	if ( 
		($maj < 2 ) ||
		( $maj == 2 && $min < 1 ) ||
	 	( $maj == 2 && $min == 1 && $mic < 44 ) )
    {
		die $kernel_version_mesg;
	}
	print "You are running Linux with a kernel newer than 2.1.44.  Good!\n";
} 
elsif ( $^O eq 'openbsd' ) {
	print "You are running OpenBSD.  Good!\n";
}
else {
	print "Unix::SavedIDs hasn't been tested on $^O, please"
			." contact dmartin\@cpan.org and let me know how it works\n";
}

$builder->create_build_script();
