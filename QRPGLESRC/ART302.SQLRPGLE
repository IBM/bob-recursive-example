     h nomain

      /copy article

     d savInfo         s           1520
     d savId           s              6
      *=============================================
     PGetArtInfo       B                     export
     DGetArtInfo       PI          1520
     D P_ARID                         6A    value
      /free
         if P_arid <> savId;
           savid = p_arid;
           EXEC SQL
             SELECT artinf
               INTO :savinfo
               FROM artiinf
               WHERE arid = :savid;
         endif;

         return savinfo;
      /end-free
     pGetArtInfo       e
