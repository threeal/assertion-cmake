include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("it should create a new test")
  function(add_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" COMMAND)

    set(EXPECTED_COMMAND "${CMAKE_COMMAND}" -P
      ${CMAKE_CURRENT_BINARY_DIR}/some_test.cmake)
    assert(ARG_COMMAND STREQUAL EXPECTED_COMMAND)
  endfunction()

  add_cmake_script_test(some_test.cmake)
endsection()

section("it should create a new test "
  "with the file specified using an absolute path")
  function(add_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" COMMAND)

    set(EXPECTED_COMMAND "${CMAKE_COMMAND}" -P
      ${CMAKE_CURRENT_BINARY_DIR}/some_test.cmake)
    assert(ARG_COMMAND STREQUAL EXPECTED_COMMAND)
  endfunction()

  add_cmake_script_test(${CMAKE_CURRENT_BINARY_DIR}/some_test.cmake)
endsection()

section("it should create a new test with the specified name")
  function(add_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" NAME COMMAND)
    assert(ARG_NAME STREQUAL "some test")

    set(EXPECTED_COMMAND "${CMAKE_COMMAND}" -P
      ${CMAKE_CURRENT_BINARY_DIR}/some_test.cmake)
    assert(ARG_COMMAND STREQUAL EXPECTED_COMMAND)
  endfunction()

  add_cmake_script_test(some_test.cmake NAME "some test")
endsection()
