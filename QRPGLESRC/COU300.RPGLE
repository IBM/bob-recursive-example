     h nomain

     FCOUNTRY   if   e           k disk    usropn

      /copy qprotosrc,COUNTRY

     d chainCOUNTRY    pr
     D P_COID                         2A    value

     D K_COID          S                   LIKE(COID)

     C     kf            klist
     C                   KFLD                    K_COID

      *=============================================
     PGetCountryName   B                     export
     DGetCountryName   PI                   like(countr)
     D P_COID                         2A    value
      /free
         chainCOUNTRY(P_COID
               );
         return COUNTR;
      /end-free
     pGetCountryName   e
      *=============================================
     PGetCountryIso3   B                     export
     DGetCountryIso3   PI                   like(coiso)
     D P_COID                         2A    value
      /free
         chainCOUNTRY(P_COID
               );
         return COISO;
      /end-free
     pGetCountryIso3   e

      *=============================================
     P ExistCountry    B                     export
     D ExistCountry    PI              n
     D P_COID                         2A    value
      /free
         chainCOUNTRY(P_COID
               );
         return %found(country);
      /end-free
     p ExistCountry    e

     p chainCOUNTRY    b
     d chainCOUNTRY    pi
     D P_COID                         2A    value
      /free
        if not %open(COUNTRY);
          open COUNTRY;
        endif;
         if P_COID <> COID;
           K_COID =  P_COID;
           clear *all FCOUN;
           chain kf COUNTRY;
         endif;
      /end-free
     p chainCOUNTRY    e

     p closeCOUNTRY    b
     d closeCOUNTRY    pi
      /free
        if %open(COUNTRY);
          close COUNTRY;
        endif;
      /end-free
     p closeCOUNTRY    e


