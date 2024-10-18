cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("it should assert a fatal error message")
  assert_call(
    CALL message FATAL_ERROR "some fatal error message"
    EXPECT_FATAL_ERROR "some fa.*ror message")

  assert_call(
    CALL message FATAL_ERROR "some fatal error message"
    EXPECT_FATAL_ERROR MATCHES "some fa.*ror message")

  assert_call(
    CALL message FATAL_ERROR "some fatal error message"
    EXPECT_FATAL_ERROR STREQUAL "some fatal error message")
endsection()

section("it should fail to assert a fatal error message")
  macro(failed_assertion)
    assert_call(
      CALL message FATAL_ERROR "some fatal error message"
      EXPECT_FATAL_ERROR "some other fa.*ror message")
  endmacro()

  assert_call(
    CALL failed_assertion
    EXPECT_FATAL_ERROR STREQUAL "expected fatal error message:\n"
      "  some fatal error message\n"
      "to match:\n"
      "  some other fa.*ror message")

  macro(failed_assertion)
    assert_call(
      CALL message FATAL_ERROR "some fatal error message"
      EXPECT_FATAL_ERROR MATCHES "some other fa.*ror message")
  endmacro()

  assert_call(
    CALL failed_assertion
    EXPECT_FATAL_ERROR STREQUAL "expected fatal error message:\n"
      "  some fatal error message\n"
      "to match:\n"
      "  some other fa.*ror message")

  macro(failed_assertion)
    assert_call(
      CALL message FATAL_ERROR "some fatal error message"
      EXPECT_FATAL_ERROR STREQUAL "some other fatal error message")
  endmacro()

  assert_call(
    CALL failed_assertion
    EXPECT_FATAL_ERROR STREQUAL "expected fatal error message:\n"
      "  some fatal error message\n"
      "to be equal to:\n"
      "  some other fatal error message")
endsection()

section("it should fail to assert a fatal error message "
  "because there is nothing to assert")

  macro(failed_assertion)
    assert_call(
      CALL message "some message" EXPECT_FATAL_ERROR "some message")
  endmacro()

  assert_call(
    CALL failed_assertion
    EXPECT_FATAL_ERROR "expected to receive a fatal error message")
endsection()
