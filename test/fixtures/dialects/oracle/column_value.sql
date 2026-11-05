SELECT column_value AS mnth
FROM sys.dbms_debug_vc2coll('01', '05', '09');

SELECT t.column_value
FROM TABLE(t_Ids) t;

SELECT "Ids".COLUMN_VALUE AS ObjectId
FROM TABLE(t_Ids) "Ids";

SELECT schema_name.collection_name.column_value
FROM schema_name.collection_name;

SELECT rels.column_value RelationshipId, c.ObjectId
FROM TABLE(t_Ids) rels
JOIN query.r_ClientBusinessContact r
    ON r.RelationshipId = rels.column_value
JOIN query.o_BusinessContact c
    ON c.ObjectId = r.BusinessContactObjectId
WHERE rels.column_value = NVL(c.ContactTypeId, t_ContactTypeId);

SELECT ids.column_value AS FromObjectId
FROM TABLE(t_Ids) ids
WHERE ids.column_value IN (
    SELECT other_ids.column_value
    FROM TABLE(t_OtherIds) other_ids
);

DECLARE
    t_Ids udt_IdList;
    CURSOR c_BusinessContacts IS
        SELECT r.RelationshipId
        FROM TABLE(t_Ids) rels
        JOIN query.r_ClientBusinessContact r
            ON r.RelationshipId = rels.column_value;
BEGIN
    NULL;
END;
/
