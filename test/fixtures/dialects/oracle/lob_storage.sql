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

CREATE TABLE t_lob_storage_extents (
    id NUMBER,
    payload BLOB
)
TABLESPACE data_ts
STORAGE (INITIAL 256K NEXT 256K)
LOB (payload)
STORE AS (
    TABLESPACE lob_ts
    STORAGE (
        INITIAL 256K NEXT 256K
        MINEXTENTS 1 MAXEXTENTS UNLIMITED
        PCTINCREASE 0
    )
);