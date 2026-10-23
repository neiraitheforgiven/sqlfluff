"""Oracle dialect specific parser rejection tests.

Verifies that duplicate attributes and mutually-exclusive pairs in Oracle
physical-attribute segments are rejected at parse time (AnySetOf semantics).

Positive/valid-SQL cases belong in the SQL/YAML parse fixtures under
test/fixtures/dialects/oracle/ per project convention.
"""

import pytest

from sqlfluff.core import Linter


def _violations(sql: str) -> list:
    """Return all parse errors, including unparsable nodes anywhere in the tree.

    Top-level parse failures surface in parsed.violations, but content that
    cannot be matched inside a Bracketed clause is silently wrapped in an
    unparsable tree node without raising a SQLParseError. We collect both so
    that rejection tests for STORAGE(...) sub-parameters work correctly.
    """
    parsed = Linter(dialect="oracle").parse_string(sql)
    violations: list = list(parsed.violations)
    if parsed.tree:
        violations += list(parsed.tree.recursive_crawl("unparsable"))
    return violations


@pytest.mark.parametrize(
    "suffix",
    [
        "ORDER BY",
        "ORDER BY id WHERE id > 0",
        "ORDER BY id FETCH FIRST 5 ROWS",
    ],
)
def test_malformed_parenthesized_query_order_by_rejected(suffix: str) -> None:
    """Outer query clauses must still be complete and in the correct order."""
    assert _violations(f"(SELECT id FROM records) {suffix};")


@pytest.mark.parametrize(
    "condition",
    [
        "UTL_SMTP.TRANSIENT_ERROR OR",
        "OR UTL_SMTP.PERMANENT_ERROR",
        "UTL_SMTP.TRANSIENT_ERROR OR OR NO_DATA_FOUND",
        "UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.",
        "UTL_SMTP.TRANSIENT_ERROR OR .PERMANENT_ERROR",
    ],
)
def test_malformed_exception_choices_rejected(condition: str) -> None:
    """Each OR alternative must contain a complete exception name."""
    assert _violations(
        f"BEGIN NULL; EXCEPTION WHEN {condition} THEN NULL; END;\n/\n"
    )


@pytest.mark.parametrize(
    "expression",
    [
        "TO_NUMBER('invalid' DEFAULT NULL ON CONVERSION ERROR)",
        "TO_NUMBER('invalid' DEFAULT 0 ON CONVERSION ERROR, '999')",
        "TO_NUMBER(source_value DEFAULT fallback_value ON CONVERSION ERROR)",
        "TO_DATE('invalid' DEFAULT '2020-01-01' ON CONVERSION ERROR, 'YYYY-MM-DD')",
        "TO_TIMESTAMP('invalid' DEFAULT NULL ON CONVERSION ERROR)",
        "TO_NUMBER(api.pkg_ColumnQuery.Value(a_ObjectId, c.SourceName) "
        "DEFAULT NULL ON CONVERSION ERROR)",
    ],
)
def test_conversion_error_defaults_parse(expression: str) -> None:
    """Oracle conversion functions accept a default within their first argument."""
    assert _violations(f"SELECT {expression} FROM dual;") == []


def test_conversion_error_defaults_parse_in_package_body() -> None:
    """A conversion default must not make an entire PL/SQL package unparsable."""
    sql = (
        "CREATE OR REPLACE PACKAGE BODY pkg_test IS\n"
        "  PROCEDURE CopyValue(a_ObjectId NUMBER) IS\n"
        "    t_Value NUMBER;\n"
        "  BEGIN\n"
        "    t_Value := TO_NUMBER(api.pkg_ColumnQuery.Value(a_ObjectId, 'Value')\n"
        "        DEFAULT NULL ON CONVERSION ERROR);\n"
        "  END CopyValue;\n"
        "END pkg_test;\n/\n"
    )
    assert _violations(sql) == []


