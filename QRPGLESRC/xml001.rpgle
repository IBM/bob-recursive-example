      *%CSTD===========================================================*
      ** Application. : ARC_DEMO   PRD:Tools used by Demo appli.       *        
      ** Composant. . : XML001                        Type: RPGLE      *        
      **===============================================================*        
      ** Sous-syst}me :                                                *       
      ** Fonction . . :                                                *        
      ** Sous-fonction:                                                *        
      **%S=============================================================*        
      ** Description des fonctionnalit{s:                              *        
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
     D Table                         50A         VALUE          
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
     P xmlEndTable     
     B                   EXPORT       
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
      *-----------------------       
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
      *-----------------------  
** ctdata(aa)  
!&�x00A7;
&�x00B0;
&�x00C0;
&�x00C1;
&�x00C2;
&�x00C3;
&�x00C4;
&�x00C5;  �&�x00C6;  �&�x00C7;  �&�x00C8;  �&�x00C9;  
&�x00CA;  �&�x00CB;  �&�x00CC;  �&�x00CD;  �&�x00CE;  �&�x00CF;  
&�x00D0;  �&�x00D1;  �&�x00D2;  �&�x00D3;  �&�x00D4;  �&�x00D5;  
&�x00D6;  �&�x00D8;  �&�x00D9;  �&�x00DA;  �&�x00DB;  �&�x00DC;  
&�x00DD;  �&�x00DE;  �&�x00DF;  @&�x00E0;  �&�x00E1;  �&�x00E2;  
&�x00E3;  �&�x00E4;  �&�x00E5;  �&�x00E6;  \&�x00E7;  }&�x00E8;  
&�x00E9;  �&�x00EA;  �&�x00EB;  �&�x00EC;  �&�x00ED;  �&�x00EE;  
&�x00EF;  �&�x00F0;  �&�x00F1;  �&�x00F2;  �&�x00F3;  �&�x00F4; 
&�x00F5;  �&�x00F6;  �&�x00F8;  �&�x00F9;  �&�x00FA;  �&�x00FB;  
&�x00FC;  �&�x00FD;  �&�x00FE;  �&�x00FF;  