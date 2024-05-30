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

cmake_language(CALL "${TEST_COMMAND}")
