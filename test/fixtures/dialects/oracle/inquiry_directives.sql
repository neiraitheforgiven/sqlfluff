CREATE OR REPLACE PACKAGE BODY pkg_test IS
  PROCEDURE LogLocation IS
    t_Line NUMBER := $$PLSQL_LINE;
  BEGIN
    pkg_debug.putline('Unit: ' || $$plsql_unit);
    pkg_debug.putline('Line: ' || $$plsql_line);
    pkg_debug.putline($$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT);
    pkg_debug.putline($$PLSQL_UNIT_TYPE);
    t_Line := $$PLSQL_LINE + 1;
  END LogLocation;
END pkg_test;
/

BEGIN
  t_Enabled := $$custom_flag;
  t_Value := NVL($$custom_value, 0);
  t_Result := $$first_flag||$$second_flag;
  t_Identifier := $$flag_with_$#;
  pkg_debug.putline('$$PLSQL_UNIT');
END;
/
