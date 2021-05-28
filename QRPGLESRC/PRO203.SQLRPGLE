     h dftactgrp(*no)
     fpro202d   cf   e             workstn

      /copy qprotosrc,Xss
      /copy qprotosrc,Parameter

     d data            ds                  inz
     d   ARID                         6
     d   ARDESC                      50A
     d   ARSTOCK                      5P 0
     d   ARMINQTY                     5P 0
     d   ARCUSQTY                     5P 0
     d   ARPURQTY                     5P 0
     d   PRID                         5P 0
     d   PROVNM                      30A
     d   APPRICE                      7P 2
     d   APREF                       10A
     d   TOT                          3  0

     d r1              s             12
     d r2              s             12
     d head            s              3u 0
     d dec2            s              3u 0
     d Yellow          s              3u 0

      /free
        fileName = 'Goods to purchase' + '_' +
                    %char(%dec(%date:*YMD)) + '.xml';
        path = GetParm2('PATH':' ');
        xssopenfile(%trim(path) + fileName);
        XssSetDocProperties('SAMPLE Company':' ':1);
        head = xsscreatestyle();
        xssSetFontSize(12);
        XssSetalign(ALIGN_CENTER);
        Xsssetwrap();
        dec2 = xsscreatestyle();
        XssSetFormat(FORMAT_DEC2);
        Yellow = xsscreatestyle();
        XsssetForcolor(COLOR_YELLOW);
        Xssaddsheet('Purchasing');
        XssSetColWidth(150 :2);
        xssaddrow(40);
        xssaddcellChar('Art Id':head);
        r1 = XssGetCellId();
        xssaddcellChar('Description':head);
        xssaddcellChar('Stock':head);
        xssaddcellChar('Minimun Stock':head);
        xssaddcellChar('Customer Order Qty':head);
        xssaddcellChar('Purchase Order Qty':head);
        xssaddcellChar('Proposed Order Qty':head);
        xssaddcellChar('Provider Id':head);
        xssaddcellChar('Name':head);
        xssaddcellChar('Purchase Price':head);
        xssaddcellChar('Provider Reference':head);

        exec sql declare c1 cursor for
           SELECT ARID, ARDESC, arstock, ARMINQTY, ARCUSQTY, ARPURQTY, PRID,
                  PROVnm,  APPRICE, apref,
                  (select count(*) from artiprov b where a.aparid = b.aparid )
           FROM article, artiprov a, provider
           WHERE arstock < ARMINQTY - arcusqty + arpurqty
             and Arcusqty > 0
             and arid = aparid AND apprid = prid
          ORDER BY arid, apprid;
        exec sql open c1;

        exec sql fetch c1 into :data;
        dow sqlcod = 0;
          xssaddrow();
          if tot = 1;
            XssAddCellChar(ARID);
            XssAddCellChar(ARDESC);
          else;
            XssAddCellChar(ARID:Yellow);
            XssAddCellChar(ARDESC:Yellow);
          ENDIF;
          xssaddcellNum(ARSTOCK);
          XssAddCellNum(ARMINQTY);
          XssAddCellNum(ARCUSQTY);
          XssAddCellNum(ARPURQTY);
          XssAddCellNum(ARMINQTY + ARCUSQTY - arpurqty - arstock);
          XssAddCellNum(PRID);
          XssAddCellChar(PROVNM);
          XssAddCellNum(APPRICE:dec2);
          XssAddCellChar(APREF);
          exec sql fetch c1 into :data;
        ENDDO;
        exec sql close c1;
        r2 = XssGetCellId();
        XssSetAutoFilter(r1:r2);
        Xssclosefile();
        exfmt fmt03;

        *inlr = *on;
      /end-free

