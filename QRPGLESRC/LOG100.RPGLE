
     h dftactgrp(*no)
     fparameter if   e           k disk
     f                                     infds(info)

      /copy qprotosrc,apicall

     d info            ds
     D  lib                   93    102

     d                 ds                  based(p1)
     d  pos                          10i 0
     d  data                          3

     d usrspc          s             20
      /free
        usrspc = 'SAMLOG    ' + Lib;
        crtusrspc(usrspc:'LOG':5000:X'00':'*ALL':'Sample Application Log'
                  :'*YES':errcod);
        rtvusrspcptr(usrspc:p1);
        pos = 7;
        data = '***';
        *inlr = *on;
      /end-free
