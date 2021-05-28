     h dftactgrp(*no)

     ford500o   o    e             printer oflind(overflow)

     forder1    if   e           k disk
     fdetord1   if   e           k disk
     fcustome1  if   e           k disk
     farticle1  if   e           k disk

      /copy qprotosrc,parameter

     d ord500          pr
     d   id                                like(orid)

     d ord500          pi
     d   id                                like(orid)

     d pdford          pr                  extpgm('ORD500C')
     d   id                           5    const
     d   path                       100    const

     d count           s              3u 0
     d path            s            100

      /free

        datord = %date();
        chain id order1;
        datord = %date(ORDATE:*iso);
        chain orcuid custome1;
        write header;
        write header2;
        write header3;
        setll (orid) detord1;
        reade (orid) detord1;
        dow not %eof;
          if count > 14;
            write footer;
            write header;
            write header3;
            count = 0;
          endif;
          chain odarid article1;
          count += 1;
          totnet += odtot;
          tottot += odtotvat;
          write detail;
          reade (orid) detord1;
        enddo;
        *inlr = *on;
        totvat = tottot -totnet;
        write total;
        write footer;
        close ord500o;
        path = getParm2('PATH':' ');
        pdfOrd(%trim(%char(orid)):path);
      /end-free
