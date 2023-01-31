# Note we build everything to do with this Service Program in this directory
# There is one dependency on the DB reference file SAMREF which is in the 
# 'common' directory

FVAT.SRVPGM: fvat.bnd VAT300.MODULE
FVAT.SRVPGM: TEXT = Functions VAT

VAT300.MODULE: vat300.rpgle vat.rpgleinc VATDEF.FILE

VATDEF.FILE: vatdef.pf SAMREF.FILE
