cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

set(STRING_VAR "some string")
set(OTHER_STRING_VAR "some other string")

section("assert string equality conditions given equal strings")
  section("it should assert conditions")
    assert(NOT "some string" STRLESS "some string")
    assert(NOT "some string" STRGREATER "some string")
    assert("some string" STREQUAL "some string")
    assert("some string" STRLESS_EQUAL "some string")
    assert("some string" STRGREATER_EQUAL "some string")

    assert(NOT STRING_VAR STRLESS STRING_VAR)
    assert(NOT STRING_VAR STRGREATER STRING_VAR)
    assert(STRING_VAR STREQUAL STRING_VAR)
    assert(STRING_VAR STRLESS_EQUAL STRING_VAR)
    assert(STRING_VAR STRGREATER_EQUAL STRING_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "some string" STRLESS "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "to be less than:\n  some string")

    assert_call(assert "some string" STRGREATER "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "to be greater than:\n  some string")

    assert_call(assert NOT "some string" STREQUAL "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "not to be equal to:\n  some string")

    assert_call(assert NOT "some string" STRLESS_EQUAL "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "not to be less than or equal to:\n  some string")

    assert_call(assert NOT "some string" STRGREATER_EQUAL "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "not to be greater than or equal to:\n  some string")
  endsection()
endsection()

section("assert string equality conditions given a lesser string")
  section("it should assert conditions")
    assert("some other string" STRLESS "some string")
    assert(NOT "some other string" STRGREATER "some string")
    assert(NOT "some other string" STREQUAL "some string")
    assert("some other string" STRLESS_EQUAL "some string")
    assert(NOT "some other string" STRGREATER_EQUAL "some string")

    assert(OTHER_STRING_VAR STRLESS STRING_VAR)
    assert(NOT OTHER_STRING_VAR STRGREATER STRING_VAR)
    assert(NOT OTHER_STRING_VAR STREQUAL STRING_VAR)
    assert(OTHER_STRING_VAR STRLESS_EQUAL STRING_VAR)
    assert(NOT OTHER_STRING_VAR STRGREATER_EQUAL STRING_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert NOT "some other string" STRLESS "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some other string\n"
        "not to be less than:\n  some string")

    assert_call(assert "some other string" STRGREATER "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some other string\n"
        "to be greater than:\n  some string")

    assert_call(assert "some other string" STREQUAL "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some other string\n"
        "to be equal to:\n  some string")

    assert_call(assert NOT "some other string" STRLESS_EQUAL "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some other string\n"
        "not to be less than or equal to:\n  some string")

    assert_call(assert "some other string" STRGREATER_EQUAL "some string"
      EXPECT_ERROR STREQUAL "expected string:\n  some other string\n"
        "to be greater than or equal to:\n  some string")
  endsection()
endsection()

section("assert string equality conditions given a greater string")
  section("it should assert conditions")
    assert(NOT "some string" STRLESS "some other string")
    assert("some string" STRGREATER "some other string")
    assert(NOT "some string" STREQUAL "some other string")
    assert(NOT "some string" STRLESS_EQUAL "some other string")
    assert("some string" STRGREATER_EQUAL "some other string")

    assert(NOT STRING_VAR STRLESS OTHER_STRING_VAR)
    assert(STRING_VAR STRGREATER OTHER_STRING_VAR)
    assert(NOT STRING_VAR STREQUAL OTHER_STRING_VAR)
    assert(NOT STRING_VAR STRLESS_EQUAL OTHER_STRING_VAR)
    assert(STRING_VAR STRGREATER_EQUAL OTHER_STRING_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "some string" STRLESS "some other string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "to be less than:\n  some other string")

    assert_call(assert NOT "some string" STRGREATER "some other string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "not to be greater than:\n  some other string")

    assert_call(assert "some string" STREQUAL "some other string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "to be equal to:\n  some other string")

    assert_call(assert "some string" STRLESS_EQUAL "some other string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "to be less than or equal to:\n  some other string")

    assert_call(assert NOT "some string" STRGREATER_EQUAL "some other string"
      EXPECT_ERROR STREQUAL "expected string:\n  some string\n"
        "not to be greater than or equal to:\n  some other string")
  endsection()
endsection()
