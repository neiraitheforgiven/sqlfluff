CREATE TABLE keywordindexedcolumndefs_t (
  columndefid NUMBER(9) NOT NULL,
  active CHAR(1) NOT NULL,
  CONSTRAINT keywordindexedcolumndefs_pk PRIMARY KEY (columndefid)
) ORGANIZATION INDEX TABLESPACE possedata_ts;

CREATE TABLE authenticationrequests_t (
  requestid NUMBER NOT NULL,
  formvalues CLOB
) ORGANIZATION INDEX
  TABLESPACE possedata_ts
  LOB (formvalues) STORE AS (
    TABLESPACE posselobs_ts
    DISABLE STORAGE IN ROW
  );