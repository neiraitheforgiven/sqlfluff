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

CREATE TABLE spatial_features (
    shape MDSYS.SDO_GEOMETRY,
    payload BLOB,
    metadata CLOB
)
TABLESPACE data_ts
LOGGING NOCOMPRESS
LOB (payload) STORE AS SECUREFILE (TABLESPACE lob_ts)
LOB (metadata) STORE AS BASICFILE (TABLESPACE lob_ts);

CREATE INDEX spatial_features_ix
ON spatial_features (shape)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;