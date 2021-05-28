
     fprovide1  if   e           k disk
     fpro202d   cf   e             workstn
     F                                     indds(indds)
     F                                     sfile(sfl01:rrn01)
     F                                     Infds(Info)

      /copy qprotosrc,xml
      /copy qprotosrc,parameter

     d pro202          pr
     d  id                                 like(prid)
     d pro202          pi
     d  id                                 like(prid)

     D indds           ds
     D  help                   1      1n
     D  exit                   3      3n
     D  prompt                 4      4n
     D  refresh                5      5n
     D  confirm                8      8n
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
     d mode            s              3

     d prp             c                   'prp'
     d lod             c                   'lod'
     d dsp             c                   'dsp'
     d key             c                   'key'
     d chk             c                   'chk'
     d act             c                   'act'

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
         exec sql declare c2 cursor for
           SELECT ARID, ARDESC, arstock, ARMINQTY,
                  ARCUSQTY, ARPURQTY, APPRICE, apref
           FROM article, artiprov
           WHERE arstock < ARMINQTY - arcusqty + arpurqty
             and arid = aparid
             AND apprid = :id
           order by arid ;
         exec sql open c2;
         step01 = lod;
         rrs01 = 0;
       endsr;
       //--- Load Subfile  -----------------------------------------------------
       begsr s01lod;
         rrn01 = rrs01;
         RRb01 = RRn01 + 1;
         exec sql fetch c2 into :arid, :ardesc, :arstock, :arminqty,
                                :ARCUSQTY, :ARPURQTY, :APPRICE, :APREF;
         dow sqlcod = 0;
           neword = ARMINQTY + ARCUSQTY - arpurqty - arstock;
           name25 = ardesc;
           RRN01 += 1;
           write sfl01;
           exec sql fetch c2 into :arid, :ardesc, :arstock, :arminqty,
                                :ARCUSQTY, :ARPURQTY, :APPRICE, :APREF;
         enddo;
         sflend = *on;
         step01 = dsp;
         rrs01 = rrn01;
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
         when pagedown;
           step01 = lod;
         other;
           step01 = chk;
         endsl;
       endsr;
       //--- Check Subfile  ----------------------------------------------------
       begsr s01chk;
         step01 = act;
       endsr;
       //--- action Subfile  ---------------------------------------------------
       begsr s01act;
         if confirm;
           fileName = 'Pur_Ord_' + %trim(%char(prid)) + '_' +
                      %char(%dec(%date:*YMD)) + '.xml';
           path = getParm2('PATH':' ');
           xmlopen(%trim(path) + fileName);
           xmlStrTable('PURODR');
           XmlStrRec('Customer');
           xmladdcol('NAME':'SAMPLE Company');
           xmladdcol('ADDRES':'55, rue Adrastee');
           xmladdcol('ZIPCODE':'F-74650');
           xmladdcol('CITY':'Chavanod');
           xmlendrec('Customer');
           rrn01 = 1;
           chain rrn01 sfl01;
           dow %found();
             xmlstrRec('Item');
             xmladdcol('ID':arid);
             xmladdcol('YOUR_REF':apref);
             xmladdcol('DESC':ardesc);
             xmladdcol('QTY':%char(neword));
             xmladdcol('UnitPrice':%editc(apprice:'2'));
             XmlEndRec('Item');
             rrn01 += 1;
             chain rrn01 sfl01;
           ENDDO;
           xmlEndTable('PURODR');
           xmlclose();
           exfmt fmt03;
           panel = 0;
         else;
           step01 = dsp;
         endif;

       endsr;

       //--------INITIALIZATION ----------------------------------
       begsr *inzsr;
         chain prid provide1;
       endsr;
       //--------END SUBROUTINE ----------------------------------
       begsr pnl00;
         exec sql close c2;
         *inlr = *on;
       endsr;
      /end-free
