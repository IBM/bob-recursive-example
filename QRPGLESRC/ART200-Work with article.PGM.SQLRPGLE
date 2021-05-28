
     h dftactgrp(*no) bnddir('SAMPLE')

     farticle2  if   e           k disk    rename(farti:farti2)
     farticle1  uf a e           k disk
     fart200d   cf   e             workstn
     F                                     indds(indds)
     F                                     sfile(sfl01:rrn01)
     F                                     Infds(Info)

      /copy qprotosrc,familly

     d providers       pr                  extpgm('ART201')
     d  id                                 like(arid)

     D indds           ds
     D  help                   1      1n
     D  exit                   3      3n
     D  prompt                 4      4n
     D  refresh                5      5n
     D  Create                 6      6n
     D  cancel                12     12n
     D  morekeys              24     24n
     D  pagedown              25     25n
     D  sflclr                30     30n
     D  sfldsp                31     31n
     D  sfldspctl             32     32n
     D  sflnxtchg             33     33n
     D  dspatr_ri             34     34n
     D  sflmsg                35     35n
     D  errFamilly            40     40n
     D  errDesc               41     41n
     D  sflend                80     80n

     D info            ds
     D  lrrn                 378    379i 0

     D rrn01           s              5i 0
     D rrs01           s              5i 0
     D err01           s               n

     D panel           S              3i 0 INZ(1)
     D step01          S              3    inz(prp)
     D step02          S              3    inz(prp)
     D step03          S              3    inz(prp)
     d savId           s                   like(arid)
     d savDesc         s                   like(ardesc)
     d NewId           s              6  0
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
      /free

       select;
       when panel = 1;
         exsr pnl01;
       when panel = 2;
         exsr pnl02;
       when panel = 3;
         exsr pnl03;
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
         step01 = lod;
         clear savid;
         savDesc = posTo;
         clear posTo;
         rrs01 = 0;
       endsr;
       //--- Load Subfile  -----------------------------------------------------
       begsr s01lod;
         exsr s01rst;
         RRb01 = RRn01 + 1;
         opt01 = 0;
         count = 0;
         read article2;
         dow not %eof(article2) and count < 14;
           RRN01 += 1;
           count += 1;
           write sfl01;
           read article2;
         enddo;
         sflend = %eof(article1);
         step01 = dsp;
         exsr s01sav;
       endsr;
       //--- restore last read -------------------------------------------------
       begsr s01rst;
         setll (savdesc:savid)  article2;
         rrn01 = rrs01;
       endsr;
       //--- Save last read -------------------------------------------------
       begsr s01sav;
         savid = arid;
         savdesc = ardesc;
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
         when create;
           step01 = prp;
           panel  = 2 ;
           step02 = prp;
           mode = crt;
         when pagedown;
           step01 = lod;
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
           if opt01  > 6 or opt01 = 1 or opt01 = 5;
             step01 = dsp;
             dspatr_ri = *on;
             sflmsg = *on;
             if not err01;
               rrb01 = rrn01;
               err01 = *on;
             endif;
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
           if posto > ' ';
             step01 = prp;
           else;
             step01 = dsp;
           endif;
         when opt01 = 2;
           panel = 2;
           step02 = prp;
           opt01 = 0;
           update sfl01;
           mode = upd;
         when opt01 = 3;
           panel = 3;
           step02 = prp;
           opt01 = 0;
           update sfl01;
         when opt01 = 4;
           chain arid article1;
           ardel = 'X';
           armod = %timestamp();
           armodid = user;
           update farti;
           step02 = dsp;
           opt01 = 0;
           update sfl01;
         when opt01 = 6;
           providers(arid);
           opt01 = 0;
           update sfl01;
         other;

         endsl;
       endsr;


       //--- Format 02 Subroutines ------------------------------------     ---
       begsr pnl02;
         select ;
         when step02 = prp ;
           exsr s02prp;
         when step02 = dsp ;
           exsr s02dsp;
         when step02 = key ;
           exsr s02key;
         when step02 = chk ;
           exsr s02chk;
         when step02 = act ;
           exsr s02act ;
         endsl;

       endsr;
       //--- clear & Load ------------------------------------------------------
       begsr S02prp;
         if mode = crt;
           setgt *hival article1;
           readp article1;
           Newid = %dec(arid :6: 0)  +1;
           reset farti;
           arid = %editc(NewId:'X');
         else;
           chain arid article1;
           famdesc = getArtFamDesc(artifa);
         endif;
         step02 = dsp;
       endsr;
       //--- Display  ----------------------------------------------------------
       begsr S02dsp;
         exfmt fmt02;
         step02 = key;
       endsr;
       //--- command Keys  -----------------------------------------------------
       begsr S02key;
         select;
         when exit;
           panel  = 1;
           step02 = prp;
         when cancel;
           step02 = prp;
           panel  = panel  - 1;
         when prompt;
           artifa = sltArtFam(artifa);
           famdesc = getArtFamDesc(artifa);
           step02 = dsp;
         other;
           step02 = chk;
         endsl;
       endsr;
       //--- check -------------------------------------------------------------
       begsr S02chk;
         step02 = act;
         if ardesc = ' ';
           errDesc = *on;
           step02 = dsp;
         endif;
         if not existArtFam(artifa);
           errFamilly = *on;
           step02 = dsp;
         endif;

       endsr;
       //--- Action ------------------------------------------------------------
       begsr S02act;
         step02 = prp;
         armod = %timestamp();
         armodid = user;
         if mode = upd;
           update farti;
         else;
           arcrea = %date();
           write(e) farti;
           dow %error;
             Newid += 1;
             arid = %editc(NewId:'X');
             write(e) farti;
           enddo;
           savdesc = ardesc;
           savId = arid;
           step01 = lod;
         endif;
         panel = 1;
       endsr;

       //--- Format 03 Subroutines ------------------------------------     ---
       begsr pnl03;
         select ;
         when step03 = prp ;
           exsr s03prp;
         when step03 = dsp ;
           exsr s03dsp;
         when step03 = key ;
           exsr s03key;
         when step03 = chk ;
           exsr s03chk;
         when step03 = act ;
           exsr s03act ;
         endsl;

       endsr;
       //--- clear & Load ------------------------------------------------------
       begsr S03prp;
         exec sql set option commit = *none;
         exec sql select ARTICLE_INFORMATION into :text
                  FROM artiinf
                  WHERE ARTICLE_INFO_ID = :arid;
         if sqlcod <> 0;
           mode = crt;
           clear text;
         else;
           mode = upd;
         endif;
         step03 = dsp;
       endsr;
       //--- Display  ----------------------------------------------------------
       begsr S03dsp;
         exfmt fmt03;
         step03 = key;
       endsr;
       //--- command Keys  -----------------------------------------------------
       begsr S03key;
         select;
         when exit;
           panel  = 1;
           step03 = prp;
         when cancel;
           step03 = prp;
           panel  = 1;
         other;
           step03 = chk;
         endsl;
       endsr;
       //--- check -------------------------------------------------------------
       begsr S03chk;
         step03 = act;
       endsr;
       //--- Action ------------------------------------------------------------
       begsr S03act;
         step03 = prp;
         panel = 1;
         if mode = upd;
           exec sql update artiinf
                  set ARTICLE_INFORMATION = trim(:text)
                  WHERE ARTICLE_INFO_ID = :arid;
         else;
           exec sql insert into artiinf
                    Values(:arid, trim(:text));
         endif;
       endsr;
       //--------INITIALIZATION ----------------------------------
       begsr *inzsr;
       endsr;
       //--------END SUBROUTINE ----------------------------------
       begsr pnl00;
         *inlr = *on;
       endsr;
      /end-free
