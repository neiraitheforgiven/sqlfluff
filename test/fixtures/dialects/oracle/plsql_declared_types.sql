
DECLARE
  SUBTYPE short_text IS VARCHAR2(20 CHAR);
  TYPE text_list IS TABLE OF VARCHAR2(100 BYTE) INDEX BY PLS_INTEGER;
  TYPE custom_list IS TABLE OF example_pkg.item_type;
  TYPE row_record IS RECORD (label VARCHAR2(50 CHAR), value NUMBER);
  v_items example_pkg.item_list;
  v_row example_pkg.item_type;
BEGIN NULL; END;
/
CREATE FUNCTION get_item RETURN example_pkg.item_type IS
  v_item example_pkg.item_type;
BEGIN RETURN v_item; END;
/
