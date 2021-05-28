     h nomain

     FCUSTOME1  if   e           k disk    usropn

      /copy qprotosrc,CUSTOMER

     d chainCUSTOME1   pr
     D P_CUID                         5  0  value

     D K_CUID          S                   LIKE(CUID)

     C     kf            klist
     C                   KFLD                    K_CUID

      *=============================================
     PGetCusName       B                     export
     DGetCusName       PI                   like(custnm)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUSTNM;
      /end-free
     pGetCusName       e
      *=============================================
     PGetCusPhone      B                     export
     DGetCusPhone      PI                   like(cuphone)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUPHONE;
      /end-free
     pGetCusPhone      e
      *=============================================
     PGetCusVat        B                     export
     DGetCusVat        PI                   like(cuvat)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUVAT;
      /end-free
     pGetCusVat        e
      *=============================================
     PGetCusMail       B                     export
     DGetCusMail       PI                   like(cumail)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUMAIL;
      /end-free
     pGetCusMail       e
      *=============================================
     PGetCusAdrline1   B                     export
     DGetCusAdrline1   PI                   like(culine1)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CULINE1;
      /end-free
     pGetCusAdrline1   e
      *=============================================
     PGetCusAdrline2   B                     export
     DGetCusAdrline2   PI                   like(culine2)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CULINE2;
      /end-free
     pGetCusAdrline2   e
      *=============================================
     PGetCusAdrline3   B                     export
     DGetCusAdrline3   PI                   like(culine3)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CULINE3;
      /end-free
     pGetCusAdrline3   e
      *=============================================
     PGetCusZip        B                     export
     DGetCusZip        PI                   like(cuzip)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUZIP;
      /end-free
     pGetCusZip        e
      *=============================================
     PGetCusCity       B                     export
     DGetCusCity       PI                   like(cucity)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUCITY;
      /end-free
     pGetCusCity       e
      *=============================================
     PGetCusCountry    B                     export
     DGetCusCountry    PI                   like(cucoun)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUCOUN;
      /end-free
     pGetCusCountry    e
      *=============================================
     PGetCusLimCredit  B                     export
     DGetCusLimCredit  PI                   like(culimcre)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CULIMCRE;
      /end-free
     pGetCusLimCredit  e
      *=============================================
     PGetCusCredit     B                     export
     DGetCusCredit     PI                   like(cucredit)
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUCREDIT;
      /end-free
     pGetCusCredit     e
      *=============================================
      // Remove the comment (//) to test the addition of a function
      // PGetCusLastOrdDate...
      // P                 B                     export
      // dGetCusLastOrdDate...
      // D                 PI                   like(culastord)
      // D P_CUID                         5  0  value
      //  /free
      //   chainCUSTOME1(P_CUID
      //         );
      //   return CULastOrd;
      //  /end-free
      // p                 e
      *=============================================
     P ExistCus        B                     export
     D ExistCus        PI              n
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return %found(custome1) and CUDEL <> 'X';
      /end-free
     p ExistCus        e

      *=============================================
     PIsCusDeleted     B                     export
     DIsCusDeleted     PI              n
     D P_CUID                         5  0  value
      /free
         chainCUSTOME1(P_CUID
               );
         return CUDEL = 'X';
      /end-free
     pIsCusDeleted     e

     p chainCUSTOME1   b
     d chainCUSTOME1   pi
     D P_CUID                         5  0  value
      /free
        if not %open(CUSTOME1);
          open CUSTOME1;
        endif;
         if P_CUID <> CUID;
           K_CUID =  P_CUID;
           clear *all FCUST;
           chain kf CUSTOME1;
         endif;
      /end-free
     p chainCUSTOME1   e

     p closeCUSTOME1   b
     d closeCUSTOME1   pi
      /free
        if %open(CUSTOME1);
          close CUSTOME1;
        endif;
      /end-free
     p closeCUSTOME1   e


