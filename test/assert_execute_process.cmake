cmake_minimum_required(VERSION 3.21)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("process execution assertions")
  section("it should assert a process execution")
    assert_execute_process("${CMAKE_COMMAND}" -E true)
  endsection()

  section("it should fail to assert a process execution")
    assert_fatal_error(
      CALL assert_execute_process "${CMAKE_COMMAND}" -E true ERROR .*
      MESSAGE "expected command:\n  ${CMAKE_COMMAND} -E true\nto fail")
  endsection()
endsection()

section("failed process execution assertions")
  file(TOUCH some-file)

  section("it should assert a failed process execution")
    assert_execute_process(
      "${CMAKE_COMMAND}" -E make_directory some-file ERROR .*)
  endsection()

  section("it should fail to assert a failed process execution")
    assert_fatal_error(
      CALL assert_execute_process "${CMAKE_COMMAND}" -E make_directory some-file
      MESSAGE "expected command:\n"
        "  ${CMAKE_COMMAND} -E make_directory some-file\n"
        "not to fail with error:\n"
        "  Error creating directory \"some-file\".")
  endsection()
endsection()

section("process execution output assertions")
  section("it should assert a process execution output")
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      OUTPUT "Hello" ".*!")
  endsection()

  section("it should fail to assert a process execution output")
    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
        OUTPUT "Hello" ".*earth!"
      MESSAGE "expected the output:\n"
        ".*\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E echo Hello world!\n"
        "to match:\n"
        "  Hello.*earth!")
  endsection()
endsection()

section("process execution error assertions")
  file(TOUCH some-file)

  section("it should assert a process execution error")
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
      ERROR "Error creating directory" ".*some-file")
  endsection()

  section("it should fail to assert a process execution error")
    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
        ERROR "Error creating directory" ".*some-other-file"
      MESSAGE "expected the error:\n"
        ".*\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E make_directory some-file\n"
        "to match:\n"
        "  Error creating directory.*some-other-file")
  endsection()
endsection()
