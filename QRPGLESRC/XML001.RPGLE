      *%CSTD===========================================================*
      ** Application. : ARC_DEMO   PRD:Tools used by Demo appli.       *
      ** Composant. . : XML001                        Type: RPGLE      *
      **===============================================================*
      ** Sous-système :                                                *
      ** Fonction . . :                                                *
      ** Sous-fonction:                                                *
      **%S=============================================================*
      ** Description des fonctionnalités:                              *
      **                                                               *
      **                                                               *
      **                                                               *
      **%E=============================================================*
      ** AUTEUR:    VTAQUIN    14/06/2017 17:04  01.00.09              *
      ** MODIFS: ** VTAQUIN    14/06/2017   :    01.00.09    00/       *
      *%ECSTD==========================================================*

     H nomain

     D addentry        pr

     D chgvar          pr
     D                                1    const
     D                               10    const
     D                              200

      /copy qprotosrc/xml
      /copy qprotosrc/txt

     D replacement     ds
     D  aa                           10    dim(64) ctdata perrcd(1)
     d   char                         1    overlay(aa)
     d*                               1    overlay(aa:*next)
     d   unicode                      8    overlay(aa:*next)

     d data            s            300
     d ifs             s               n
     d id              s             10i 0

     d c1              c                   '<?xml version="1.0" encoding="UTF-8+
     d                                     " standalone="yes" ?>'
     d S1              c                   '<'
     d s2              c                   '>'
     d slash           c                   '/'
     d EOR             c                   X'0D25'


      //--------------------------------------
      // Procedure name: xmlStrTable
      // Purpose:
      // Parameter:      Table =>
      //--------------------------------------
     P xmlStrTable     B                   EXPORT
     D xmlStrTable     PI
     D Table                         50A   VALUE

      /FREE
       data=  '  ' + s1 + %trim(table) + s2;
       addentry();
       id = 0;
       RETURN;
      /END-FREE
     P xmlStrTable     E

      //--------------------------------------
      // Procedure name: addentry
      // Purpose: add a new line in IFS file
      //--------------------------------------
     P addentry        B
     D addEntry        PI

      /FREE

         data = %trimr(data) + EOR;
         txtwrite(%addr(data):%len(%trimr(data)));

      /END-FREE
     P addentry        E

      //--------------------------------------
      // Procedure name: xmlEndTable
      // Purpose:
      // Parameter:      Table =>
      //--------------------------------------
     P xmlEndTable     B                   EXPORT
     D xmlEndTable     PI
     D Table                         50A   VALUE


      /FREE
       data=  '  ' + s1  + slash + %trim(table) + s2;
       addentry();

       RETURN;
      /END-FREE
     P xmlEndTable     E

      //--------------------------------------
      // Procedure name: XmlStrRec
      // Purpose:
      // Parameter:      record =>
      //--------------------------------------
     P XmlStrRec       B                   EXPORT
     D XmlStrRec       PI
     D record                        50A   value

      /FREE
       data=  '    ' + s1 + %trim(record) + s2;
       addentry();
       RETURN;
      /END-FREE
     P XmlStrRec       E

      //--------------------------------------
      // Procedure name: XmlAddTag
      // Purpose:
      // Parameter:      tag    =>
      //--------------------------------------
     P XmlAddTag       B                   EXPORT
     D XmlAddTag       PI
     D tag                          100A   value

      /FREE
       data=  tag ;
       addentry();
       RETURN;
      /END-FREE
     P XmlAddTag       E

      //--------------------------------------
      // Procedure name: XmlEndRec
      // Purpose:
      // Parameter:      record =>
      //--------------------------------------
     P XmlEndRec       B                   EXPORT
     D XmlEndRec       PI
     D record                        50A   value

      /FREE
       data=  '    ' + s1  + slash   + %trim(record) + s2;
       addentry();
       RETURN;
      /END-FREE
     P XmlEndRec       E

      //--------------------------------------
      // Procedure name: XmlAddCol
      // Purpose:
      // Parameter:      name => col name
      // Parameter:      type => String or Double
      // Parameter:      value => col value
      //--------------------------------------
     P XmlAddCol       B                   EXPORT
     D XmlAddCol       PI
     D name                          50A   VALUE
     D value                        200A   VALUE

     D i               s              3u 0

      /FREE
         chgvar('&':'&amp;':value);
         chgvar('<':'&lt;':value);
         chgvar('>':'&gt;':value);
         for i = 1 to %elem(aa);
           chgvar(char(i):unicode(i):value);
         endfor;
         data = '     ' + s1 + %trim(name) + s2
                           + %trim(value) + s1 + slash +
                             %trim(name) + s2;
       addentry();
       RETURN;

      /END-FREE
     P XmlAddCol       E

      //--------------------------------------
      // Procedure name: xmlopen
      // Purpose:
      //--------------------------------------
     P xmlopen         B                   EXPORT
     D xmlopen         PI
     d   FileName                   512a   const

      // Your calculation code goes here
      /FREE

        data = c1;

        txtCRTfile(Filename:*off);

        addentry();

       RETURN;
      /END-FREE
     P xmlopen         E


      //--------------------------------------
      // Procedure name: xmlclose
      // Purpose:
      //--------------------------------------
     P xmlclose        B                   EXPORT
     D xmlclose        PI
     D Table                         50A   value options(*nopass)

      // Your calculation code goes here
      /FREE

          txtclofile();


       RETURN;
      /END-FREE
     P xmlclose        E
    êê*-----------------------
     p chgvar          b
     D chgvar          pi
     D  var                           1    const
     D  input                        10    const
     D  string                      200

     D  pos            s              5i 0
     D  newval         s             10    varying

     C                   eval      newval = %trim(input)
     C                   eval      pos = %scan(var:string)
     C                   dow       pos > 0 and pos <= %size(string)
     C                   eval      string = %replace(newval:string
     c                             :pos:1)
     C                   eval      pos = %scan(var:string:pos + 1)
     C                   enddo
     p                 e
    êê*-----------------------
** ctdata(aa)
§&#x00A7;
°&#x00B0;
À&#x00C0;
Á&#x00C1;
Â&#x00C2;
Ã&#x00C3;
Ä&#x00C4;
Å&#x00C5;
Æ&#x00C6;
Ç&#x00C7;
È&#x00C8;
É&#x00C9;
Ê&#x00CA;
Ë&#x00CB;
Ì&#x00CC;
Í&#x00CD;
Î&#x00CE;
Ï&#x00CF;
Ð&#x00D0;
Ñ&#x00D1;
Ò&#x00D2;
Ó&#x00D3;
Ô&#x00D4;
Õ&#x00D5;
Ö&#x00D6;
Ø&#x00D8;
Ù&#x00D9;
Ú&#x00DA;
Û&#x00DB;
Ü&#x00DC;
Ý&#x00DD;
Þ&#x00DE;
ß&#x00DF;
à&#x00E0;
á&#x00E1;
â&#x00E2;
ã&#x00E3;
ä&#x00E4;
å&#x00E5;
æ&#x00E6;
ç&#x00E7;
è&#x00E8;
é&#x00E9;
ê&#x00EA;
ë&#x00EB;
ì&#x00EC;
í&#x00ED;
î&#x00EE;
ï&#x00EF;
ð&#x00F0;
ñ&#x00F1;
ò&#x00F2;
ó&#x00F3;
ô&#x00F4;
õ&#x00F5;
ö&#x00F6;
ø&#x00F8;
ù&#x00F9;
ú&#x00FA;
û&#x00FB;
ü&#x00FC;
ý&#x00FD;
þ&#x00FE;
ÿ&#x00FF;
