CREATE UNIQUE INDEX users_ix_2
ON users_t (
  LOWER("AUTHENTICATIONNAME")
) TABLESPACE posseindexes_ts;

CREATE INDEX changedobjects_ix_1
ON changedobjects_t (
  syncchangelogid,
  objectid,
  SYS_EXTRACT_UTC("CHANGETIME")
) TABLESPACE possedata_ts;