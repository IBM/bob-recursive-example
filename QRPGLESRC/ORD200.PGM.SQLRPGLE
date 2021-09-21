
     h dftactgrp(*no) bnddir('SAMPLE')

     forder1    uf   e           k disk
     fdetord1   uf   e           k disk
     fcustome1  if   e           k disk
     ford200d   cf   e             workstn
     F                                     indds(indds)
     F                                     sfile(sfl01:rrn01)
     F                                     Infds(Info)

     d ord200          pr
     d  cuid                               like(orcuid)

     d ord200          pi
     d  cuid                               like(orcuid)

     d Updord          pr                  extpgm('ORD101')
     d  x                                  like(orid)

     d dspord          pr                  extpgm('ORD202')
     d  x                                  like(orid)

     d Prtord          pr                  extpgm('ORD500')
     d  x                                  like(orid)

     d NewOrder        pr                  extpgm('ORD100C')
     d  x                                  like(cuid)

     D indds           ds
     D  help                   1      1n
     D  exit                   3      3n
     D  prompt                 4      4n
     D  refresh                5      5n
     D  create                 6      6n
     D  cancel                12     12n
     D  morekeys              24     24n
     D  pagedown              25     25n
     D  sflclr                30     30n
     D  sfldsp                31     31n
     D  sfldspctl             32     32n
     D  sflnxtchg             33     33n
     D  dspatr_ri             34     34n
     D  sflmsg                35     35n
     D  sflmsg2               36     36n
     D  sflmsg3               37     37n
     D  sflend                80     80n

     D info            ds
     D  lrrn                 378    379i 0

     D rrn01           s              5i 0
     D rrs01           s              5i 0
     D err01           s               n

     D panel           S              3i 0 INZ(1)
     D step01          S              3    inz(prp)
     d savId           s                   like(cuid)
     d User            s             10    inz(*user)
     d count           s              3i 0
     d mode            s              3

     d crt             c                   'CRT'
     d upd             c                   'UPD'
     d prp             c                   'prp'
     d lod             c                   'lod'
     d dsp             c                   'dsp'
     d key             c                   'key'
     d chk             c                   'chk'
     d act             c                   'act'
     d datBlank        c                   d'1940-01-01'
      /free
       select;
       when panel = 1;
         exsr pnl01;
       other;
         exsr pnl00;
       endsl;
       //- Subfiles  01 Subroutines --------------------------------------  ---
       begsr pnl01;
         select ;
         when step01 = prp ;
           exsr s01prp;
         when step01 = lod ;
           exsr s01lod;
         when step01 = dsp ;
           exsr s01dsp;
         when step01 = key ;
           exsr s01key;
         when step01 = chk ;
           exsr s01chk;
         when step01 = act ;
           exsr s01act ;
         endsl;
       endsr;
       //--- Clear Subfile  ----------------------------------------------------
       begsr s01prp;
         RRn01 = 0;
         sflclr = *on;
         write ctl01;
         sflclr = *off;
         exec sql declare c1 cursor for
           SELECT ORID, ORYEAR,
                  ISOTODATE40(ORDATE) AS DATORD,
                  ISOTODATE40(ORDATDEL) AS DATLIV,
                  ISOTODATE40( ORDATCLO) AS DATCLO ,
                  Totval
           FROM Ordercus
           Where orcuid  = :cuid
           order by datord desc;
         exec sql open c1;
         step01 = lod;
       endsr;
       //--- Load Subfile  -----------------------------------------------------
       begsr s01lod;
         RRb01 = RRn01 + 1;
         opt01 = 0;
         exec sql fetch c1 into :orid, :oryear, :datord,
                                :datliv, :datclo, :sumord;
         dow sqlcod = 0;
           RRN01 += 1;
           write sfl01;
           exec sql fetch c1 into :orid, :oryear, :datord,
                                :datliv, :datclo, :sumord;
         enddo;
         exec sql close c1;
         sflend = *on ;
         step01 = dsp;
       endsr;
       //--- Display Subfile  --------------------------------------------------
       begsr s01dsp;
         sfldspctl = *on;
         sfldsp = RRn01 > 0;

         write key01;
         exfmt ctl01;
         if LRRN <>0;
           RRb01 = LRRN;
         endif;
         step01 = key;
       endsr;
       //--- Command Keys  -----------------------------------------------------
       begsr s01key;
         select;
         when exit;
           panel  = 0;
           step01 = prp;
         when cancel;
           step01 = prp;
           panel  = panel  - 1;
         when create;
           newOrder(cuid);
           step01 = prp;
         other;
           step01 = chk;
         endsl;
       endsr;
       //--- Check Subfile  ----------------------------------------------------
       begsr s01chk;
         step01 = act;
         err01 = *off;
         sflnxtchg = *on;
         readc(e) sfl01;
         dow not %error and not %eof;
           if opt01 = 1  or opt01 = 3  or  opt01  > 8;
             step01 = dsp;
             dspatr_ri = *on;
             sflmsg = *on;
             if not err01;
               rrb01 = rrn01;
               err01 = *on;
             endif;
           endif;
           if opt01 = 7 and datclo > datBlank
             or opt01 = 8 and datliv > datBlank;
             step01 = dsp;
             dspatr_ri = *on;
             sflmsg = *on;
             if not err01;
               rrb01 = rrn01;
               err01 = *on;
             endif;
           endif;
           if opt01 = 2 or opt01 = 4 and datclo > datBlank;
             step01 = dsp;
             dspatr_ri = *on;
             sflmsg2 = *on;
             if not err01;
               rrb01 = rrn01;
               err01 = *on;
             endif;
           endif;
           if opt01 = 4;
             setll orid detord1;
             reade(n) orid detord1;
             dow not %eof();
               if odqtyliv > 0;
                 step01 = dsp;
                 dspatr_ri = *on;
                 sflmsg3 = *on;
                 if not err01;
                   rrb01 = rrn01;
                   err01 = *on;
                 endif;
                 leave;
               endif;
               reade(n) orid detord1;
             enddo;
           endif;
           update sfl01;
           dspatr_ri = *off;
           readc(e) sfl01;
         enddo;
         sflnxtchg = *off;
       endsr;
       //--- action Subfile  ---------------------------------------------------
       begsr s01act;
         readc(e) sfl01;
         select;
         when %error or %eof;
           step01 = dsp;
         when opt01 = 2;
           Updord(orid);
           opt01 = 0;
           update sfl01;
         when opt01 = 4;
           delete orid order1;
           dou not %found();
             delete orid detord1;
           enddo;
           opt01 = 0;
           update sfl01;
         when opt01 = 5;
           dspord(orid);
           opt01 = 0;
           update sfl01;
         when opt01 = 6;
           Prtord(orid);
           opt01 = 0;
           update sfl01;
         when opt01 = 7;
           chain (orid) order1;
           if ordatdel = 0;
             ordatdel = %dec(%date():*iso);
             datliv = %date();
           endif;
           ordatclo = %dec(%date():*iso);
           update forde;
           datclo = %date();
           opt01 = 0;
           update sfl01;
         when opt01 = 8;
           chain (orid) order1;
           ordatdel = %dec(%date():*iso);
           datliv = %date();
           update forde;
           setll orid detord1;
           reade orid detord1;
           dow not %eof();
             if odqtyliv = 0;
               odqtyliv = odqty;
               update fdeto;
             else;
               unlock detord1;
             endif;
             reade orid detord1;
           enddo;
           opt01 = 0;
           update sfl01;
         other;

         endsl;
       endsr;

       //--------INITIALIZATION ----------------------------------
       begsr *inzsr;
         datord = datBlank;
         datclo = datBlank;
         datliv = datBlank;
         chain cuid custome1;
       endsr;
       //--------END SUBROUTINE ----------------------------------
       begsr pnl00;
         *inlr = *on;
       endsr;
      /end-free
