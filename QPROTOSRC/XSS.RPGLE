      *%CSTD===========================================================*
      ** Application. : ARC_DEMO   PRD:Tools used by Demo appli.       *
      ** Composant. . : XSS                           Type: RPGLE      *
      **===============================================================*
      ** Sous-systÃ¨me :                                                *
      ** Fonction . . :                                                *
      ** Sous-fonction:                                                *
      **%S=============================================================*
      ** Description des fonctionnalitÃ©s:                              *
      **                                                               *
      **                                                               *
      **                                                               *
      **%E=============================================================*
      ** AUTEUR:                          00:00                        *
      ** MODIFS: 05 VTAQUIN    27/08/2019 17:45  01.00.21    00/       *
      **         04 VTAQUIN    17/03/2017 15:35  01.00.07    00/       *
      **         03 VTAQUIN    15/02/2017 15:47  01.00.04    00/       *
      **         02 VTAQUIN    12/01/2017 12:21  01.00.03    00/       *
      **         01 VTAQUIN    10/01/2017 16:15  01.00.02    00/       *
      *%ECSTD==========================================================*

     Dxssopenfile      PR
     D  File                       1024A   value

     D XssSetDocProperties...
     D                 Pr
     D  author                       20    value
     D  LastAuthor                   20    value
     D  version                       4  2 value

     Dxsscreatestyle   Pr             3u 0
     DXsssetbold       PR

     DXssSetItalic     PR

     dxssSetFontSize   pr
     d  size                          5i 0 value

     DXssSetFontName   PR
     d  Name                         50    value
     d  family                       50    value options(*nopass)

     DXssSetFormat     PR
     d  format                       20    value

     DXssSetalign      PR
     d  alignment                    10    value

     DXsssetVertAlign  PR
     d  alignment                    10    value


     DXsssetcolor      PR
     d  color                         6    value

     DXsssetForcolor   PR
     d  color                         6    value

     DXsssetBorder     PR
     d  Weight                        2  0 value
     d  Position                      1    value OPTIONS(*NOPASS)

     DXsssetwrap       PR

     DXssaddsheet      PR
     D sheet                        100A   value OPTIONS(*NOPASS)
     DxssSetColWidth   PR
     D Width                          5  2 Const
     D ColId                          5i 0 CONST OPTIONS(*NOPASS)
     Dxssaddrow        PR
     D height                         5  2 CONST OPTIONS(*NOPASS)
     DxssaddcellChar   PR
     D value                       1024A   value
     D style                          3u 0 VALUE  OPTIONS(*NOPASS)
     D idx                            5u 0 VALUE  OPTIONS(*NOPASS)
     D merge                          3u 0 VALUE  OPTIONS(*NOPASS)
     DxssaddcellNum    PR
     d value                          8F   VALUE
     D style                          3u 0 VALUE  OPTIONS(*NOPASS)
     D idx                            5u 0 VALUE  OPTIONS(*NOPASS)
     D merge                          3u 0 VALUE  OPTIONS(*NOPASS)
     DxssaddcellDat    PR
     D DateNum                        8  0 VALUE
     D format                         5    value
     D style                          3u 0 VALUE  OPTIONS(*NOPASS)
     D idx                            5u 0 VALUE  OPTIONS(*NOPASS)
     D merge                          3u 0 VALUE  OPTIONS(*NOPASS)
     DXssclosefile     PR
     D XssGetRowId     PR             6
     D XssGetColId     pr             5
     D XssGetCellId    pr            12
     D XssSetAutoFilter...
     D                 pr
     D  range1                       12    Value
     D  range2                       12    value
     D XssFreezePane   Pr
     d  Row                           5i 0 value
     d  Col                           5i 0 value
     d                                     OPTIONS(*NOPASS)

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * Set color
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D COLOR_BLACK     c                   '000000'
     D COLOR_WHITE     c                   'FFFFFF'
     D COLOR_RED       c                   'FF0000'
     D COLOR_BRIGHT_...
     D    GREEN        c                   '92D050'
     D COLOR_BLUE      c                   '0070C0'
     D COLOR_YELLOW    c                   'FFFF00'
     D COLOR_GREEN     c                   '00B050'
     D COLOR_GREY      c                   'BFBFBF'
     D COLOR_LIGHT_GREY...
     D                 c                   'D9D9D9'

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * ALIGN_XXX
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D ALIGN_CENTER...
     D                 C                   'Center'
     D ALIGN_FILL...
     D                 C                   'Fill'
     D ALIGN_LEFT...
     D                 C                   'Left'
     D ALIGN_RIGHT...
     D                 C                   'Right'
     D ALIGN_BOT       C                   'Bottom'
     D ALIGN_TOP       C                   'Top'
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * Date format to be used with excellDat
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     d F_CYMD          c                   '*CYMD'
     d F_YMD           c                   '*YMD'
     d F_DMY           c                   '*DMY'
     d F_MDY           c                   '*MDY'
     d F_ISO           c                   '*ISO'
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * Set data format
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     d FORMAT_DEC0     c                   'q,qq0'
     d FORMAT_DEC1     c                   'q,qq0.0'
     d FORMAT_DEC2     c                   'q,qq0.00'
     d FORMAT_DEC3     c                   'q,qq0.000'
     d FORMAT_PCT0     c                   '0%'
     d FORMAT_PCT1     c                   '0.0%'
     d FORMAT_PCT2     c                   '0.00%'
     d FORMAT_DATE_SHORT...
     d                 c                   'Short Date'

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * Set Border - Position
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     d BORDER_BOTTOM   c                   'B'
     d BORDER_LEFT     c                   'L'
     d BORDER_RIGHT    c                   'R'
     d BORDER_TOP      c                   'T'
 