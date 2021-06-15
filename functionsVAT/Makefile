########## BOB HEADER SECTION -- DO NOT MODIFY ##########

### IBMiMake setup
PROJECTDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Include generic IBM i makefile.  Its location is stored in an environment variable called IBMIMAKE.
ifeq ($(strip $(IBMIMAKE)),)
$(warning Environment variable 'IBMIMAKE' not set.  Defaulting to $(realpath ../IBMiMake))
IBMIMAKE := ../IBMiMake
else
$(info Using IBMiMake file: $(realpath $(IBMIMAKE)))
endif
include $(IBMIMAKE)

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

PFs: VATDEF.FILE SAMREF.FILE

LFs:

DSPFs: 

PRTFs: 

CMDs:

MODULEs: VAT300.MODULE

SRVPGMs: FVAT.SRVPGM

PGMs:

MENUs: 

PNLGRPs: 

QMQRYs: 

WSCSTs: 


########## OBJECT RULES, DEPENDENCIES AND CUSTOM COMPILE SETTINGS ##########
### Define dependency information and custom compile settings for each object.
### This section declares _how_ to build.  Please list rules alphabetically.
VAT300.MODULE: VAT300.RPGLE VATDEF.FILE SAMREF.FILE

FVAT.SRVPGM: FVAT.BND VAT300.MODULE

VATDEF.FILE: VATDEF.PF SAMREF.FILE

SAMREF.FILE: SAMREF.PF

########## THIS SECTION MUST BE AT THE END OF THE MAKEFILE ##########

# Include all auto-generated source dependency files. Since we don't have a
# hard-coded list of source files, we will grab everything in the `$DEPDIR`
# directory.
-include $(wildcard $(DEPDIR)/*.d)