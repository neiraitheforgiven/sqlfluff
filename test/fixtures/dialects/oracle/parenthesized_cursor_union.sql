
DECLARE
  CURSOR c_items IS (SELECT 1 value FROM dual UNION ALL SELECT 2 value FROM dual);
BEGIN
  FOR v_item IN ((SELECT 1 value FROM dual) ORDER BY value) LOOP NULL; END LOOP;
END;
/
