
CREATE FUNCTION example_rows RETURN example_type PIPELINED IS
BEGIN
  PIPE ROW (example_record(1));
  RETURN;
END;
/
