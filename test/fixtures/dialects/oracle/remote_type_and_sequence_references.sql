
SELECT example_seq.NEXTVAL@remote_db, example_schema.example_seq.CURRVAL@remote_db FROM dual;
DECLARE
  v_id example_table.id@remote_db%TYPE;
  v_row example_table@remote_db%ROWTYPE;
BEGIN NULL; END;
/
