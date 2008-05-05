#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include <unistd.h>
#include <string.h>

MODULE = Unix::SavedIDs     PACKAGE = Unix::SavedIDs

void 
getresuid()
	INIT:
		int err;
		uid_t ruid;
		uid_t euid;
		uid_t suid;
	PPCODE:
		err = getresuid(&ruid,&euid,&suid);
		if ( err ) {
				croak("%s",strerror(errno));	
		}
		XPUSHs(sv_2mortal(newSVuv(ruid)));
		XPUSHs(sv_2mortal(newSVuv(euid)));
		XPUSHs(sv_2mortal(newSVuv(suid)));

void 
getresgid()
	INIT:
		int err;
		gid_t rgid;
		gid_t egid;
		gid_t sgid;
	PPCODE:
		err = getresgid(&rgid,&egid,&sgid);
		if ( err ) {
				croak("%s",strerror(errno));	
		}
		XPUSHs(sv_2mortal(newSVuv(rgid)));
		XPUSHs(sv_2mortal(newSVuv(egid)));
		XPUSHs(sv_2mortal(newSVuv(sgid)));
		
void
setresuid(ruid = -1, euid = -1, suid = -1)
	int ruid
	int euid
	int suid
	PPCODE:
		if ( setresuid(ruid,euid,suid) ) {
				croak("%s",strerror(errno));	
		}

void
setresgid(rgid = -1, egid = -1, sgid = -1)
	int rgid 
	int egid 
	int	sgid 
	PPCODE:
		if ( setresgid(rgid,egid,sgid) ) {
				croak("%s",strerror(errno));	
		}
