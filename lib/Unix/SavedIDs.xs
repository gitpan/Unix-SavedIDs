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
		
# we want to handle both an unset var, hence = NULL and undef, hence using SVs
void
setresuid(ruid = NULL, euid = NULL, suid = NULL)
    SV * ruid
    SV * euid
	SV * suid 
    PREINIT:
      	uid_t uid_t_ruid = -1;
		uid_t uid_t_euid = -1;
		uid_t uid_t_suid = -1;
	PPCODE:
		if ( ruid != NULL ) {
			uid_t_ruid = SvIOK(ruid) ? SvIV(ruid) : -1;
		}
		if ( euid != NULL ) {
     		uid_t_euid = SvIOK(euid) ? SvIV(euid) : -1;
		}
		if ( suid != NULL ) {
     		uid_t_suid = SvIOK(suid) ? SvIV(suid) : -1;
		}
		if ( setresuid(uid_t_ruid,uid_t_euid,uid_t_suid) ) {
				croak("%s",strerror(errno));	
		}

void
setresgid(rgid = NULL, egid = NULL, sgid = NULL)
    SV * rgid
    SV * egid
	SV * sgid 
    PREINIT:
      	gid_t gid_t_rgid = -1;
		gid_t gid_t_egid = -1;
		gid_t gid_t_sgid = -1;
	PPCODE:
		if ( rgid != NULL ) {
			gid_t_rgid = SvIOK(rgid) ? SvIV(rgid) : -1;
		}
		if ( egid != NULL ) {
     		gid_t_egid = SvIOK(egid) ? SvIV(egid) : -1;
		}
		if ( sgid != NULL ) {
     		gid_t_sgid = SvIOK(sgid) ? SvIV(sgid) : -1;
		}
		if ( setresgid(gid_t_rgid,gid_t_egid,gid_t_sgid) ) {
				croak("%s",strerror(errno));	
		}
