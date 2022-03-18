即 D/DEFINE DEF1                                                              should not appear in outline view
     D fld2            s             20A     ccsid(*JOBRUNMIX)
即    dcl-s fld3 char(30) ; // prompt before dcl-s should see all dcl-xx opcodes
     C     '即可加快进'cat       '即'        fld2                                     CMT即
加   fld2 = '即加'; // hover on fld2 should work and should be seen as a reference
加   //<- prompting here should see all calc opcodes
       fld3 = fld2; // formatting files should not indent/outdents anything
     C                   SETON                                        LR 