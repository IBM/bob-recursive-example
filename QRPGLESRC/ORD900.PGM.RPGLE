     forder1    if   e           k disk
     d next            s              6s 0 DTAARA('LASTORDNO')
     c     *hival        setgt     order1
     c                   readp     order1
     c     *lock         in        next
     c                   z-add     orid          next
     c                   out       next
     c                   seton                                        lr
