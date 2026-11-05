CREATE OR REPLACE PACKAGE BODY pkg_nested_access AS
  PROCEDURE CopyContactInfo IS
    TYPE udt_IdList IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE udt_Group IS RECORD (
      ClientId NUMBER,
      ContactInfoList udt_IdList
    );
    TYPE udt_Groups IS TABLE OF udt_Group INDEX BY PLS_INTEGER;
    t_Groups udt_Groups;
    t_IdList udt_IdList;
    t_Index PLS_INTEGER := 1;
  BEGIN
    t_Index := t_Groups(1).ContactInfoList.COUNT + 1;
    t_Index := t_Groups(1).ContactInfoList.COUNT - 1;
    t_Index := (t_Groups(1).ContactInfoList.COUNT + 1) * 2;
    t_Index := NVL(t_Groups(1).ContactInfoList.COUNT + 1, 0);
    t_Index := pkg_Cache.t_Groups(1).ContactInfoList.COUNT + 1;
    t_Index := GetGroups(1).Details.COUNT + 1;
    t_Index := api.GetGroups(1).Details.COUNT + 1;
    t_Index := t_Groups(1)."ContactInfoList".COUNT + 1;

    t_Groups(1).ContactInfoList(
      t_Groups(1).ContactInfoList.COUNT + 1
    ) := t_IdList(1);
    t_Groups(1).ContactInfoList(t_Index) := t_Groups(2).ContactInfoList(t_Index);
    t_Groups(1).ClientId := t_IdList(1);

    IF t_Groups(1).ContactInfoList.COUNT + 1 > 0
      AND t_Groups(1).ClientId = 1 THEN
      NULL;
    END IF;

    FOR x IN 1..t_Groups(1).ContactInfoList.COUNT + 1 LOOP
      t_Index := t_Groups(x).ContactInfoList.FIRST;
      t_Index := t_Groups(x).ContactInfoList.LAST;
    END LOOP;
  END CopyContactInfo;
END pkg_nested_access;
/
