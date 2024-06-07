cmake_minimum_required(VERSION 3.17)

include(Assertion)

section("execute process assertions")
  file(TOUCH some-file)

  assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E true)

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E make_directory some-file ERROR .*)

  assert_fatal_error(
    CALL assert_execute_process COMMAND "${CMAKE_COMMAND}" -E true ERROR .*
    MESSAGE "expected command:\n  ${CMAKE_COMMAND} -E true\nto fail")

  string(
    JOIN "\n" EXPECTED_MESSAGE
    "expected command:"
    "  ${CMAKE_COMMAND} -E make_directory some-file"
    "not to fail")
  assert_fatal_error(
    CALL assert_execute_process
      COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
    MESSAGE "${EXPECTED_MESSAGE}")
endsection()

section("execute process output assertions")
  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
    OUTPUT "Hello.*!")

  string(
    JOIN "\n" EXPECTED_MESSAGE
    "expected the output:"
    "  Hello world!"
    "of command:"
    "  ${CMAKE_COMMAND} -E echo Hello world!"
    "to match:"
    "  Hi.*!")
  assert_fatal_error(
    CALL assert_execute_process
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      OUTPUT "Hi.*!"
    MESSAGE "${EXPECTED_MESSAGE}")
endsection()

section("execute process error assertions")
  file(TOUCH some-file)

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
    ERROR "Error creating directory \"some-file\".")

  string(
    JOIN "\n" EXPECTED_MESSAGE
    "expected the error:"
    "  Error creating directory \"some-file\"."
    "of command:"
    "  ${CMAKE_COMMAND} -E make_directory some-file"
    "to match:"
    "  Error creating directory \"some-other-file\".")
  assert_fatal_error(
    CALL assert_execute_process
      COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
      ERROR "Error creating directory \"some-other-file\"."
    MESSAGE "${EXPECTED_MESSAGE}")
endsection()
