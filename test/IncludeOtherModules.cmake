cmake_minimum_required(VERSION 3.17)

find_package(Assertion REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

section("it should include modules")
  file(WRITE foo.cmake "message(STATUS \"foo\")\n")
  file(WRITE goo.cmake "message(STATUS \"goo\")\n")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}"
      -P ${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake
      -- foo.cmake goo.cmake
    OUTPUT ".*foo\n.*goo")
endsection()

section("it should not include any modules if arguments are not specified")
  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}"
      -P ${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake
    OUTPUT "^$")
endsection()

section("it should not include any modules if included by another module")
  file(WRITE root.cmake
    "include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)\n")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -P root.cmake -- foo.cmake goo.cmake
    OUTPUT "^$")
endsection()
