CREATE OR REPLACE PACKAGE BODY pkg_test AS
  PROCEDURE Assess IS
    TYPE udt_NumberList IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t_Ids udt_NumberList;
    t_Value NUMBER;
  BEGIN
    FOR i IN (
      SELECT ClientId FROM first_accounts
      UNION
      SELECT ClientId FROM second_accounts
    )
    LOOP
      FOR j IN (
        SELECT ObjectId, ROWNUM
        FROM objects
        WHERE ClientId = i.ClientId
      )
      LOOP
        t_Ids(j.rownum) := j.ObjectId;
        t_Value := j.ROWNUM + 1;
        Process(j.rownum);
      END LOOP;
    END LOOP;
  END Assess;
END pkg_test;
/

BEGIN
  t_Value := "Item".ROWNUM;
  t_Value := outer_record.inner_record.rownum;
END;
/
