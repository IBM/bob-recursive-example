     h nomain

     FARTICLE1  if   e           k disk    usropn

      /copy qprotosrc,ARTICLE

     d chainARTICLE1   pr
     D P_ARID                         6A    value

     D K_ARID          S                   LIKE(ARID)

     C     kf            klist
     C                   KFLD                    K_ARID

      *=============================================
     PGetArtDesc       B                     export
     DGetArtDesc       PI                   like(ardesc)
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ARDESC;
      /end-free
     pGetArtDesc       e
      *=============================================
     PGetArtRefSalPrice...
     P                 B                     export
     DGetArtRefSalPrice...
     D                 PI                   like(arsalepr)
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ARSALEPR;
      /end-free
     p                 e
      *=============================================
     PGetArtStockPrice...
     P                 B                     export
     DGetArtStockPrice...
     D                 PI                   like(arwhspr)
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ARWHSPR;
      /end-free
     p                 e
      *=============================================
     PGetArtFam        B                     export
     DGetArtFam        PI                   like(artifa)
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ARTIFA;
      /end-free
     pGetArtFam        e
      *=============================================
     PGetArtStock      B                     export
     DGetArtStock      PI                   like(arstock)
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ARSTOCK;
      /end-free
     pGetArtStock      e
      *=============================================
     PGetArtMinStock   B                     export
     DGetArtMinStock   PI                   like(arminqty)
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ARMINQTY;
      /end-free
     pGetArtMinStock   e
      *=============================================
     PGetArtVatCode    B                     export
     DGetArtVatCode    PI                   like(arvatcd)
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ARvatcd ;
      /end-free
     pGetArtVatCode    e
      *=============================================
     P ExistArt        B                     export
     D ExistArt        PI              n
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return %found(article1) and ardel <> 'X';
      /end-free
     p ExistArt        e

      *=============================================
     PIsArtDeleted     B                     export
     DIsArtDeleted     PI              n
     D P_ARID                         6A    value
      /free
         chainARTICLE1(P_ARID
               );
         return ArDEL = 'X';
      /end-free
     pIsArtDeleted     e

     p chainARTICLE1   b
     d chainARTICLE1   pi
     D P_ARID                         6A    value
      /free
        if not %open(ARTICLE1);
          open ARTICLE1;
        endif;
         if P_ARID <> ARID;
           K_ARID =  P_ARID;
           clear *all FARTI;
           chain kf ARTICLE1;
         endif;
      /end-free
     p chainARTICLE1   e

     p closeARTICLE1   b
     d closeARTICLE1   pi
      /free
        if %open(ARTICLE1);
          close ARTICLE1;
        endif;
      /end-free
     p closeARTICLE1   e


