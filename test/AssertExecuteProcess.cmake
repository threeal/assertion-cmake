cmake_minimum_required(VERSION 3.17)

find_package(Assertion REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

section("execute process assertions")
  file(TOUCH some-file)

  assert_execute_process("${CMAKE_COMMAND}" -E true)

  assert_execute_process(
    "${CMAKE_COMMAND}" -E make_directory some-file ERROR .*)

  assert_fatal_error(
    CALL assert_execute_process "${CMAKE_COMMAND}" -E true ERROR .*
    MESSAGE "expected command:\n  ${CMAKE_COMMAND} -E true\nto fail")

  assert_fatal_error(
    CALL assert_execute_process "${CMAKE_COMMAND}" -E make_directory some-file
    MESSAGE "expected command:\n"
      "  ${CMAKE_COMMAND} -E make_directory some-file\n"
      "not to fail with error:\n"
      "  Error creating directory \"some-file\".")
endsection()

section("execute process output assertions")
  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
    OUTPUT "Hello.*!")

  assert_fatal_error(
    CALL assert_execute_process
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      OUTPUT "Hi.*!"
    MESSAGE "expected the output:\n"
      "  Hello world!\n"
      "of command:\n"
      "  ${CMAKE_COMMAND} -E echo Hello world!\n"
      "to match:\n"
      "  Hi.*!")
endsection()

section("execute process error assertions")
  file(TOUCH some-file)

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
    ERROR "Error creating directory \"some-file\".")

  assert_fatal_error(
    CALL assert_execute_process
      COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
      ERROR "Error creating directory \"some-other-file\"."
    MESSAGE "expected the error:\n"
      "  Error creating directory \"some-file\".\n"
      "of command:\n"
      "  ${CMAKE_COMMAND} -E make_directory some-file\n"
      "to match:\n"
      "  Error creating directory \"some-other-file\".")
endsection()
