**free

ctl-opt nomain ccsidcvt(*excp) ccsid(*char : *jobrun) BNDDIR('SAMPLE');

/include qinclude,TESTCASE
/include 'qprotosrc/customer.rpgleinc'

dcl-s gCusIdValid packed(5:0) inz(10001);
dcl-s gCusIdInvalid packed(5:0) inz(99999);
dcl-s gCusIdDeleted packed(5:0) inz(10002);

exec sql
  set option commit = *none;

dcl-proc setUpSuite export;
  exec sql
    DELETE FROM CUSTOMER WHERE CUID IN (10001, 10002);
  
  exec sql
    INSERT INTO CUSTOMER (
      CUID, CUSTNM, CUPHONE, CUVAT, CUMAIL, 
      CULINE1, CULINE2, CULINE3, CUZIP, CUCITY, 
      CUCOUN, CULIMCRE, CUCREDIT, CUCREA, CUMOD, 
      CUMODID, CUDEL
    ) VALUES
      (:gCusIdValid, 'Test Customer', '555-123-4567', 'VAT12345678', 'test@example.com',
       '123 Test St', 'Suite 100', 'Floor 2', '12345', 'Test City',
       'US', 5000.00, 1000.00, CURRENT DATE, CURRENT TIMESTAMP,
       'TEST', ''),
      (:gCusIdDeleted, 'Deleted Customer', '555-987-6543', 'VAT87654321', 'deleted@example.com',
       '456 Delete Ave', 'Suite 200', 'Floor 3', '54321', 'Delete City',
       'CA', 3000.00, 500.00, CURRENT DATE, CURRENT TIMESTAMP,
       'TEST', 'X');
  
  if (sqlcode <> 0);
    fail('Failed to insert test data with SQL code: ' + %char(sqlcode));
  endif;
end-proc;

dcl-proc tearDownSuite export;
  exec sql
    DELETE FROM CUSTOMER WHERE CUID IN (10001, 10002);
end-proc;

dcl-proc test_ExistCus export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  nEqual(*on : ExistCus(gCusIdValid) : 'Valid customer ID should exist');
  nEqual(*off : ExistCus(gCusIdInvalid) : 'Invalid customer ID should not exist');
  nEqual(*off : ExistCus(gCusIdDeleted) : 'Deleted customer ID should not exist');
end-proc;

dcl-proc test_IsCusDeleted export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  nEqual(*off : IsCusDeleted(gCusIdValid) : 'Valid customer should not be deleted');
  nEqual(*off : IsCusDeleted(gCusIdInvalid) : 'Invalid customer should not be marked as deleted');
  nEqual(*on : IsCusDeleted(gCusIdDeleted) : 'Deleted customer should be marked as deleted');
end-proc;

dcl-proc test_GetCusName export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusName(gCusIdValid) = 'Test Customer' : 'Should retrieve name for valid customer');
  assert(GetCusName(gCusIdInvalid) = '' : 'Should not retrieve name for invalid customer');
  assert(GetCusName(gCusIdDeleted) = 'Deleted Customer' : 'Should retrieve name for deleted customer');
end-proc;

dcl-proc test_GetCusPhone export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusPhone(gCusIdValid) = '555-123-4567' : 'Should retrieve phone for valid customer');
  assert(GetCusPhone(gCusIdInvalid) = '' : 'Should not retrieve phone for invalid customer');
  assert(GetCusPhone(gCusIdDeleted) = '555-987-6543' : 'Should retrieve phone for deleted customer');
end-proc;

dcl-proc test_GetCusVat export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusVat(gCusIdValid) = 'VAT12345678' : 'Should retrieve VAT for valid customer');
  assert(GetCusVat(gCusIdInvalid) = '' : 'Should not retrieve VAT for invalid customer');
  assert(GetCusVat(gCusIdDeleted) = 'VAT87654321' : 'Should retrieve VAT for deleted customer');
end-proc;

dcl-proc test_GetCusMail export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusMail(gCusIdValid) = 'test@example.com' : 'Should retrieve email for valid customer');
  assert(GetCusMail(gCusIdInvalid) = '' : 'Should not retrieve email for invalid customer');
  assert(GetCusMail(gCusIdDeleted) = 'deleted@example.com' : 'Should retrieve email for deleted customer');
end-proc;

dcl-proc test_GetCusAdrline1 export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusAdrline1(gCusIdValid) = '123 Test St' : 'Should retrieve address line 1 for valid customer');
  assert(GetCusAdrline1(gCusIdInvalid) = '' : 'Should not retrieve address line 1 for invalid customer');
  assert(GetCusAdrline1(gCusIdDeleted) = '456 Delete Ave' : 'Should retrieve address line 1 for deleted customer');
end-proc;

dcl-proc test_GetCusAdrline2 export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusAdrline2(gCusIdValid) = 'Suite 100' : 'Should retrieve address line 2 for valid customer');
  assert(GetCusAdrline2(gCusIdInvalid) = '' : 'Should not retrieve address line 2 for invalid customer');
  assert(GetCusAdrline2(gCusIdDeleted) = 'Suite 200' : 'Should retrieve address line 2 for deleted customer');
end-proc;

dcl-proc test_GetCusAdrline3 export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusAdrline3(gCusIdValid) = 'Floor 2' : 'Should retrieve address line 3 for valid customer');
  assert(GetCusAdrline3(gCusIdInvalid) = '' : 'Should not retrieve address line 3 for invalid customer');
  assert(GetCusAdrline3(gCusIdDeleted) = 'Floor 3' : 'Should retrieve address line 3 for deleted customer');
end-proc;

dcl-proc test_GetCusZip export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusZip(gCusIdValid) = '12345' : 'Should retrieve zip code for valid customer');
  assert(GetCusZip(gCusIdInvalid) = '' : 'Should not retrieve zip code for invalid customer');
  assert(GetCusZip(gCusIdDeleted) = '54321' : 'Should retrieve zip code for deleted customer');
end-proc;

dcl-proc test_GetCusCity export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusCity(gCusIdValid) = 'Test City' : 'Should retrieve city for valid customer');
  assert(GetCusCity(gCusIdInvalid) = '' : 'Should not retrieve city for invalid customer');
  assert(GetCusCity(gCusIdDeleted) = 'Delete City' : 'Should retrieve city for deleted customer');
end-proc;

dcl-proc test_GetCusCountry export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusCountry(gCusIdValid) = 'US' : 'Should retrieve country for valid customer');
  assert(GetCusCountry(gCusIdInvalid) = '' : 'Should not retrieve country for invalid customer');
  assert(GetCusCountry(gCusIdDeleted) = 'CA' : 'Should retrieve country for deleted customer');
end-proc;

dcl-proc test_GetCusLimCredit export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusLimCredit(gCusIdValid) = 5000.00 : 'Should retrieve credit limit for valid customer');
  assert(GetCusLimCredit(gCusIdInvalid) = 0.00 : 'Should not retrieve credit limit for invalid customer');
  assert(GetCusLimCredit(gCusIdDeleted) = 3000.00 : 'Should retrieve credit limit for deleted customer');
end-proc;

dcl-proc test_GetCusCredit export;
  dcl-pi *n extproc(*dclcase) end-pi;
  
  assert(GetCusCredit(gCusIdValid) = 1000.00 : 'Should retrieve credit for valid customer');
  assert(GetCusCredit(gCusIdInvalid) = 0.00 : 'Should not retrieve credit for invalid customer');
  assert(GetCusCredit(gCusIdDeleted) = 500.00 : 'Should retrieve credit for deleted customer');
end-proc;