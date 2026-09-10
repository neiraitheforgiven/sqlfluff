CREATE TABLE t_lob_storage (
    id NUMBER,
    payload CLOB
)
TABLESPACE data_ts
LOB (payload)
STORE AS (
    TABLESPACE lob_ts
    DISABLE STORAGE IN ROW
);

CREATE TABLE t_lob_storage_default (
    id NUMBER,
    payload BLOB
)
LOB (payload)
STORE AS (
    TABLESPACE lob_ts
);