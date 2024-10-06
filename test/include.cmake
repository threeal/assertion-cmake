include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("it should include modules")
  file(WRITE foo.cmake "message(STATUS \"foo\")\n")
  file(WRITE goo.cmake "message(STATUS \"goo\")\n")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
      -- foo.cmake goo.cmake
    OUTPUT ".*foo\n.*goo")
endsection()

section("it should not include any modules if arguments are not specified")
  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -P "${ASSERTION_LIST_FILE}"
    OUTPUT "^$")
endsection()

section("it should not include any modules if included by another module")
  file(WRITE root.cmake "include(\"${ASSERTION_LIST_FILE}\")\n")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -P root.cmake -- foo.cmake goo.cmake
    OUTPUT "^$")
endsection()
