
DECLARE
  v_value NUMBER := CASE WHEN 1 = 1 THEN 2 ELSE 3 END;
BEGIN
  CASE v_value
    WHEN 1 THEN v_value := 2; NULL;
    WHEN 2 THEN NULL;
    ELSE v_value := 3;
  END CASE;
  CASE
    WHEN v_value > 0 THEN NULL;
    ELSE NULL;
  END CASE;
END;
/
