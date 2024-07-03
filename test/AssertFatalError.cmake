section("it should assert a fatal error message")
  assert_fatal_error(
    CALL message FATAL_ERROR "some fatal error message"
    MESSAGE "some fa.*ror message")
endsection()

section("it should fail to assert a fatal error message")
  macro(failed_assertion)
    assert_fatal_error(
      CALL message FATAL_ERROR "some fatal error message"
      MESSAGE "some other fa.*ror message")
  endmacro()

  assert_fatal_error(
    CALL failed_assertion
    MESSAGE "expected fatal error message:\n"
      "  some fatal error message\n"
      "to match:\n"
      "  some other fa.*ror message")
endsection()

section("it should be able to call the message function")
  message("some unspecified message")
  message(STATUS "some status message")
  message(STATUS "some status message" " with additional information")
endsection()
