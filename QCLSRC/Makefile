########## BOB HEADER SECTION -- DO NOT MODIFY ##########

### IBMiMakefile setup
PROJECTDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Include generic IBM i makefile.
IBMIMAKEFILE := /QOpenSys/pkgs/lib/bob/IBMiMakefile
include $(IBMIMAKEFILE)

### Define type-specific targets and their dependencies
.PHONY: all PFs LFs DSPFs PRTFs CMDs MODULEs SRVPGMs PGMs MENUs PNLGRPs QMQRYs WSCSTs make_post
all: PFs LFs DSPFs PRTFs CMDs MODULEs SRVPGMs PGMs MENUs PNLGRPs QMQRYs WSCSTs make_post

LFs: PFs
DSPFs PRTFs: LFs
MODULEs: PFs LFs DSPFs PRTFs
SRVPGMs: MODULEs
PGMs: SRVPGMs
########## END OF "DO NOT MODIFY" SECTION ##########


########## LIST OF OBJECTS TO BUILD, GROUPED BY TYPE ##########
### Define user objects to type-specific targets so they're compiled in the
### correct order.  This section declares _what_ to build.

PFs:

LFs:

DSPFs: 

PRTFs: 

CMDs:

MODULEs: ORD100C.MODULE ORD100C2.MODULE ORD500C.MODULE PAR201.MODULE

SRVPGMs: 

PGMs: ORD100C.PGM ORD100C2.PGM ORD500C.PGM PAR201.PGM

MENUs: 

PNLGRPs: 

QMQRYs: 

WSCSTs: 


########## OBJECT RULES, DEPENDENCIES AND CUSTOM COMPILE SETTINGS ##########
### Define dependency information and custom compile settings for each object.
### This section declares _how_ to build.  Please list rules alphabetically.

ORD100C.MODULE: ORD100C.CLLE

ORD100C.PGM: ORD100C.MODULE

ORD100C2.MODULE: ORD100C2.CLLE

ORD100C2.PGM: ORD100C2.MODULE

ORD500C.MODULE: ORD500C.CLLE

ORD500C.PGM: ORD500C.MODULE

PAR201.MODULE: PAR201.CLLE

PAR201.PGM: PAR201.MODULE

########## THIS SECTION MUST BE AT THE END OF THE MAKEFILE ##########

# Include all auto-generated source dependency files. Since we don't have a
# hard-coded list of source files, we will grab everything in the `$DEPDIR`
# directory.
-include $(wildcard $(DEPDIR)/*.d)