     forder     UF   E             DISK

     d lastdate        s              8  0
     d today           s              8  0
     d days            s              5  0

      /free
         exec sql select max(ordate)  into :LastDate from order;
         if lastdate = 0;
           *inlr = *on;
           return;
         ENDIF;
         today = %dec(%date():*iso);
         days = %diff(%date():%date(lastdate:*iso):*d);
         lastdate = %dec(%date() - %days(10):*iso);
         read order;
         dow not %eof;
           ordate = %dec(%date(ordate:*iso) + %days(days):*iso);
           if ordatdel > 0;
              ordatdel = %dec(%date(ordatdel:*iso) + %days(days):*iso);
              if  ordatdel > today;
                ordatdel = 0;
              ENDIF;
           ENDIF;
           if ordatclo > 0;
              ordatclo = %dec(%date(ordatclo:*iso) + %days(days):*iso);
              if  ordatclo > today ;
                ordatclo = 0;
              ENDIF;
           else;
              if ordatdel > 0 and ordatdel < lastdate ;
                ordatclo =  %dec(%date(ordatdel:*iso) + %days(10):*iso);
              ENDIF;
           ENDIF;
           oryear = %subdt(%date(ordate:*iso):*Y);
           update forde;
           read order;
         ENDDO;
         exec sql Update detord d set odyear = (select oryear
                from order where d.odorid = orid)
                where odyear <> (select oryear
                from order where d.odorid = orid) ;
         exec sql  UPDATE CUSTOMER  C SET CULASTORD =
              ( SELECT MAX ( ORDATE ) FROM "ORDER"
                      WHERE C.CUID = ORCUID )
                WHERE EXISTS ( SELECT ORCUID FROM "ORDER"
                      WHERE C.CUID = ORCUID );
         *inlr = *on;
      /end-free
