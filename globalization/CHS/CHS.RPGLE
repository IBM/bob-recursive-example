即 D/DEFINE DEF1                                                              CMT 
     D fld2            s             20A     ccsid(*JOBRUNMIX)
即    dcl-s fld3 char(30);
     C     '即可加快进'cat       '即'        fld2                                     CMT即
加   fld2 = '即加'; // hover on fld2 should work and should be seen as a reference
       //<- prompting here should see 'fld3' as an option
     C                   SETON                                        LR 