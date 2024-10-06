cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("given strings")
  section("it should fail with a formatted fatal error message")
    assert_fatal_error(
      CALL fail "single line string"
      MESSAGE "single line string")

    assert_fatal_error(
      CALL fail "multiple\nlines\nstring"
      MESSAGE "multiple\nlines\nstring")

    assert_fatal_error(
      CALL fail "single line string" "multiple\nlines\nstring"
      MESSAGE "single line string\nmultiple\nlines\nstring")
  endsection()
endsection()

set(SINGLE "single line variable")
set(MULTIPLE "multiple\nlines\nvariable")
set(CONTAINS_SINGLE SINGLE)

section("given variables")
  section("it should fail with a formatted fatal error message")
    assert_fatal_error(
      CALL fail SINGLE
      MESSAGE "single line variable")

    assert_fatal_error(
      CALL fail MULTIPLE
      MESSAGE "multiple\nlines\nvariable")

    assert_fatal_error(
      CALL fail CONTAINS_SINGLE
      MESSAGE "single line variable\nof variable:\n  SINGLE")

    assert_fatal_error(
      CALL fail SINGLE MULTIPLE
      MESSAGE "single line variable\nmultiple\nlines\nvariable")

    assert_fatal_error(
      CALL fail SINGLE MULTIPLE CONTAINS_SINGLE
      MESSAGE "single line variable\nmultiple\nlines\nvariable\n"
        "single line variable\nof variable:\n  SINGLE")
  endsection()
endsection()

section("given strings and variables")
  section("it should fail with a formatted fatal error message")
    assert_fatal_error(
      CALL fail "single line string" SINGLE
      MESSAGE "single line string:\n  single line variable")

    assert_fatal_error(
      CALL fail SINGLE "single line string"
      MESSAGE "single line variable\nsingle line string")

    assert_fatal_error(
      CALL fail "multiple\nlines\nstring" MULTIPLE
      MESSAGE "multiple\nlines\nstring:\n  multiple\n  lines\n  variable")

    assert_fatal_error(
      CALL fail MULTIPLE "multiple\nlines\nstring"
      MESSAGE "multiple\nlines\nvariable\nmultiple\nlines\nstring")

    assert_fatal_error(
      CALL fail "single line string" CONTAINS_SINGLE
      MESSAGE "single line string:\n  single line variable\n"
        "of variable:\n  SINGLE")

    assert_fatal_error(
      CALL fail CONTAINS_SINGLE "single line string"
      MESSAGE "single line variable\nof variable:\n  SINGLE\n"
        "single line string")

    assert_fatal_error(
      CALL fail "single line string" "multiple\nlines\nstring"
        SINGLE MULTIPLE CONTAINS_SINGLE
      MESSAGE "single line string\nmultiple\nlines\nstring:\n"
        "  single line variable\n  multiple\n  lines\n  variable\n"
        "  single line variable\nof variable:\n  SINGLE")

    assert_fatal_error(
      CALL fail SINGLE MULTIPLE CONTAINS_SINGLE
        "single line string" "multiple\nlines\nstring"
      MESSAGE "single line variable\nmultiple\nlines\nvariable\n"
        "single line variable\nof variable:\n  SINGLE\n"
        "single line string\nmultiple\nlines\nstring")

    assert_fatal_error(
      CALL fail "single line string" SINGLE "multiple\nlines\nstring" MULTIPLE
      MESSAGE "single line string:\n  single line variable\n"
        "multiple\nlines\nstring:\n  multiple\n  lines\n  variable")

    assert_fatal_error(
      CALL fail SINGLE "single line string" MULTIPLE "multiple\nlines\nstring"
      MESSAGE "single line variable\nsingle line string:\n"
        "  multiple\n  lines\n  variable\nmultiple\nlines\nstring")
  endsection()
endsection()
