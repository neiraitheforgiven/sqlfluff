BEGIN
    FOR rec IN (
        SELECT pkg_contacts.contact_type(c.id), COUNT(*)
        FROM contacts c
        HAVING COUNT(*) > 1
        GROUP BY pkg_contacts.contact_type(c.id)
    ) LOOP
        NULL;
    END LOOP;
END;
/
