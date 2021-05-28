      *       Before compilation
      *       ovrdbf tmpdetord detord

     h dftactgrp(*no) bnddir('SAMPLE')


     forder     o    e             disk
     fdetord    o    e           k disk
     fTmpdetord uf a e           k disk    rename(fdeto:tmprec)
     ford100d   cf   e             workstn
     F                                     indds(indds)
     F                                     sfile(sfl01:rrn01)
     F                                     Infds(Info)

      /copy qprotosrc,customer
      /copy qprotosrc,article
      /copy qprotosrc,vat

     d  ord100         pr
     d   cuid                              options(*NOPASS)
     d                                     like(orcuid)

     d  ord100         pi
     d   cuid                              options(*NOPASS)
     d                                     like(orcuid)

     d Prtord          pr                  extpgm('ORD500')
     d  x                                  like(orid)

     D info            ds
     D  lrrn                 378    379i 0

     D indds           ds
     D  help                   1      1n
     D  exit                   3      3n
     D  prompt                 4      4n
     D  refresh                5      5n
     D  create                 6      6n
     D  confirm                8      8n
     D  cancel                12     12n
     D  morekeys              24     24n
     D  pagedown              25     25n
     D  change                27     27n
     D  sflclr                30     30n
     D  sfldsp                31     31n
     D  sfldspctl             32     32n
     D  sflnxtchg             33     33n
     D  dspatr_ri             34     34n
     D  sflmsg                35     35n
     D  sflmsg2               36     36n
     D  sflend                80     80n

     d Ordno           s              6s 0 DTAARA('LASTORDNO')

     D panel           S              3  0 INZ(1)
     D step01          S              3    inz(prp)
     D step02          S              3    inz(prp)
     D rrn01           s              5i 0
     D count           s              3  0
     D err01           s               n

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
          tot = 0;
          totvat = 0;
        endsr;
        //--- Load Subfile  -----------------------------------------------------
        begsr s01lod;
          RRb01 = RRn01 + 1;
          opt01 = 0;
          setll *loval tmpdetord;
          read  tmpdetord;
          dow not %eof;
            tot += odtot;
            totvat += odtotvat;
            RRN01 = RRN01 + 1;
            artdesc = GetArtDesc(odarid);
            line = odline;
            write sfl01;
            read  tmpdetord;
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
            panel  = panel  - 1;
          when refresh;
            step01 = prp;
          when create;
            panel = 2;
            step02 = prp;
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
            if opt01 <> 0 and opt01 <> 2 and opt01 <> 4;
              step01 = dsp;
              dspatr_ri = *on;
              sflmsg = *on;
              if not err01;
                rrb01 = rrn01;
                err01 = *on;
              endif;
            endif;
            if confirm and (opt01 = 2 or opt01 = 4) ;
              step01 = dsp;
              dspatr_ri = *on;
              sflmsg2 = *on;
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
          if confirm;
            in *lock ordno;
            ordno += 1;
            out ordno;
            ORID = ordno;
            ORYEAR  = *year;
            ORDATE = %dec(%date():*iso);
            ORDATDEL = 0;
            ORDATCLO = 0;
            write forde;
            odorid = orid;
            setll *loval tmpdetord;
            read  tmpdetord;
            count = 0;
            dow not %eof;
              odorid = orid;
              count += 1;
              odline = count;
              write fdeto;
              read  tmpdetord;
            enddo;
            prtOrd(orid);
            exfmt fmt03;
            panel = 0;
            leavesr;
          ENDIF;
          readc(e) sfl01;
          select;
          when %error or %eof;
            step01 = dsp;
          when opt01 = 2;
            panel = 2;
            step02 = prp;
          when opt01 = 4;
            tot -= odtot;
            totvat -= odtotvat;
            delete (line) tmpdetord;
            opt01 = 0;
            odarid = ' ';
            odqty = 0;
            odprice = 0;
            odtot = 0;
            artdesc = '**** Delete ***';
            update sfl01;
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
          if create;
            odarid = sltArticle(' ');
            if odarid = ' ';
              panel = 1;
              step02 = prp;
            ENDIF;
            odqty = 1;
            odprice = GetArtRefSalPrice(odarid);
            odtot =  odqty * odprice;
            count += 1;
            odline = count;
          else;
            chain (line) tmpDetord;
          ENDIF;
          artdesc = GetArtDesc(odarid);
          vat = CLCVat(GetArtVatCode(odarid):odtot);
          odtotvat = odtot + vat;
          vatRate = GetVatRate(GetArtVatCode(odarid));
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
          other;
            step02 = chk;
          endsl;
        endsr;
        //--- check -------------------------------------------------------------
        begsr S02chk;
          step02 = act;
          odtot =  odqty * odprice;
          vat = CLCVat(GetArtVatCode(odarid):odtot);
          odtotvat = odtot + vat;
        endsr;
        //--- Action ------------------------------------------------------------
        begsr S02act;
          if change;
            step02 = dsp;
          else;
            if create;
              write tmprec;
              step01 = prp;
            else;
              update tmprec;
              opt01 = 0;
              update sfl01;
              step01 = dsp;
            ENDIF;
            panel = 1;
          endif;
        endsr;



        //--------INITIALIZATION ----------------------------------
        begsr *inzsr;
          panel = 2;
          if %parms = 0 or cuid = 0;
            orcuid = SltCustomer(0);
            if orcuid = 0;
              panel = 0;
             endif;
           else;
             orcuid = cuid;
           endif;
           CUSTNAME = GetCusName(orcuid);
           create = *on;
           count = 0;
        endsr;
        //--------END SUBROUTINE ----------------------------------
        begsr pnl00;
          *inlr = *on;
        endsr;
      /end-free

