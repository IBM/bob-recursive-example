
     h dftactgrp(*no) bnddir('SAMPLE')

     fcustome2  if   e           k disk    rename(fcust:fcust2)
     fcustome1  uf a e           k disk
     fcus200d   cf   e             workstn
     F                                     indds(indds)
     F                                     sfile(sfl01:rrn01)
     F                                     Infds(Info)

      /copy qprotosrc,country

     d orders          pr                  extpgm('ORD200')
     d  id                                 like(cuid)

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
     D  ErrCountry            40     40n
     D  ErrName               41     41n
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
     d savId           s                   like(cuid)
     d savName         s                   like(custnm)
     d User            s             10    inz(*user)
     d count           s              3i 0

     d crt             c                   'CRT'
     d upd             c                   'UPD'
     d prp             c                   'prp'
     d lod             c                   'lod'
     d dsp             c                   'dsp'
     d key             c                   'key'
     d chk             c                   'chk'
     d chkctl          c                   'chc'
     d actctl          c                   'acc'
     d act             c                   'act'
     d datBlank        c                   d'1940-01-01'
      /free
       select;
       when panel = 1;
         exsr pnl01;
       when panel = 2;
         exsr pnl02;
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
         savName = posTo;
         clear posTo;
         rrs01 = 0;
       endsr;
       //--- Load Subfile  -----------------------------------------------------
       begsr s01lod;
         exsr s01rst;
         RRb01 = RRn01 + 1;
         opt01 = 0;
         count = 0;
         read custome2;
         dow not %eof(custome2) and count < 14;
           RRN01 += 1;
           count += 1;
           write sfl01;
           read custome2;
         enddo;
         sflend = %eof(custome2);
         step01 = dsp;
         exsr s01sav;
       endsr;
       //--- restore last read -------------------------------------------------
       begsr s01rst;
         setll (savName:savid)  custome2;
         rrn01 = rrs01;
       endsr;
       //--- Save last read -------------------------------------------------
       begsr s01sav;
         savid = cuid;
         savName = custNm;
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
         when refresh;
           step01 = prp;
         when create;
           step01 = dsp;
           panel  = 2;
           step02 = dsp;
           mode = CRT;
           reset fcust;
           exec sql set :Cuid  = NEXT VALUE FOR CusSeq     ;
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
           if opt01  <> 0 and opt01  <> 2 and opt01  <> 5;
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
           if posto <> ' ';
             step01 = prp;
           else;
             step01 = dsp;
           endif;
         when opt01 = 2;
           mode = upd;
           panel = 2;
           step02 = prp;
           opt01 = 0;
           update sfl01;
         when opt01 = 5;
           orders(cuid);
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
         chain cuid custome1;
         coname = GetCountryName(CuCoun);
         if CULASTORD = 0;
           LASTORD = datBlank;
         else;
           LASTORD  =%date(CULASTORD:*iso);
         ENDIF;
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
           step02 = dsp;
           cucoun = SltCountry(cucoun);
           coname = GetCountryName(CuCoun);
         other;
           step02 = chk;
         endsl;
       endsr;
       //--- check -------------------------------------------------------------
       begsr S02chk;
         step02 = act;
         if not ExistCountry(cucoun);
           errCountry = *on;
           step02 = dsp;
         endif;
         if custnm = *blanks;
           errName = *on;
           step02 = dsp;
         endif;

       endsr;
       //--- Action ------------------------------------------------------------
       begsr S02act;
         step02 = prp;
         cumod = %timestamp();
         if mode = upd;
           update fcust;
         else;
           write fcust;
         endif;
         panel = 1;
       endsr;

       //--------INITIALIZATION ----------------------------------
       begsr *inzsr;
         cumodid = user;
         cucrea = %date();
         LASTORD = datblank;
       endsr;
       //--------END SUBROUTINE ----------------------------------
       begsr pnl00;
         *inlr = *on;
       endsr;
      /end-free
