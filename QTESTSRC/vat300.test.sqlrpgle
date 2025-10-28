**free

ctl-opt nomain ccsidcvt(*excp) ccsid(*char : *jobrun) BNDDIR('SAMPLE');

/include qinclude,TESTCASE
/include 'qprotosrc/vat.rpgleinc'

dcl-s gVatCodeValid char(1) inz('1');
dcl-s gVatCodeInvalid char(1) inz('2');
dcl-s gVatCodeDeleted char(1) inz('3');

exec sql
  set option commit = *none;

dcl-proc setUpSuite export;
  exec sql
    DELETE FROM VATDEF WHERE VATCODE IN ('1', '2', '3');
  
  exec sql
    INSERT INTO VATDEF (
      VATCODE, VATRATE, VATDESC, VATCREA, VATMOD, VATMODID, VATDEL
    ) VALUES
      (:gVatCodeValid, 20.00, 'Valid Rate', CURRENT DATE, CURRENT TIMESTAMP, 'TEST', ''),
      (:gVatCodeDeleted, 10.00, 'Deleted Rate', CURRENT DATE, CURRENT TIMESTAMP, 'TEST', 'X');
  
  if (sqlcode <> 0);
    fail('Failed to insert test data with SQL code: ' + %char(sqlcode));
  endif;
end-proc;

dcl-proc tearDownSuite export;
  exec sql
    DELETE FROM VATDEF WHERE VATCODE IN ('1', '2', '3');
end-proc;

dcl-proc test_GetVATRate export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetVATRate(gVatCodeValid) = 20.00 : 'Should retrieve rate for valid VAT code');
  assert(GetVATRate(gVatCodeInvalid) = 0.00 : 'Should not retrieve rate for invalid VAT code');
  assert(GetVATRate(gVatCodeDeleted) = 10.00 : 'Should still retrieve rate for deleted VAT code');
end-proc;

dcl-proc test_GetVATDesc export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetVATDesc(gVatCodeValid) = 'Valid Rate' : 'Should retrieve description for valid VAT code');
  assert(GetVATDesc(gVatCodeInvalid) = '' : 'Should not retrieve description for invalid VAT code');
  assert(GetVATDesc(gVatCodeDeleted) = 'Deleted Rate' : 'Should still retrieve description for deleted VAT code');
end-proc;

dcl-proc test_ClcVAT export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  dcl-s netValue packed(9:2) inz(200.00);
  
  assert(ClcVAT(gVatCodeValid : netValue) = 40.00 : 'Should calculate VAT correctly for valid VAT code');
  assert(ClcVAT(gVatCodeInvalid : netValue) = 0.00 : 'Should not have VAT calculated for invalid code');
  assert(ClcVAT(gVatCodeDeleted : netValue) = 20.00 : 'Should still calculate VAT correctly for deleted VAT code');
end-proc;

dcl-proc test_ExistVATRate export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  nEqual(*on : ExistVATRate(gVatCodeValid) : 'Valid VAT code should exist');
  nEqual(*off : ExistVATRate(gVatCodeInvalid) : 'Invalid VAT code should not exist');
  nEqual(*off : ExistVATRate(gVatCodeDeleted) : 'Deleted VAT code should not exist');
end-proc;