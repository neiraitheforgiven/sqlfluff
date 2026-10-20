(SELECT id FROM records) ORDER BY id;

((SELECT id FROM records)) ORDER BY id DESC NULLS LAST FETCH FIRST 5 ROWS ONLY;

(SELECT id FROM records UNION ALL SELECT id FROM archived_records) ORDER BY id;

SELECT id FROM records
WHERE id > (SELECT MIN(id) FROM archived_records)
ORDER BY id;

DECLARE
  CURSOR c_records IS (
    SELECT id, expiry_date
    FROM records
    WHERE expiry_date <= TRUNC(SYSDATE)
  ) ORDER BY expiry_date;
BEGIN
  FOR r IN c_records LOOP
    NULL;
  END LOOP;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_test IS
  PROCEDURE ReadRecords IS
    CURSOR c_records IS (
      WITH recent AS (SELECT id FROM records)
      SELECT id FROM recent
    ) ORDER BY id;
  BEGIN
    FOR r IN ((SELECT id FROM records) ORDER BY id) LOOP
      NULL;
    END LOOP;
  END ReadRecords;
END pkg_test;
/

BEGIN
  OPEN c_records FOR (SELECT id FROM records) ORDER BY id;
END;
/
