CREATE OR REPLACE PACKAGE BODY pkg_dates AS
  PROCEDURE CheckDates IS
    TYPE error_rt IS RECORD (
      Date BOOLEAN := FALSE,
      Flow BOOLEAN := FALSE
    );
    t_Error error_rt;
  BEGIN
    t_Error.Date := TRUE;
    IF t_Error.Date THEN
      NULL;
    END IF;
    IF NOT t_Error.Date AND t_Error.Flow THEN
      NULL;
    END IF;
    IF t_Error.Date = TRUE THEN
      NULL;
    END IF;
    IF t_Error.Date IS NULL THEN
      NULL;
    END IF;
    IF t_Outer.Errors.Date THEN
      NULL;
    END IF;
    IF t_Errors(1).Date THEN
      NULL;
    END IF;
    IF GetErrors(1).Date THEN
      NULL;
    END IF;
    IF GetErrors(1).Nested.Date THEN
      NULL;
    END IF;
    CheckValue(t_Error.Date);
  END CheckDates;

  PROCEDURE CheckAgain IS
  BEGIN
    NULL;
  END CheckAgain;
END pkg_dates;
/

SELECT DATE '2026-01-01' FROM dual;
