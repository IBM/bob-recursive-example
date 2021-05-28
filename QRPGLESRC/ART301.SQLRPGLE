     h nomain

     Fart301d   CF   E             WORKSTN
     F                                     INFDS(INFO)
     F                                     SFILE(SFL01:RRN01)
     F                                     indds(indds)
     D INFO            DS
     D  LRRN                 378    379B 0

      /copy qprotosrc,article
      /copy qprotosrc,familly

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
     D  dspatrri              34     34n
     D  InvalidOpt            35     35n
     D  OneSelect             36     36n
     D  bydesc                40     40n
     D  InvalidOptC           41     41n
     D  NotAvail              42     42n
     D  sflend                80     80n

     d  data           ds                  inz
     d   arid                         6
     d   ardesc                      50
     d   artifa                       3
     d   arsalePr                     7  2

     D rrn01           s              5i 0

     d prp             c                   'prp'
     d lod             c                   'lod'
     d dsp             c                   'dsp'
     d key             c                   'key'
     d chk             c                   'chk'
     d act             c                   'act'


      *=============================================
     P sltarticle      B                   export
     D sltarticle      PI             6
     d pcod                           6    value

     d  savData        ds                  likeds(data)

     D dft             S                   like(arid      )
     D step01          S              3    inz(prp)
     d in08            s               n
     d sts01           s               n
     D rrs01           s              5i 0
     D teller          s              5i 0
     D err01           s               n
     D slt01           s               n
     d savDesc         s             10
     d savFam          s                    like(artifa     )
     d stm             s            500     varying
      /free
       if not %open(art301d   );
         open art301d    ;
       endif;
       dft = pcod;
       famdesc = '<F4> to select.';
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
       exec sql close c1;
       return dft;
       //--- Clear Subfile  -----------------------------------------------------

       begsr s01prp;
         RRS01 = 0;
         sflclr = *on;
         sfldsp = *off;
         sfldspctl = *off;
         write CTL01;
         sflclr = *off;
         stm =  'SELECT arid, ardesc, artifa, arsalepr FROM article ';
         if srchDesc <> ' ' and srchFam <> ' ';
           stm +=  ' WHERE artifa = ''' + srchfam +
                   ''' AND UPPER(arDesc) like ''%' + %trim(srchDesc) +
                  '%'' ';
         elseif srchDesc <> ' ' ;
           stm += ' WHERE UPPER(arDesc) like ''%' + %trim(srchDesc) +
                  '%'' ';
         elseif srchFam <> ' ';
           stm +=  ' WHERE artifa = ''' + srchfam + ''' ';
         endif;
         stm += ' ORDER BY arDesc';
         SAVDesc = srchDesc;
         SAVFam  = srchFam ;
         Step01 = lod;
         exec sql prepare s1 from :stm;
         exec sql declare C1 cursor for s1;
         exec sql open c1;
         exec sql fetch c1 into :data;
         savData = data;
       endsr;
       //--- Load Subfile  -----------------------------------------------------
       begsr S01lod;
         RRN01 = RRS01;
         Data = Savdata;
         RRB01 = RRS01 + 1;
         TELLER = 0;
         OPT01 = 0;
         SflNxtChg = *OFF;
         dow sqlcod = 0
               and TELLER < 14;
           RRN01 = RRN01 + 1;
           TELLER = TELLER + 1;
           write SFL01;
           exec sql fetch c1 into :data;
         enddo;
         sflend = sqlcod <> 0;
         savData = data;
         RRS01 = RRN01;
         Step01 = dsp;
       endsr;
       //--- Display Subfile  --------------------------------------------------
       begsr S01dsp;
         sfldsp = rrs01 > 0;
         sfldspctl = *on;
         write KEY01;
         exfmt CTL01;
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
         when prompt;
           srchfam = sltArtFam(SrchFam);
           famdesc = getArtFamDesc(SrchFam);
           exec sql close c1;
           step01 = prp;
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
       endsr;
       //--- Write Subfile  ----------------------------------------------------
       begsr S01act;
         Step01 = dsp;
         select;
         when savDesc <> srchDesc or savfam  <> srchfam ;
           Step01 = prp;
           exec sql close c1;
         other;
           readc(E) SFL01;
           dow not %error and not %eof;
             if OPT01 = 1;
               exec sql close c1;
               return arid      ;
             endif;
             readc SFL01;
           enddo;
         endsl;
       endsr;
      /end-free

     p sltarticle      e


