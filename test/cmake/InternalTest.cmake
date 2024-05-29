cmake_minimum_required(VERSION 3.5)

include(Assertion)

function("Variable content retrieval")
  _assert_internal_get_content("some value" CONTENT)
  assert(CONTENT STREQUAL "some value")

  set(SOME_VARIABLE "some other value")
  _assert_internal_get_content(SOME_VARIABLE CONTENT)
  assert(CONTENT STREQUAL "some other value")
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
