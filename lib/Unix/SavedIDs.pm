package Unix::SavedIDs;

use strict;
use warnings;

BEGIN {
	use Exporter ();
	our ($VERSION,@ISA,@EXPORT);
	@ISA    = qw(Exporter);
	@EXPORT = qw(getresuid getresgid setresuid setresgid);
	use version; $VERSION = qv('0.1');
	use XSLoader;
	XSLoader::load('Unix::SavedIDs','v0.1');
}

1;

__END__

=head1 NAME

Unix::SavedIDs - interface to unix saved id commands: getresuid(), getresgid(), setresuid() and setresgid()

=head1 SYNOPSIS

    use Unix::SavedIDs;

	my($ruid,$euid,$suid) = getresuid();
	setresuid(10,10,10);

=head1 DESCRIPTION

This module is a simple interface to the c routines with the same names.

$<, $>, $(, $) and the POSIX setuid(),seteuid etc... functions give you 
access to the real uid/gid (ruid/rgid) and effective uid/gid (I<euid>/I<egid>), 
but there was no way to get or set the saved uid/gid (I<suid>/I<sgid>).

=head1 INTERFACE 

=head2 getresuid()

returns a list of 3 elements, the current I<ruid>, I<euid> and I<suid> or croaks 
on failure.

=head2 getresgid()

returns a list of 3 elements, the current I<rgid>, I<egid> and I<sgid> or croaks 
on failure.

=head2 setresuid(I<ruid>,I<euid>,I<suid>)

Sets the current I<ruid>, I<euid> and I<suid> or croaks on failure.  

If you pass fewer than three args, the values corresponding to unspecified args
will not be changed.  E.G. if you call C<setresuid(10,20)>, you will change the
I<ruid> and I<euid> but the I<suid> will not change.  If this is what you want, you're
probably better off using $<,$> etc...  setresgid behaves in the same way.

=head2 setresgid(I<rgid>,I<egid>,I<sgid>)

Sets the current I<rgid>, I<egid> and I<sgid> or croaks on failure.  

Please see setresuid() above for information on what happens when you specify fewer than 3 args.  

=head1 TODO

=over 4

=item 1 

make more complete test suite

=item 2 

make build system detect if saved ids are supported and do something
clever if not

=back

=head1 BUGS AND LIMITATIONS

It should do someting rational on systems without saved ids.  

I only have Linux and OpenBSD systems to test on, so I have no idea how it
might work on other operating systems.  If you run a different OS, please let
me know how this module works in your environment.

Please report any bugs or feature requests to
C<bug-unix-savedids@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Dylan Martin  C<< <dmartin@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2008, Dylan Martin & Seattle Central Community College 
C<< <dmartin@cpan.org> >>. 

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

=head1 DISCLAIMER

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.