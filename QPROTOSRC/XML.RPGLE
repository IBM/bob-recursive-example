      *%CSTD===========================================================*
      ** Application. : NEW        New Sample                          *
      ** Component. . : XML                           Type: RPGLE      *
      **===============================================================*
      ** Sub-system . :                                                *
      ** Function . . :                                                *
      ** Sub-function :                                                *
      **%S=============================================================*
      ** Description of functions:                                     *
      **                                                               *
      **                                                               *
      **                                                               *
      **%E=============================================================*
      ** AUTHOR:    VTAQUIN    01/12/2016 14:34  01.01.00              *
      ** MODIFS: ** VTAQUIN    01/12/2016   :    01.01.00    00/       *
      *%ECSTD==========================================================*
     D*--------------------------------------
     D* Prototype for procedure: xmlopen
     D*--------------------------------------
     D xmlopen         PR
     d   FileName                   512a   const
     D*--------------------------------------
     D* Prototype for procedure: xmlclose
     D*--------------------------------------
     D xmlclose        PR
     D Table                         50A   value options(*nopass)
     D*--------------------------------------
     D* Prototype for procedure: xmlStrTable
     D*--------------------------------------
     D xmlStrTable     PR
     D Table                         50A   VALUE
     D*--------------------------------------
     D* Prototype for procedure: xmlEndTable
     D*--------------------------------------
     D xmlEndTable     PR
     D Table                         50A   VALUE
     D*--------------------------------------
     D* Prototype for procedure: XmlStrRec
     D*--------------------------------------
     D XmlStrRec       PR
     D record                        50A   value
     D*--------------------------------------
     D* Prototype for procedure: XmlXmlAddTag
     D*--------------------------------------
     D XmlAddTag       PR
     D tag                          100A   value
     D*--------------------------------------
     D* Prototype for procedure: XmlEndRec
     D*--------------------------------------
     D XmlEndRec       PR
     D record                        50A   value
     D*--------------------------------------
     D* Prototype for procedure: XmlAddCol
     D*--------------------------------------
     D XmlAddCol       PR
     D name                          50A   VALUE
     D value                        200A   VALUE