**FREE
// ----------------------------------------------------------------------
// Example conversion of source to RPG Free form
//     done by Arcad Transformer RPG
//     with a temporary free trial license    ( 2 / 10 )
//     submitted by REINHARD      2021-10-21    15.27.02
// (C) Copyright 1992,2015 ARCAD Software
// note : these comments do not appear with a permanent license
// ----------------------------------------------------------------------
Ctl-Opt nomain;

Dcl-F VATDEF     Keyed usropn;

/copy QPROTOSRC/VAT

Dcl-Pr chainVATDEF;
  P_VATCODE       Char(1)         value;
End-Pr;

Dcl-S K_VATCODE       LIKE(VATCODE);

//=============================================
Dcl-Proc GetVATRate export;
  Dcl-Pi GetVATRate Packed(4:2);
    P_VATCODE       Char(1)         value;
  End-Pi;
  chainVATDEF(P_VATCODE  );
  return VATRATE;
End-Proc GetVATRate;
//=============================================
Dcl-Proc GetVATDesc export;
  Dcl-Pi GetVATDesc Char(20);
    P_VATCODE       Char(1)         value;
  End-Pi;
  chainVATDEF(P_VATCODE  );
  return VATDESC;
End-Proc GetVATDesc;

//=============================================
Dcl-Proc ClcVAT export;
  Dcl-Pi ClcVAT Packed(9:2);
    P_VATCODE       Char(1)         value;
    Net             Packed(9:2)     value;
  End-Pi;

  Dcl-S tot             Packed(11:4);
  chainVATDEF(P_VATCODE  );
  tot = (net * vatrate) / 100;
  return %dech(tot : 9 :2) ;
End-Proc ClcVAT;

//=============================================
Dcl-Proc ExistVATRate export;
  Dcl-Pi ExistVATRate Ind;
    P_VATCODE       Char(1)         value;
  End-Pi;
  chainVATDEF(P_VATCODE  );
  return %found(VATDEF) and VATDEL <> 'X';
End-Proc ExistVATRate;

Dcl-Proc chainVATDEF;
  Dcl-Pi chainVATDEF;
    P_VATCODE       Char(1)         value;
  End-Pi;
 if not %open(VATDEF);
   open VATDEF;
 endif;
  if P_VATCODE <> VATCODE;
    K_VATCODE =  P_VATCODE;
    clear *all FVAT;
    chain K_VATCODE VATDEF;
  endif;
End-Proc chainVATDEF;

Dcl-Proc closeVATDEF;
  Dcl-Pi closeVATDEF End-Pi;
 if %open(VATDEF);
   close VATDEF;
 endif;
End-Proc closeVATDEF;

 