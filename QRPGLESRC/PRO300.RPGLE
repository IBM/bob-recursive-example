     h nomain

     FPROVIDE1  if   e           k disk    usropn

      /copy qprotosrc,PROVIDER

     d chainPROVIDE1   pr
     D P_PRID                         5P 0  value

     D K_PRID          S                   LIKE(PRID)

     C     kf            klist
     C                   KFLD                    K_PRID

      *=============================================
     PGetProName       B                     export
     DGetProName       PI                  like(provnm)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PROVNM;
      /end-free
     pGetProName       e
      *=============================================
     PGetProCONT       B                     export
     DGetProCONT       PI                  like(prcont)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRCONT;
      /end-free
     pGetProCONT       e
      *=============================================
     PGetProPHONE      B                     export
     DGetProPHONE      PI                  like(prphone)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRPHONE;
      /end-free
     pGetProPHONE      e
      *=============================================
     PGetProVAT        B                     export
     DGetProVAT        PI                  like(prvat)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRVAT;
      /end-free
     pGetProVAT        e
      *=============================================
     PGetProMAIL       B                     export
     DGetProMAIL       PI                  like(prmail)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRMAIL;
      /end-free
     pGetProMAIL       e
      *=============================================
     PGetProAdr1       B                     export
     DGetProAdr1       PI                  like(prline1)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRLINE1;
      /end-free
     pGetProAdr1       e
      *=============================================
     PGetProAdr2       B                     export
     DGetProAdr2       PI                  like(prline2)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRLINE2;
      /end-free
     pGetProAdr2       e
      *=============================================
     PGetProAdr3       B                     export
     DGetProAdr3       PI                  like(prline3)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRLINE3;
      /end-free
     pGetProAdr3       e
      *=============================================
     PGetProZip        B                     export
     DGetProZip        PI                  like(przip)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRZIP;
      /end-free
     pGetProZip        e
      *=============================================
     PGetProCity       B                     export
     DGetProCity       PI                  like(prcity)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRCITY;
      /end-free
     pGetProCity       e
      *=============================================
     PGetProCountry    B                     export
     DGetProCountry    PI                  like(prcoun)
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRCOUN;
      /end-free
     pGetProCountry    e
      *=============================================
     P ExistProvider   B                     export
     D ExistProvider   PI              n
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return %found(provide1) and prdel <> 'X';
      /end-free
     p ExistProvider   e

      *=============================================
     PIsProDeleted     B                     export
     DIsProDeleted     PI              n
     D P_PRID                         5P 0  value
      /free
         chainPROVIDE1(P_PRID
               );
         return PRDEL = 'X';
      /end-free
     pIsProDeleted     e

     p chainPROVIDE1   b
     d chainPROVIDE1   pi
     D P_PRID                         5P 0  value
      /free
        if not %open(PROVIDE1);
          open PROVIDE1;
        endif;
         if P_PRID <> PRID;
           K_PRID =  P_PRID;
           clear *all FPROV;
           chain kf PROVIDE1;
         endif;
      /end-free
     p chainPROVIDE1   e

     p closePROVIDE1   b
     d closePROVIDE1   pi
      /free
        if %open(PROVIDE1);
          close PROVIDE1;
        endif;
      /end-free
     p closePROVIDE1   e


