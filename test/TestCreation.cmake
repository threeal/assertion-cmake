section("it should correctly create a new test")
  function(add_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "NAME" "COMMAND")
    assert(ARG_NAME STREQUAL "some test")

    set(EXPECTED_COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- ${CMAKE_CURRENT_SOURCE_DIR}/some_test.cmake)
    assert(ARG_COMMAND STREQUAL EXPECTED_COMMAND)
  endfunction()

  assertion_add_test("some test" some_test.cmake)
endsection()
