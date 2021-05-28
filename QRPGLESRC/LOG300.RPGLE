      *   %XREF XREFTYPE(*OBJ)   OBJ(SAMLOG) OBJTYPE(*USRSPC)   USAGE(*UPD)

     h nomain

      /copy qprotosrc,apicall
      /copy qprotosrc,log
     d init            pr

     d pos             s             10i 0 based(p1)
     d data            s            600    based(p2)
     d usrspc          s             20
     d inz             s               n
     d User            s             10    inz(*USER)

     p AddLogEntry     b                   export
     d AddLogEntry     pi
     d  entry                       500    value

     d  data2          s            500    varying
      /free
        if not inz;
          init();
        endif;
        p2 = p1 + pos;
        data2 = 'User: ' +user + ' * ';
        data2 += 'Date: '  + %char(%Timestamp()) + ' * ' ;
        data2 += 'Msg: '  + %trim(entry) + ' ***' ;
        data = data2;
        pos += %len(data2);
      /end-free

     p AddLogEntry     e

     p init            b
     d init            pi

      /free
        usrspc = 'SAMLOG    *LIBL';
        inz = *on;
        rtvusrspcptr(usrspc:p1);
      /end-free

     p init            e
