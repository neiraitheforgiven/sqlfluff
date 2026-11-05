
BEGIN
  example_pkg.DELETE(1);
  example_pkg.DELETE;
  v_items.DELETE(1);
  v_value := example_pkg.VALUE(1);
END;
/
