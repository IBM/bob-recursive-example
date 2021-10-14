**free
CTL-OPT NOMAIN;

dcl-proc txtCloFile Export;
end-proc;
dcl-proc txtCrtFile Export;
    DCL-PI *n;
       Filename char(1024)    const;
       new ind const;
     END-PI;
end-proc;
dcl-proc txtWrite Export;
    DCL-PI *n;
      pdata   pointer const;
      len     uns(10:0) const;
    END-PI;
end-proc;