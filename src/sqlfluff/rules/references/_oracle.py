"""Oracle-specific helpers for reference rules."""

from __future__ import annotations

import re
from itertools import pairwise

from sqlfluff.core.parser import BaseSegment


def find_oracle_variable_names(segment: BaseSegment) -> set[str]:
    """Return PL/SQL variable and parameter names declared in the current file."""
    variable_names: set[str] = set()

    # In Oracle PL/SQL, declared variable names are the leading identifier in each
    # declaration entry within a declare segment.
    for declare in segment.recursive_crawl("declare_segment"):
        for child in declare.segments:
            if child.is_type("naked_identifier"):
                variable_names.add(child.raw.lower())

    # Routine parameters are represented as `parameter` segments.
    for parameter in segment.recursive_crawl("parameter"):
        param_name = _extract_parameter_name(parameter)
        if param_name:
            variable_names.add(param_name.lower())

    return variable_names


def find_oracle_loop_iterator_names(
    parent_stack: tuple[BaseSegment, ...],
) -> set[str]:
    """Return unquoted FOR iterator names in scope for a nested statement."""
    names: set[str] = set()
    for parent, child in pairwise(parent_stack):
        if not (
            parent.is_type("for_loop_statement") and child.is_type("loop_statement")
        ):
            continue
        # Only identifiers before IN are bindings, not identifiers in the range.
        for segment in parent.segments:
            if segment.is_type("keyword") and segment.raw_upper == "IN":
                break
            if segment.is_type("naked_identifier"):
                names.add(segment.raw.lower())
    return names


def _extract_parameter_name(parameter: BaseSegment) -> str | None:
    for child in parameter.segments:
        if child.is_type("naked_identifier"):
            return child.raw

    match = re.match(r"\s*([A-Za-z][A-Za-z0-9_$#]*)", parameter.raw)
    return match.group(1) if match else None