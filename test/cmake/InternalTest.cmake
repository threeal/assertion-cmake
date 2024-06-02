cmake_minimum_required(VERSION 3.5)

include(Assertion)

function("Variable content retrieval")
  _assert_internal_get_content("some value" CONTENT)
  assert(CONTENT STREQUAL "some value")

  set(SOME_VARIABLE "some other value")
  _assert_internal_get_content(SOME_VARIABLE CONTENT)
  assert(CONTENT STREQUAL "some other value")
endfunction()

function("Assertion message formatting")
  _assert_internal_format_message(
    MESSAGE "first line" "second line" "third line\nthird line" "fourth line\nfourth line")

  string(
    JOIN "\n" EXPECTED_MESSAGE
    "first line"
    "  second line"
    "third line"
    "third line"
    "  fourth line"
    "  fourth line")
  assert(MESSAGE STREQUAL EXPECTED_MESSAGE)
endfunction()

function("Message function mocking")
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
  assert("${ERROR_MESSAGES}" STREQUAL "some error message")

  assert(DEFINED FATAL_ERROR_MESSAGES)
  assert("${FATAL_ERROR_MESSAGES}" STREQUAL "some fatal error message")
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
