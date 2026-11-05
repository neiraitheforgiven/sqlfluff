SELECT rel.ToObjectId
FROM api.Relationships rel
WHERE rel.EndPointId IN t_EndPointId;

SELECT rel.ToObjectId
FROM api.Relationships rel
WHERE rel.EndPointId NOT IN t_EndPointId
  AND rel.FromObjectId = a_ObjectId;

SELECT rel.ToObjectId
FROM api.Relationships rel
WHERE rel.EndPointId IN pkg_Config.t_EndPointId
  OR rel.EndPointId IN settings."EndPointId"
  OR rel.EndPointId IN pkg_Config . t_EndPointId;

SELECT rel.ToObjectId
FROM api.Relationships rel
WHERE rel.EndPointId IN :EndPointId
  AND rel.FromObjectId NOT IN :ObjectId;

SELECT rel.ToObjectId
FROM api.Relationships rel
WHERE rel.EndPointId IN "EndPointId";

SELECT rel.ToObjectId
FROM api.Relationships rel
JOIN api.Objects obj
  ON obj.ObjectId = rel.ToObjectId
  AND rel.EndPointId IN t_EndPointId
WHERE obj.ObjectId NOT IN a_ExcludedObjectId;

SELECT rel.EndPointId, COUNT(*)
FROM api.Relationships rel
GROUP BY rel.EndPointId
HAVING COUNT(*) IN t_Count;

SELECT rel.ToObjectId
FROM api.Relationships rel
WHERE rel.EndPointId IN t_EndPointId
  AND rel.FromObjectId IN (a_ObjectId, a_OtherObjectId)
  AND rel.ToObjectId NOT IN (SELECT ObjectId FROM api.ExcludedObjects)
  AND rel.RelationshipId IN api.GetRelationshipIds(a_ObjectId);

CREATE OR REPLACE PACKAGE BODY pkg_in_variable AS
  PROCEDURE AttachmentChange(a_ObjectId NUMBER, a_EndPointId NUMBER) IS
    TYPE udt_Ids IS TABLE OF NUMBER;
    t_Contacts udt_Ids;
    t_EndPointId NUMBER := a_EndPointId;
  BEGIN
    SELECT rel.ToObjectId
    BULK COLLECT INTO t_Contacts
    FROM api.Relationships rel
    WHERE rel.FromObjectId = a_ObjectId
      AND rel.EndPointId IN t_EndPointId;

    UPDATE api.Relationships
    SET ToObjectId = a_ObjectId
    WHERE EndPointId IN t_EndPointId;

    DELETE FROM api.Relationships
    WHERE EndPointId NOT IN t_EndPointId;

    IF a_EndPointId NOT IN t_EndPointId THEN
      NULL;
    END IF;

    FOR c IN (
      SELECT rel.ToObjectId
      FROM api.Relationships rel
      WHERE rel.EndPointId IN t_EndPointId
        AND rel.FromObjectId = a_ObjectId
    ) LOOP
      NULL;
    END LOOP;
  END AttachmentChange;
END pkg_in_variable;
/
