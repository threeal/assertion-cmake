cmake_minimum_required(VERSION 3.24)

include(Assertion)

set(STRING_VAR "a string")
set(OTHER_STRING_VAR "another string")

section("assert string equality conditions given equal strings")
  section("it should assert conditions")
    assert(NOT "a string" STRLESS "a string")
    assert(NOT "a string" STRGREATER "a string")
    assert("a string" STREQUAL "a string")
    assert("a string" STRLESS_EQUAL "a string")
    assert("a string" STRGREATER_EQUAL "a string")

    assert(NOT STRING_VAR STRLESS STRING_VAR)
    assert(NOT STRING_VAR STRGREATER STRING_VAR)
    assert(STRING_VAR STREQUAL STRING_VAR)
    assert(STRING_VAR STRLESS_EQUAL STRING_VAR)
    assert(STRING_VAR STRGREATER_EQUAL STRING_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "a string" STRLESS "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "to be less than:\n  a string")

    assert_call(assert "a string" STRGREATER "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "to be greater than:\n  a string")

    assert_call(assert NOT "a string" STREQUAL "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "not to be equal to:\n  a string")

    assert_call(assert NOT "a string" STRLESS_EQUAL "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "not to be less than or equal to:\n  a string")

    assert_call(assert NOT "a string" STRGREATER_EQUAL "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "not to be greater than or equal to:\n  a string")
  endsection()
endsection()

section("assert string equality conditions given a lesser string")
  section("it should assert conditions")
    assert("a string" STRLESS "another string")
    assert(NOT "a string" STRGREATER "another string")
    assert(NOT "a string" STREQUAL "another string")
    assert("a string" STRLESS_EQUAL "another string")
    assert(NOT "a string" STRGREATER_EQUAL "another string")

    assert(STRING_VAR STRLESS OTHER_STRING_VAR)
    assert(NOT STRING_VAR STRGREATER OTHER_STRING_VAR)
    assert(NOT STRING_VAR STREQUAL OTHER_STRING_VAR)
    assert(STRING_VAR STRLESS_EQUAL OTHER_STRING_VAR)
    assert(NOT STRING_VAR STRGREATER_EQUAL OTHER_STRING_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert NOT "a string" STRLESS "another string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "not to be less than:\n  another string")

    assert_call(assert "a string" STRGREATER "another string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "to be greater than:\n  another string")

    assert_call(assert "a string" STREQUAL "another string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "to be equal to:\n  another string")

    assert_call(assert NOT "a string" STRLESS_EQUAL "another string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "not to be less than or equal to:\n  another string")

    assert_call(assert "a string" STRGREATER_EQUAL "another string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "to be greater than or equal to:\n  another string")
  endsection()
endsection()

section("assert string equality conditions given a greater string")
  section("it should assert conditions")
    assert(NOT "another string" STRLESS "a string")
    assert("another string" STRGREATER "a string")
    assert(NOT "another string" STREQUAL "a string")
    assert(NOT "another string" STRLESS_EQUAL "a string")
    assert("another string" STRGREATER_EQUAL "a string")

    assert(NOT OTHER_STRING_VAR STRLESS STRING_VAR)
    assert(OTHER_STRING_VAR STRGREATER STRING_VAR)
    assert(NOT OTHER_STRING_VAR STREQUAL STRING_VAR)
    assert(NOT OTHER_STRING_VAR STRLESS_EQUAL STRING_VAR)
    assert(OTHER_STRING_VAR STRGREATER_EQUAL STRING_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "another string" STRLESS "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  another string\n"
        "to be less than:\n  a string")

    assert_call(assert NOT "another string" STRGREATER "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  another string\n"
        "not to be greater than:\n  a string")

    assert_call(assert "another string" STREQUAL "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  another string\n"
        "to be equal to:\n  a string")

    assert_call(assert "another string" STRLESS_EQUAL "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  another string\n"
        "to be less than or equal to:\n  a string")

    assert_call(assert NOT "another string" STRGREATER_EQUAL "a string"
      EXPECT_ERROR STREQUAL "expected string:\n  another string\n"
        "not to be greater than or equal to:\n  a string")
  endsection()
endsection()
