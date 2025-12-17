CREATE OR REPLACE TABLE Custinfo1(
  Customer_Id     FOR COLUMN CUSTID      CHAR(6)      NOT NULL,
  Customer_Name   FOR COLUMN CUSTNAME    VARCHAR(40)  DEFAULT ' ',
  Customer_Email  FOR COLUMN CUSTEMAIL   VARCHAR(50)  DEFAULT ' ',
  Customer_Phone  FOR COLUMN CUSTPHN     CHAR(10)     DEFAULT ' ',
  Join_Date       FOR COLUMN JOINDATE    DATE,
  PRIMARY KEY (CUSTID)
);

LABEL ON TABLE Custinfo1 IS 'Custinfo1 Master Table';

LABEL ON COLUMN Custinfo1(
  CUSTID     IS 'Customer ID',
  CUSTNAME   IS 'Customer Name',
  CUSTEMAIL  IS 'Email',
  CUSTPHN    IS 'Phone Number',
  JOINDATE   IS 'Join Date'
);