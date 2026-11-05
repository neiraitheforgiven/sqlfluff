
BEGIN
  SELECT value INTO v_items(1) FROM example_table;
  SELECT value INTO example_pkg.v_items(v_index + 1) FROM example_table;
  SELECT a, b BULK COLLECT INTO v_row.a, v_row.b FROM example_table;
  FETCH example_cursor INTO v_items(v_index), v_row.value;
END;
/
