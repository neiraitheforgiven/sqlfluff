CREATE MATERIALIZED VIEW app.search_mv
TABLESPACE data_ts
REFRESH FORCE ON DEMAND START WITH SYSDATE + 0 NEXT TRUNC(SYSDATE) + 1 + 5 / 24
AS
WITH source_rows AS (SELECT 1 AS object_id FROM dual)
SELECT object_id FROM source_rows;

CREATE MATERIALIZED VIEW app.on_commit_mv REFRESH FAST ON COMMIT AS
SELECT object_id FROM app.source_table;

CREATE MATERIALIZED VIEW app.unscheduled_mv NEVER REFRESH AS
SELECT object_id FROM app.source_table;
