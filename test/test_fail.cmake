cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("it should fail with formatted fatal error messages given strings")
  assert_call(fail "single line string"
    EXPECT_ERROR STREQUAL "single line string")

  assert_call(fail "multiple\nlines\nstring"
    EXPECT_ERROR STREQUAL "multiple\nlines\nstring")

  assert_call(fail "single line string" "multiple\nlines\nstring"
    EXPECT_ERROR STREQUAL "single line string\nmultiple\nlines\nstring")
endsection()

set(SINGLE "single line variable")
set(MULTIPLE "multiple\nlines\nvariable")
set(CONTAINS_SINGLE SINGLE)

section("it should fail with formatted fatal error messages given variables")
  assert_call(fail SINGLE EXPECT_ERROR STREQUAL "single line variable")
  assert_call(fail MULTIPLE EXPECT_ERROR STREQUAL "multiple\nlines\nvariable")

  assert_call(fail CONTAINS_SINGLE
    EXPECT_ERROR STREQUAL "single line variable\nof variable:\n  SINGLE")

  assert_call(fail SINGLE MULTIPLE
    EXPECT_ERROR STREQUAL "single line variable\nmultiple\nlines\nvariable")

  assert_call(fail SINGLE MULTIPLE CONTAINS_SINGLE
    EXPECT_ERROR STREQUAL
      "single line variable\nmultiple\nlines\nvariable\n"
      "single line variable\nof variable:\n  SINGLE")
endsection()

section("it should fail with formatted fatal error messages "
  "given strings and variables")
  assert_call(fail "single line string" SINGLE
    EXPECT_ERROR STREQUAL "single line string:\n  single line variable")

  assert_call(fail SINGLE "single line string"
    EXPECT_ERROR STREQUAL "single line variable\nsingle line string")

  assert_call(fail "multiple\nlines\nstring" MULTIPLE
    EXPECT_ERROR STREQUAL "multiple\nlines\nstring:\n"
      "  multiple\n  lines\n  variable")

  assert_call(fail MULTIPLE "multiple\nlines\nstring"
    EXPECT_ERROR STREQUAL "multiple\nlines\nvariable\nmultiple\nlines\nstring")

  assert_call(fail "single line string" CONTAINS_SINGLE
    EXPECT_ERROR STREQUAL
      "single line string:\n  single line variable\nof variable:\n  SINGLE")

  assert_call(fail CONTAINS_SINGLE "single line string"
    EXPECT_ERROR STREQUAL
      "single line variable\nof variable:\n  SINGLE\nsingle line string")

  assert_call(
    CALL fail "single line string" "multiple\nlines\nstring"
      SINGLE MULTIPLE CONTAINS_SINGLE
    EXPECT_ERROR STREQUAL
      "single line string\nmultiple\nlines\nstring:\n"
      "  single line variable\n  multiple\n  lines\n  variable\n"
      "  single line variable\nof variable:\n  SINGLE")

  assert_call(
    CALL fail SINGLE MULTIPLE CONTAINS_SINGLE
      "single line string" "multiple\nlines\nstring"
    EXPECT_ERROR STREQUAL
      "single line variable\nmultiple\nlines\nvariable\n"
      "single line variable\nof variable:\n  SINGLE\n"
      "single line string\nmultiple\nlines\nstring")

  assert_call(
    CALL fail "single line string" SINGLE "multiple\nlines\nstring" MULTIPLE
    EXPECT_ERROR STREQUAL
      "single line string:\n  single line variable\n"
      "multiple\nlines\nstring:\n  multiple\n  lines\n  variable")

  assert_call(
    CALL fail SINGLE "single line string" MULTIPLE "multiple\nlines\nstring"
    EXPECT_ERROR STREQUAL "single line variable\nsingle line string:\n"
      "  multiple\n  lines\n  variable\nmultiple\nlines\nstring")
endsection()
