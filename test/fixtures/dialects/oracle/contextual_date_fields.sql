
DECLARE
  TYPE example_record IS RECORD (Date DATE, value NUMBER);
  v_record example_record;
BEGIN v_record.Date := SYSDATE; v_record.Date := GetDates(1).Date; END;
/
SELECT example_alias.Date FROM example_table example_alias;
