CREATE OR REPLACE PACKAGE BODY pkg_collections IS
  PROCEDURE UpdateValues IS
    TYPE udt_numbers IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE udt_matrix IS TABLE OF udt_numbers INDEX BY PLS_INTEGER;
    t_matrix udt_matrix;
    t_total NUMBER;
  BEGIN
    t_matrix(1)(2) := t_matrix(1)(2) + 1;
    IF t_matrix(1)(2) = 10 THEN
      t_total := ABS(t_matrix(1)(2));
    END IF;
  END UpdateValues;
END pkg_collections;
/
