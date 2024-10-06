include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("it should correctly create a new test")
  function(add_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" COMMAND)

    set(EXPECTED_COMMAND "${CMAKE_COMMAND}" -P
      ${CMAKE_CURRENT_SOURCE_DIR}/some_test.cmake)
    assert(ARG_COMMAND STREQUAL EXPECTED_COMMAND)
  endfunction()

  assertion_add_test(some_test.cmake)
endsection()

section("it should correctly create a new test with the name specified")
  function(add_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" NAME COMMAND)
    assert(ARG_NAME STREQUAL "some test")

    set(EXPECTED_COMMAND "${CMAKE_COMMAND}" -P
      ${CMAKE_CURRENT_SOURCE_DIR}/some_test.cmake)
    assert(ARG_COMMAND STREQUAL EXPECTED_COMMAND)
  endfunction()

  assertion_add_test(some_test.cmake NAME "some test")
endsection()
