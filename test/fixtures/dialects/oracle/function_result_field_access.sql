CREATE OR REPLACE PACKAGE BODY pkg_result_access AS
  FUNCTION ReadFee(a_ClientObjectId NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN GetFees(a_ClientObjectId, 'GR').Fee;
  END ReadFee;

  FUNCTION ReadQuantity(a_ClientObjectId NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN GetFees(a_ClientObjectId, 'PCL').Quantity;
  END ReadQuantity;

  PROCEDURE UseFees IS
    t_Amount NUMBER;
  BEGIN
    t_Amount := api.pkg_Fees.GetFees(1).Fee;
    t_Amount := GetResult().Details.Fee;
    t_Amount := GetResult()."Fee";
    t_Amount := NVL(GetFees(1, 'GR').Fee, 0);
    t_Amount := GetFees(1, 'GR').Fee + GetFees(2, 'PCL').Fee;
    IF GetFees(1, 'GR').Fee > 0 THEN
      ProcessFee(GetFees(1, 'GR').Fee);
    END IF;
  END UseFees;
END pkg_result_access;
/