@pytest.mark.parametrize("alias", ["AS q", "q r"])
def test_malformed_delete_alias_without_from_rejected(alias: str) -> None:
    """A FROM-less DELETE accepts a single implicit table alias."""
    assert _violations(
        f"DELETE BillingRunObject_t {alias} WHERE billingrunjobid = a_JobId;"
    )


# OraclePhysicalAttributesSegment - table-level attributes
@pytest.mark.parametrize(
    "sql",
    [
        # Duplicate scalar attributes
        pytest.param(
            "CREATE TABLE t (c NUMBER) PCTFREE 10 PCTFREE 20;",
            id="dup_pctfree",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) PCTUSED 40 PCTUSED 60;",
            id="dup_pctused",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) INITRANS 2 INITRANS 4;",
            id="dup_initrans",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) MAXTRANS 255 MAXTRANS 100;",
            id="dup_maxtrans",
        ),
        # Mutually exclusive pairs
        pytest.param(
            "CREATE TABLE t (c NUMBER) LOGGING NOLOGGING;",
            id="logging_nologging",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) MONITORING NOMONITORING;",
            id="monitoring_nomonitoring",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) ROWDEPENDENCIES NOROWDEPENDENCIES;",
            id="rowdep_norowdep",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) CACHE NOCACHE;",
            id="cache_nocache",
        ),
    ],
)
def test_table_physical_attrs_rejected(sql: str) -> None:
    """Duplicate or mutually-exclusive table physical attributes must produce a parse violation."""
    assert _violations(sql) != [], f"Expected violations but got none for:\n{sql}"


# StorageClauseSegment - STORAGE(...) sub-parameters
@pytest.mark.parametrize(
    "sql",
    [
        pytest.param(
            "CREATE TABLE t (c NUMBER) STORAGE (INITIAL 256K INITIAL 512K);",
            id="storage_dup_initial",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) STORAGE (NEXT 64K NEXT 128K);",
            id="storage_dup_next",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) STORAGE (MAXEXTENTS 100 MAXEXTENTS 200);",
            id="storage_dup_maxextents",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) STORAGE (PCTINCREASE 0 PCTINCREASE 10);",
            id="storage_dup_pctincrease",
        ),
        pytest.param(
            "CREATE TABLE t (c NUMBER) STORAGE (BUFFER_POOL DEFAULT BUFFER_POOL KEEP);",
            id="storage_dup_buffer_pool",
        ),
    ],
)
def test_storage_clause_rejected(sql: str) -> None:
    """Duplicate STORAGE sub-parameters must produce a parse violation."""
    assert _violations(sql) != [], f"Expected violations but got none for:\n{sql}"


# INMEMORY subclause AnySetOf enforcement
@pytest.mark.parametrize(
    "sql",
    [
        pytest.param(
            "CREATE TABLE t (c NUMBER) INMEMORY PRIORITY LOW PRIORITY HIGH;",
            id="inmemory_dup_priority",
        ),
    ],
)
def test_inmemory_subclauses_rejected(sql: str) -> None:
    """Duplicate INMEMORY subclauses must produce a parse violation."""
    assert _violations(sql) != [], f"Expected violations but got none for:\n{sql}"


# OracleIndexPhysicalAttributesSegment - index-level attributes
@pytest.mark.parametrize(
    "sql",
    [
        # Duplicate scalar attributes
        pytest.param(
            "CREATE INDEX i ON t (c) PCTFREE 10 PCTFREE 20;",
            id="index_dup_pctfree",
        ),
        # Mutually exclusive pairs
        pytest.param(
            "CREATE INDEX i ON t (c) LOGGING NOLOGGING;",
            id="index_logging_nologging",
        ),
        pytest.param(
            "CREATE INDEX i ON t (c) NOSORT REVERSE;",
            id="index_nosort_reverse",
        ),
        pytest.param(
            "CREATE INDEX i ON t (c) VISIBLE INVISIBLE;",
            id="index_visible_invisible",
        ),
    ],
)
def test_index_physical_attrs_rejected(sql: str) -> None:
    """Duplicate or mutually-exclusive index physical attributes must produce a parse violation."""
    assert _violations(sql) != [], f"Expected violations but got none for:\n{sql}"


