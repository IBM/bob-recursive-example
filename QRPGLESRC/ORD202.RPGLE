
     h dftactgrp(*no) bnddir('SAMPLE')

     fcustome1  if   e           k disk
     farticle1  if   e           k disk
     fdetord1   if   e           k disk
     forder1    if   e           k disk
     ford202d   cf   e             workstn
     F                                     indds(indds)
     F                                     sfile(sfl01:rrn01)
     F                                     Infds(Info)

     d ord202          pr
     d  id                                 like(orid)
     d ord202          pi
     d  id                                 like(orid)
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
     D  sflend                80     80n

     D info            ds
     D  lrrn                 378    379i 0

     D rrn01           s              5i 0
     D rrs01           s              5i 0
     D err01           s               n

     D panel           S              3i 0 INZ(1)
     D step01          S              3    inz(prp)
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
         when step01 = act ;
           exsr s01act ;
         endsl;
       endsr;
       //--- Clear Subfile  ----------------------------------------------------
       begsr s01prp;
         chain id order1;
         chain orcuid custome1;
         datord = %date(ordate:*iso);
         if ordatdel > 0;
           datliv = %date(ordatdel:*iso);
         endif;
         if ordatclo > 0;
           datclo = %date(ordatclo:*iso);
         endif;
         RRn01 = 0;
         sflclr = *on;
         write ctl01;
         sflclr = *off;
         step01 = lod;
       endsr;
       //--- Load Subfile  -----------------------------------------------------
       begsr s01lod;
         RRb01 = RRn01 + 1;
         tot = 0;
         totvat = 0;
         setll id detord1;
         reade id detord1;
         dow not %eof(detord1);
           tot += odtot;
           totvat += odtotvat;
           chain odarid article1;
           RRN01 += 1;
           write sfl01;
           reade id detord1;
         enddo;
         sflend = *on;
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
           panel  = 0 ;
         other;
           step01 = act;
         endsl;
       endsr;
       //--- action Subfile  ---------------------------------------------------
       begsr s01act;
         panel = 0;
       endsr;

       //--------INITIALIZATION ----------------------------------
       begsr *inzsr;
         datord = datBlank;
         datclo = datBlank;
         datliv = datBlank;
       endsr;
       //--------END SUBROUTINE ----------------------------------
       begsr pnl00;
         *inlr = *on;
       endsr;
      /end-free
