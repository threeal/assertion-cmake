cmake_minimum_required(VERSION 3.24)

include(Assertion)

set(SEVEN_VAR 7)
set(THIRTEEN_VAR 13)

section("assert number equality conditions given equal numbers")
  section("it should assert conditions")
    assert(NOT 7 LESS 7)
    assert(NOT 7 GREATER 7)
    assert(7 EQUAL 7)
    assert(7 LESS_EQUAL 7)
    assert(7 GREATER_EQUAL 7)

    assert(NOT SEVEN_VAR LESS SEVEN_VAR)
    assert(NOT SEVEN_VAR GREATER SEVEN_VAR)
    assert(SEVEN_VAR EQUAL SEVEN_VAR)
    assert(SEVEN_VAR LESS_EQUAL SEVEN_VAR)
    assert(SEVEN_VAR GREATER_EQUAL SEVEN_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert 7 LESS 7
      EXPECT_ERROR STREQUAL "expected number:\n  7\nto be less than:\n  7")

    assert_call(assert 7 GREATER 7
      EXPECT_ERROR STREQUAL "expected number:\n  7\nto be greater than:\n  7")

    assert_call(assert NOT 7 EQUAL 7
      EXPECT_ERROR STREQUAL "expected number:\n  7\nnot to be equal to:\n  7")

    assert_call(assert NOT 7 LESS_EQUAL 7
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "not to be less than or equal to:\n  7")

    assert_call(assert NOT 7 GREATER_EQUAL 7
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "not to be greater than or equal to:\n  7")
  endsection()
endsection()

section("assert number equality conditions given a lesser number")
  section("it should assert conditions")
    assert(7 LESS 13)
    assert(NOT 7 GREATER 13)
    assert(NOT 7 EQUAL 13)
    assert(7 LESS_EQUAL 13)
    assert(NOT 7 GREATER_EQUAL 13)

    assert(SEVEN_VAR LESS THIRTEEN_VAR)
    assert(NOT SEVEN_VAR GREATER THIRTEEN_VAR)
    assert(NOT SEVEN_VAR EQUAL THIRTEEN_VAR)
    assert(SEVEN_VAR LESS_EQUAL THIRTEEN_VAR)
    assert(NOT SEVEN_VAR GREATER_EQUAL THIRTEEN_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert NOT 7 LESS 13
      EXPECT_ERROR STREQUAL "expected number:\n  7\nnot to be less than:\n  13")

    assert_call(assert 7 GREATER 13
      EXPECT_ERROR STREQUAL "expected number:\n  7\nto be greater than:\n  13")

    assert_call(assert 7 EQUAL 13
      EXPECT_ERROR STREQUAL "expected number:\n  7\nto be equal to:\n  13")

    assert_call(assert NOT 7 LESS_EQUAL 13
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "not to be less than or equal to:\n  13")

    assert_call(assert 7 GREATER_EQUAL 13
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "to be greater than or equal to:\n  13")
  endsection()
endsection()

section("assert number equality conditions given a greater number")
  section("it should assert conditions")
    assert(NOT 13 LESS 7)
    assert(13 GREATER 7)
    assert(NOT 13 EQUAL 7)
    assert(NOT 13 LESS_EQUAL 7)
    assert(13 GREATER_EQUAL 7)

    assert(NOT THIRTEEN_VAR LESS SEVEN_VAR)
    assert(THIRTEEN_VAR GREATER SEVEN_VAR)
    assert(NOT THIRTEEN_VAR EQUAL SEVEN_VAR)
    assert(NOT THIRTEEN_VAR LESS_EQUAL SEVEN_VAR)
    assert(THIRTEEN_VAR GREATER_EQUAL SEVEN_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert 13 LESS 7
      EXPECT_ERROR STREQUAL "expected number:\n  13\nto be less than:\n  7")

    assert_call(assert NOT 13 GREATER 7
      EXPECT_ERROR STREQUAL "expected number:\n  13\n"
        "not to be greater than:\n  7")

    assert_call(assert 13 EQUAL 7
      EXPECT_ERROR STREQUAL "expected number:\n  13\nto be equal to:\n  7")

    assert_call(assert 13 LESS_EQUAL 7
      EXPECT_ERROR STREQUAL "expected number:\n  13\n"
        "to be less than or equal to:\n  7")

    assert_call(assert NOT 13 GREATER_EQUAL 7
      EXPECT_ERROR STREQUAL "expected number:\n  13\n"
        "not to be greater than or equal to:\n  7")
  endsection()
endsection()

section("assert number equality conditions given a non-number")
  section("it should assert conditions")
    set(STRING_VAR "a string")

    assert(NOT 7 LESS "a string")
    assert(NOT 7 GREATER "a string")
    assert(NOT 7 EQUAL "a string")
    assert(NOT 7 LESS_EQUAL "a string")
    assert(NOT 7 GREATER_EQUAL "a string")

    assert(NOT SEVEN_VAR LESS STRING_VAR)
    assert(NOT SEVEN_VAR GREATER STRING_VAR)
    assert(NOT SEVEN_VAR EQUAL STRING_VAR)
    assert(NOT SEVEN_VAR LESS_EQUAL STRING_VAR)
    assert(NOT SEVEN_VAR GREATER_EQUAL STRING_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert 7 LESS  "a string"
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "to be less than:\n  a string")

    assert_call(assert 7 GREATER "a string"
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "to be greater than:\n  a string")

    assert_call(assert 7 EQUAL "a string"
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "to be equal to:\n  a string")

    assert_call(assert 7 LESS_EQUAL "a string"
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "to be less than or equal to:\n  a string")

    assert_call(assert 7 GREATER_EQUAL "a string"
      EXPECT_ERROR STREQUAL "expected number:\n  7\n"
        "to be greater than or equal to:\n  a string")
  endsection()
endsection()
