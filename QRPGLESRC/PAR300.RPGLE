     h nomain

     FPARAMETER if   e           k disk    usropn

      /copy qprotosrc,PARAMETER

     d chainPARAMETER  pr
     D P_PACODE                      10A    value
     D P_PASUBCODE                   10A    value

     D K_PACODE        S                   LIKE(PACODE)
     D K_PASUBCODE     S                   LIKE(PASUBCODE)

     C     kf            klist
     C                   KFLD                    K_PACODE
     C                   KFLD                    K_PASUBCODE

      *=============================================
     PGetPARM1         B                     export
     DGetPARM1         PI            10A
     D P_PACODE                      10A    value
     D P_PASUBCODE                   10A    value
      /free
         chainPARAMETER(P_PACODE
               :P_PASUBCODE);

         return PARM1;
      /end-free
     pGetPARM1         e
      *=============================================
     PGetPARM2         B                     export
     DGetPARM2         PI           100A
     D P_PACODE                      10A    value
     D P_PASUBCODE                   10A    value
      /free
         chainPARAMETER(P_PACODE
               :P_PASUBCODE);

         return PARM2;
      /end-free
     pGetPARM2         e
      *=============================================
     PGetPARM3         B                     export
     DGetPARM3         PI             2A
     D P_PACODE                      10A    value
     D P_PASUBCODE                   10A    value
      /free
         chainPARAMETER(P_PACODE
               :P_PASUBCODE);

         return PARM3;
      /end-free
     pGetPARM3         e
      *=============================================
     PGetPARM4         B                     export
     DGetPARM4         PI             1P 0
     D P_PACODE                      10A    value
     D P_PASUBCODE                   10A    value
      /free
         chainPARAMETER(P_PACODE
               :P_PASUBCODE);

         return PARM4;
      /end-free
     pGetPARM4         e
      *=============================================
     PGetPARM5         B                     export
     DGetPARM5         PI             3P 0
     D P_PACODE                      10A    value
     D P_PASUBCODE                   10A    value
      /free
         chainPARAMETER(P_PACODE
               :P_PASUBCODE);

         return PARM5;
      /end-free
     pGetPARM5         e

     p chainPARAMETER  b
     d chainPARAMETER  pi
     D P_PACODE                      10A    value
     D P_PASUBCODE                   10A    value
      /free
        if not %open(PARAMETER);
          open PARAMETER;
        endif;
         if P_PACODE <> PACODE
           or P_PASUBCODE <> PASUBCODE;
           K_PACODE =  P_PACODE;
           K_PASUBCODE =  P_PASUBCODE;
           clear *all FPARAM;
           chain kf PARAMETER;
         endif;
      /end-free
     p chainPARAMETER  e

     p closePARAMETER  b
     d closePARAMETER  pi
      /free
        if %open(PARAMETER);
          close PARAMETER;
        endif;
      /end-free
     p closePARAMETER  e


