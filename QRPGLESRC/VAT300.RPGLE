     h nomain

     FVATDEF    if   e           k disk    usropn

      /copy qprotosrc,VAT

     d chainVATDEF     pr
     D P_VATCODE                      1A    value

     D K_VATCODE       S                   LIKE(VATCODE)

     C     kf            klist
     C                   KFLD                    K_VATCODE

      *=============================================
     PGetVATRate       B                     export
     DGetVATRate       PI             4P 2
     D P_VATCODE                      1A    value
      /free
         chainVATDEF(P_VATCODE  );
         return VATRATE;
      /end-free
     pGetVATRate       e
      *=============================================
     PGetVATDesc       B                     export
     DGetVATDesc       PI            20A
     D P_VATCODE                      1A    value
      /free
         chainVATDEF(P_VATCODE  );
         return VATDESC;
      /end-free
     pGetVATDesc       e

      *=============================================
     P ClcVAT          B                     export
     D ClcVAT          PI             9  2
     D P_VATCODE                      1     value
     d Net                            9  2  value

     d tot             s             11  4
      /free
         chainVATDEF(P_VATCODE  );
         tot = (net * vatrate) / 100;
         return %dech(tot : 9 :2) ;
      /end-free
     p ClcVAT          e

      *=============================================
     P ExistVATRate    B                     export
     D ExistVATRate    PI              n
     D P_VATCODE                      1A    value
      /free
         chainVATDEF(P_VATCODE  );
         return %found(VATDEF) and VATDEL <> 'X';
      /end-free
     p ExistVATRate    e

     p chainVATDEF     b
     d chainVATDEF     pi
     D P_VATCODE                      1A    value
      /free
        if not %open(VATDEF);
          open VATDEF;
        endif;
         if P_VATCODE <> VATCODE;
           K_VATCODE =  P_VATCODE;
           clear *all FVAT;
           chain kf VATDEF;
         endif;
      /end-free
     p chainVATDEF     e

     p closeVATDEF     b
     d closeVATDEF     pi
      /free
        if %open(VATDEF);
          close VATDEF;
        endif;
      /end-free
     p closeVATDEF     e