def test_package_qualified_collection_types_and_indexed_into_parse() -> None:
    """Package-qualified collection types and indexed INTO targets should parse."""
    sql = """
CREATE OR REPLACE PACKAGE pkg_test AS
    PROCEDURE AddRecordSet(
        a_ObjectDefName VARCHAR2,
        a_ColumnDefNames VARCHAR2
    );
END pkg_test;
/
CREATE OR REPLACE PACKAGE BODY pkg_test AS
    PROCEDURE AddRecordSet(
        a_ObjectDefName VARCHAR2,
        a_ColumnDefNames VARCHAR2
    ) IS
        t_ColumnDefIdList api.pkg_Definition.udt_IdList;
        t_ColumnDefNamesList api.pkg_Definition.udt_StringList;
        t_ObjectDefId udt_Id;
        t_RecordSetId udt_Id;
    BEGIN
        SELECT trim(regexp_substr(a_ColumnDefNames, '[^,]+', 1, level))
        BULK COLLECT INTO t_ColumnDefNamesList
        FROM dual
        CONNECT BY level <= regexp_count(a_ColumnDefNames, ',') + 1;

        FOR i IN 1..t_ColumnDefNamesList.count LOOP
            BEGIN
                SELECT ColumnDefId
                INTO t_ColumnDefIdList(i)
                FROM api.ColumnDefs
                WHERE ObjectDefId = t_ObjectDefId
                    AND lower(Name) = lower(t_ColumnDefNamesList(i));
            EXCEPTION
            WHEN no_data_found THEN
                NULL;
            END;
        END LOOP;

        t_RecordSetId := stage.pkg_RecordSetUpdate.New(t_ObjectDefId, 'WordInterface', NULL);
        stage.pkg_RecordSetUpdate.ReplaceColumns(t_RecordSetId, t_ColumnDefIdList);
    END AddRecordSet;
END pkg_test;
/
"""

    assert _violations(sql) == []


def test_package_function_result_collection_index_parses() -> None:
    """A collection returned by a package function may be indexed immediately."""
    sql = """
CREATE OR REPLACE PACKAGE BODY pkg_test AS
    PROCEDURE UseFirst(a_ObjectId NUMBER) IS
        t_Peer NUMBER := CASE
            WHEN api.pkg_ObjectQuery.RelatedObjects(a_ObjectId, 1).COUNT > 0
            THEN api.pkg_ObjectQuery.RelatedObjects(a_ObjectId, 1)(1)
            ELSE NULL
        END;
    BEGIN
        NULL;
    END UseFirst;
END pkg_test;
/
"""

    assert _violations(sql) == []


def test_package_function_three_part_return_type_parses() -> None:
    """Package functions may return types qualified by schema and package."""
    sql = """
CREATE OR REPLACE PACKAGE pkg_test AS
    FUNCTION UserDetailsForUser(
        a_UserId NUMBER
    ) RETURN extension.pkg_test.udt_UserDetails PIPELINED;
END pkg_test;
/
"""

    assert _violations(sql) == []


def test_package_cursor_parenthesized_set_expression_parses() -> None:
    """Package cursors may wrap UNION queries in parentheses."""
    sql = """
CREATE OR REPLACE PACKAGE BODY pkg_test AS
    FUNCTION UserDetailsForUser(a_UserId NUMBER) RETURN NUMBER IS
        CURSOR c_UserDetails(a_Value NUMBER) IS
        (
            SELECT 1 AS value FROM dual WHERE a_Value = 1
            UNION ALL
            SELECT 2 AS value FROM dual WHERE a_Value = 2
        );
    BEGIN
        RETURN 1;
    END;
END pkg_test;
/
"""

    assert _violations(sql) == []
