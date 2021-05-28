     h nomain

     Ffamilly   IF   E           K DISK
     Ffamill1   IF   E           K DISK
     F                                     RENAME(ffami   :REC52)
     Ffam301d   CF   E             WORKSTN
     F                                     INFDS(INFO)
     F                                     SFILE(SFL01:RRN01)
     F                                     indds(indds)
     D INFO            DS
     D  LRRN                 378    379B 0

      /copy qprotosrc,familly

     D indds           ds
     D  help                   1      1n
     D  exit                   3      3n
     D  prompt                 4      4n
     D  refresh                5      5n
     D  create                 6      6n
     D  cf08                   8      8n
     D  cancel                12     12n
     D  morekeys              24     24n
     D  pagedown              25     25n
     D  sflclr                30     30n
     D  sfldsp                31     31n
     D  sfldspctl             32     32n
     D  sflnxtchg             33     33n
     D  dspatrri              34     34n
     D  InvalidOpt            35     35n
     D  OneSelect             36     36n
     D  bydesc                40     40n
     D  InvalidOptC           41     41n
     D  NotAvail              42     42n
     D  sflend                80     80n

     D rrn01           s              5i 0

     d prp             c                   'prp'
     d lod             c                   'lod'
     d dsp             c                   'dsp'
     d key             c                   'key'
     d chk             c                   'chk'
     d chkctl          c                   'chc'
     d actctl          c                   'acc'
     d act             c                   'act'


      *=============================================
     P sltArtFam       B                   export
     D sltArtFam       PI                  like(faid      )
     d pcod                                like(faid      )
     D dft             S                   like(faid      )
     D step01          S              3    inz(prp)
     d in08            s               n
     d sts01           s               n
     D rrs01           s              5i 0
     D teller          s              5i 0
     D err01           s               n
     D slt01           s               n
     d keycod          s                    like(faid       )
     d savcod          s                    like(faid       )
     d pdes            s                    like(fadesc     )
     d keydes          s                    like(fadesc     )
     d savdes          s                    like(fadesc     )
      /free
       if not %open(fam301d   );
         open fam301d    ;
       endif;
       keycod = pcod;
       dft = pcod;
       bydesc = *off;
       dow step01 <> ' ';
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
       enddo;
       return dft;
       //--- Clear Subfile  -----------------------------------------------------

       begsr s01prp;
         RRS01 = 0;
         clear CTL01;
         sflclr = *on;
         sfldsp = *off;
         sfldspctl = *off;
         write CTL01;
         sflclr = *off;
         if not bydesc;
           setll KEYCOD familly   ;
           read familly;
           sflend = %EOF;
         else;
           setll KEYDES famill1   ;
           read famill1    ;
           SflEnd = %EOF;
         endif;
         SAVCOD = faid  ;
         SAVDES = fadesc;
         Step01 = lod;
       endsr;
       //--- Load Subfile  -----------------------------------------------------
       begsr S01lod;
         RRN01 = RRS01;
         RRB01 = RRS01 + 1;
         TELLER = 0;
         OPT01 = 0;
         SflNxtChg = *OFF;
         faid   = SAVCOD;
         fadesc = SAVDES;
         dow not sflend
               and TELLER < 20;
           RRN01 = RRN01 + 1;
           TELLER = TELLER + 1;
           write SFL01;
           if not bydesc;
             read familly   ;
           else;
             read famill1   ;
           endif;
           SflEnd = %EOF;
         enddo;
         SAVCOD = faid  ;
         SAVDES = fadesc;
         RRS01 = RRN01;
         Step01 = dsp;
       endsr;
       //--- Display Subfile  --------------------------------------------------
       begsr S01dsp;
         sfldsp = rrs01 > 0;
         sfldspctl = *on;
         write KEY01;
         exfmt CTL01;
         IN08 = CF08;
         RRB01 = LRRN;
         Step01 = key;
       endsr;
       //--- Command Keys  -----------------------------------------------------
       begsr S01key;
         select;
         when exit;
           step01 = ' ';
         when cancel ;
           Step01 = ' ';
         when PageDown;
           Step01 = lod;
         other;
           Step01 = chk;
         endsl;
       endsr;
       //--- Check Subfile  ----------------------------------------------------
       begsr S01chk;
         // SET FLAG SELECTION MADE OFF
         SLT01 = *OFF;
         // SET FLAG OPTION  MADE OFF
         STS01 = *OFF;
         // SET FLAG ERROR   MADE OFF
         ERR01 = *OFF;
         Step01 = act;
         readc(E) SFL01;
         SflNxtChg = *ON;
         dow not %error and not %eof;
           select;
           when OPT01 = 0;
             // NO ERROR
           when OPT01 <>1;
             STS01 = *ON;
             Step01 = dsp;
             dspatrRi = *on;
             InvalidOpt= *on;
             if ERR01 = *OFF;
               RRB01 = RRN01;
               ERR01 = *ON;
             endif;
             //OPTION = 1 BUT SELECTION ALREADY MADE
           when SLT01 = *ON;
             Step01 = dsp;
             dspatrRi = *on;
             OneSelect = *on;
             if ERR01 = *OFF;
               RRB01 = RRN01;
               ERR01 = *ON;
             endif;
           other;
             //OPTION = 1
             SLT01 = *ON;
             STS01 = *ON;
           endsl;
           update SFL01;
           dspatrRi = *off;
           readc SFL01;
         enddo;
         select;
         when OPTC1 <>8
               and OPTC1 <>0;
           InvalidOptC = *ON;
           Step01 = dsp;
         when SLT01 = *ON
               and OPTC1 <>0;
           NotAvail = *ON;
           Step01 = dsp;
         when STS01 = *ON
               and IN08 = *ON;
           Step01 = dsp;
         endsl;
       endsr;
       //--- Write Subfile  ----------------------------------------------------
       begsr S01act;
         Step01 = dsp;
         select;
         when IN08 ;
           Step01 = prp;
           bydesc = not bydesc;
           if bydesc;
             clear KEYCOD;
           else;
             clear KEYDES;
           endif;
         when OPTC1 = 8;
           Step01 = prp;
           if not bydesc;
             KEYCOD = POSCOD;
           else;
             KEYDES = POSDES;
           endif;
         other;
           readc(E) SFL01;
           dow not %error and not %eof;
             if OPT01 = 1;
               return faid      ;
             endif;
             readc SFL01;
           enddo;
         endsl;
       endsr;

      /end-free
     p sltArtFam       e
