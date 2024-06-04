cmake_minimum_required(VERSION 3.5)

include(Assertion)

_assert_internal_mock_message()
  message(WARNING "some warning message")
  message(WARNING "some other warning message")

  _assert_internal_mock_message()
    message(ERROR "some error message")
  _assert_internal_end_mock_message()

  message(FATAL_ERROR "some fatal error message")
  message(ERROR "some other error message")
_assert_internal_end_mock_message()

assert(DEFINED WARNING_MESSAGES)
assert(WARNING_MESSAGES STREQUAL "some warning message;some other warning message")

assert(DEFINED ERROR_MESSAGES)
assert(ERROR_MESSAGES STREQUAL "some error message")

assert(DEFINED FATAL_ERROR_MESSAGES)
assert(FATAL_ERROR_MESSAGES STREQUAL "some fatal error message")
