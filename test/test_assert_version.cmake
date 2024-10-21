cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

set(VERSION_VAR 1.2.3)
set(VERSIONN_VAR 1.02.3)
set(OTHER_VERSION_VAR 1.3.4)

section("assert version equality conditions given equal versions")
  section("it should assert conditions")
    assert(NOT 1.2.3 VERSION_LESS 1.02.3)
    assert(NOT 1.2.3 VERSION_GREATER 1.02.3)
    assert(1.2.3 VERSION_EQUAL 1.02.3)
    assert(1.2.3 VERSION_LESS_EQUAL 1.02.3)
    assert(1.2.3 VERSION_GREATER_EQUAL 1.02.3)

    assert(NOT VERSION_VAR VERSION_LESS VERSIONN_VAR)
    assert(NOT VERSION_VAR VERSION_GREATER VERSIONN_VAR)
    assert(VERSION_VAR VERSION_EQUAL VERSIONN_VAR)
    assert(VERSION_VAR VERSION_LESS_EQUAL VERSIONN_VAR)
    assert(VERSION_VAR VERSION_GREATER_EQUAL VERSIONN_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert 1.2.3 VERSION_LESS 1.02.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "to be less than:\n  1.02.3")

    assert_call(assert 1.2.3 VERSION_GREATER 1.02.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "to be greater than:\n  1.02.3")

    assert_call(assert NOT 1.2.3 VERSION_EQUAL 1.02.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "not to be equal to:\n  1.02.3")

    assert_call(assert NOT 1.2.3 VERSION_LESS_EQUAL 1.02.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "not to be less than or equal to:\n  1.02.3")

    assert_call(assert NOT 1.2.3 VERSION_GREATER_EQUAL 1.02.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "not to be greater than or equal to:\n  1.02.3")
  endsection()
endsection()

section("assert version equality conditions given a lesser version")
  section("it should assert conditions")
    assert(1.2.3 VERSION_LESS 1.3.4)
    assert(NOT 1.2.3 VERSION_GREATER 1.3.4)
    assert(NOT 1.2.3 VERSION_EQUAL 1.3.4)
    assert(1.2.3 VERSION_LESS_EQUAL 1.3.4)
    assert(NOT 1.2.3 VERSION_GREATER_EQUAL 1.3.4)

    assert(VERSION_VAR VERSION_LESS OTHER_VERSION_VAR)
    assert(NOT VERSION_VAR VERSION_GREATER OTHER_VERSION_VAR)
    assert(NOT VERSION_VAR VERSION_EQUAL OTHER_VERSION_VAR)
    assert(VERSION_VAR VERSION_LESS_EQUAL OTHER_VERSION_VAR)
    assert(NOT VERSION_VAR VERSION_GREATER_EQUAL OTHER_VERSION_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert NOT 1.2.3 VERSION_LESS 1.3.4
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "not to be less than:\n  1.3.4")

    assert_call(assert 1.2.3 VERSION_GREATER 1.3.4
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "to be greater than:\n  1.3.4")

    assert_call(assert 1.2.3 VERSION_EQUAL 1.3.4
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "to be equal to:\n  1.3.4")

    assert_call(assert NOT 1.2.3 VERSION_LESS_EQUAL 1.3.4
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "not to be less than or equal to:\n  1.3.4")

    assert_call(assert 1.2.3 VERSION_GREATER_EQUAL 1.3.4
      EXPECT_ERROR STREQUAL "expected version:\n  1.2.3\n"
        "to be greater than or equal to:\n  1.3.4")
  endsection()
endsection()

section("assert version equality conditions given a greater version")
  section("it should assert conditions")
    assert(NOT 1.3.4 VERSION_LESS 1.2.3)
    assert(1.3.4 VERSION_GREATER 1.2.3)
    assert(NOT 1.3.4 VERSION_EQUAL 1.2.3)
    assert(NOT 1.3.4 VERSION_LESS_EQUAL 1.2.3)
    assert(1.3.4 VERSION_GREATER_EQUAL 1.2.3)

    assert(NOT OTHER_VERSION_VAR VERSION_LESS VERSION_VAR)
    assert(OTHER_VERSION_VAR VERSION_GREATER VERSION_VAR)
    assert(NOT OTHER_VERSION_VAR VERSION_EQUAL VERSION_VAR)
    assert(NOT OTHER_VERSION_VAR VERSION_LESS_EQUAL VERSION_VAR)
    assert(OTHER_VERSION_VAR VERSION_GREATER_EQUAL VERSION_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert 1.3.4 VERSION_LESS 1.2.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.3.4\n"
        "to be less than:\n  1.2.3")

    assert_call(assert NOT 1.3.4 VERSION_GREATER 1.2.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.3.4\n"
        "not to be greater than:\n  1.2.3")

    assert_call(assert 1.3.4 VERSION_EQUAL 1.2.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.3.4\n"
        "to be equal to:\n  1.2.3")

    assert_call(assert 1.3.4 VERSION_LESS_EQUAL 1.2.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.3.4\n"
        "to be less than or equal to:\n  1.2.3")

    assert_call(assert NOT 1.3.4 VERSION_GREATER_EQUAL 1.2.3
      EXPECT_ERROR STREQUAL "expected version:\n  1.3.4\n"
        "not to be greater than or equal to:\n  1.2.3")
  endsection()
endsection()
