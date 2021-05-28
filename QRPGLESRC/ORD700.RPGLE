     H dftactgrp(*no)

     Farticle1  UF   E           K DISK

      /copy qprotosrc,log

     d UpdArt          pr
     d   qty                          5  0 value
     d   id                                like(new.ODARID)

     D PARM1           DS
      * Physical file name
     D  FNAME                        10
      * Physical file library
     D  LNAME                        10
      * Member name
     D  MNAME                        10
      * Trigger event 1=Ins, 2=Del, 3=Upd
     D  TEVEN                         1
      * Trigger time  1=After, 2=Before
     D  TTIME                         1
      * Commit lock level
     D  CMTLCK                        1
      * Reserved
     D                                3
      * CCSID
     D  CCSID                        10i 0
      * Reserved
     D                                8
      * Offset to the original record
     D  OLDOFF                       10i 0
      * length of the original record
     D  OLDLEN                       10i 0
      * Offset to the original record null byte map
     D  ONOFF                        10i 0
      * length of the null byte map
     D  ONLEN                        10i 0
      * Offset to the new record
     D  NEWOFF                       10i 0
      * length of the new record
     D  NEWLEN                       10i 0
      * Offset to the new record null byte map
     D  NNOFF                        10i 0
      * length of the null byte map
     D  NNLEN                        10i 0

      * Trigger Buffer Length
     D  parm2          s             10i 0

      * Record to be inserted or new values
     D NEW           E DS                  EXTNAME(detord)
     D                                     qualified
     D                                     based(pn)

      * Record to be deleted or old values
     D OLD           E DS                  EXTNAME(detord)
     D                                     qualified
     D                                     based(po)

      * SET UP THE ENTRY PARAMETER LIST.

     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
     C                   if                      %parms = 0
     C                   seton                                        lr
     C                   return
     C                   ENDIF
     C                   select
     c                   when      teven = '1'
     c                   eval      pn = %addr(parm1) + newoff
     c                   callp     UpdArt(new.odqty:new.odarid)
     c                   when      teven = '2'
     c                   eval      po = %addr(parm1) + oldoff
     c                   callp(e)  addlogEntry('ORD700:Order Line deleted ' +
     c                             %char(Old.odorid) + ' ' + %char(Old.odline)
     c                              + ' article : ' + old.odarid
     c                              + ' quantity : ' + %char(old.odqty))
     c                   callp     UpdArt(-Old.odqty + Old.odqtyliv:old.odarid)
     c                   when      teven = '3'
     c                   eval      pn = %addr(parm1) + newoff
     c                   eval      po = %addr(parm1) + oldoff
     c                   if        new.odarid = Old.odarid
     c                   callp     UpdArt((New.odqty - Old.odqty)
     c                              - (New.odqtyLiv - Old.odqtyLiv)
     c                             :new.odarid)
     c                   else
     c                   callp     UpdArt(new.odqty- new.odqtyliv:new.odarid)
     c                   callp     UpdArt(-Old.odqty + Old.odqtyliv:old.odarid)
     c                   endif
     c                   endsl
     c                   return

     P UpdArt          b
     d UpdArt          pi
     d   qty                          5  0 value
     d   id                                like(new.ODARID)
     c                   if        qty = 0
     c                   return
     c                   ENDIF
     c     id            chain     article1
     c                   if        not %found
     c                   return
     c                   ENDIF
     c                   eval      ARCUSQTY += qty
     c                   update    farti
     P UpdArt          e
