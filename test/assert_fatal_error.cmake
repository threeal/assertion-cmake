cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("it should assert a fatal error message")
  assert_fatal_error(
    CALL message FATAL_ERROR "some fatal error message"
    EXPECT_MESSAGE "some fa.*ror message")

  assert_fatal_error(
    CALL message FATAL_ERROR "some fatal error message "
      "with additional message"
    EXPECT_MESSAGE "some fa.*ror message with additional message")
endsection()

section("it should fail to assert a fatal error message")
  macro(failed_assertion)
    assert_fatal_error(
      CALL message FATAL_ERROR "some fatal error message"
      EXPECT_MESSAGE "some other fa.*ror message")
  endmacro()

  assert_fatal_error(
    CALL failed_assertion
    EXPECT_MESSAGE "expected fatal error message:\n"
      "  some fatal error message\n"
      "to match:\n"
      "  some other fa.*ror message")
endsection()

section("it should fail to assert a fatal error message "
  "because there is nothing to assert")

  macro(failed_assertion)
    assert_fatal_error(
      CALL message "some message" EXPECT_MESSAGE "some message")
  endmacro()

  assert_fatal_error(
    CALL failed_assertion
    EXPECT_MESSAGE "expected to receive a fatal error message that matches:\n"
      "  some message")
endsection()
