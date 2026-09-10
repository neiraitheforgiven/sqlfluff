CREATE OR REPLACE TYPE udt_eventreportline AS OBJECT (
  Label1 VARCHAR2(4000),
  Value VARCHAR2(4000 CHAR),
  IndentLevel NUMBER(9),
  IsHeader CHAR(1)
);