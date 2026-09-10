CREATE TABLE t_fk_initially_deferred (
    id NUMBER,
    parent_id NUMBER,
    CONSTRAINT fk_t_fk_initially_deferred FOREIGN KEY (parent_id)
        REFERENCES parent_t (id)
        INITIALLY DEFERRED
);

    CREATE TABLE t_uq_initially_deferred (
        id NUMBER,
        CONSTRAINT uq_t_uq_initially_deferred UNIQUE (id)
            INITIALLY DEFERRED
            USING INDEX TABLESPACE idx_ts
    );