
SELECT UNIQUE value FROM example_table;
SELECT CONNECT_BY_ROOT t.value root_value FROM example_table t
START WITH t.parent_id IS NULL CONNECT BY PRIOR t.id = t.parent_id;
