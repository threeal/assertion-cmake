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
    OUTPUT "Hello" ".*!")

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

section("execute process error assertions")
  file(TOUCH some-file)

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
    ERROR "Error creating directory" ".*some-file")

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
