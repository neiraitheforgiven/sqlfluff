SELECT Organization, r.Organization
FROM contact_types r;

BEGIN
    SELECT Organization
    INTO t_Answer
    FROM contact_types r;
END;
/
