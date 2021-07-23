     h nomain

     FFAMILLY   if   e           k disk    usropn

      /copy qprotosrc/FAMILLY

     d chainFAMILLY    pr
     D P_FAID                         3     value

     D K_FAID          S                   LIKE(FAID)

     C     kf            klist
     C                   KFLD                    K_FAID

      *=============================================
     PGetArtFamDesc    B                     export
     DGetArtFamDesc    PI                   like(fadesc)
     D P_FAID                         3     value
      /free
         chainFAMILLY(P_FAID
               );
         return FADESC;
      /end-free
     pGetArtFamDesc    e
      *=============================================
     P ExistArtFam     B                     export
     D ExistArtFam     PI              n
     D P_FAID                         3     value
      /free
         chainFAMILLY(P_FAID
               );
         return %found(familly) AND FADEL<>'D';
      /end-free
     p ExistArtFam     e

      *=============================================
     PIsArtFamDeleted  B                     export
     DIsArtFamDeleted  PI              n
     D P_FAID                         3     value
      /free
         chainFAMILLY(P_FAID
               );
         return FADEL = 'X';
      /end-free
     pIsArtFamDeleted  e

     p chainFAMILLY    b
     d chainFAMILLY    pi
     D P_FAID                         3     value
      /free
        if not %open(FAMILLY);
          open FAMILLY;
        endif;
         if P_FAID <> FAID;
           K_FAID =  P_FAID;
           clear *all FFAMI;
           chain kf FAMILLY;
         endif;
      /end-free
     p chainFAMILLY    e

     p closeFAMILLY    b
     d closeFAMILLY    pi
      /free
        if %open(FAMILLY);
          close FAMILLY;
        endif;
      /end-free
     p closeFAMILLY    e


