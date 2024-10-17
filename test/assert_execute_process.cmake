cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("process execution assertions")
  section("it should assert a process execution")
    assert_execute_process("${CMAKE_COMMAND}" -E true)
  endsection()

  section("it should fail to assert a process execution")
    assert_fatal_error(
      CALL assert_execute_process "${CMAKE_COMMAND}" -E true EXPECT_FAIL
      EXPECT_MESSAGE STREQUAL "expected command:\n"
        "  ${CMAKE_COMMAND} -E true\nto fail")
  endsection()
endsection()

section("failed process execution assertions")
  file(TOUCH some-file)

  section("it should assert a failed process execution")
    assert_execute_process(
      "${CMAKE_COMMAND}" -E make_directory some-file EXPECT_FAIL)
  endsection()

  section("it should fail to assert a failed process execution")
    assert_fatal_error(
      CALL assert_execute_process "${CMAKE_COMMAND}" -E make_directory some-file
      EXPECT_MESSAGE STREQUAL "expected command:\n"
        "  ${CMAKE_COMMAND} -E make_directory some-file\n"
        "not to fail with error:\n"
        "  Error creating directory \"some-file\".")
  endsection()
endsection()

section("process execution output assertions")
  section("it should assert a process execution output")
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      EXPECT_OUTPUT "Hello" ".*!")

    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      EXPECT_OUTPUT MATCHES "Hello" ".*!")

    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      EXPECT_OUTPUT STREQUAL "Hello world!")
  endsection()

  section("it should fail to assert a process execution output")
    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
        EXPECT_OUTPUT "Hello" ".*earth!"
      EXPECT_MESSAGE STREQUAL "expected the output:\n"
        "  Hello world!\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E echo Hello world!\n"
        "to match:\n"
        "  Hello.*earth!")

    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
        EXPECT_OUTPUT MATCHES "Hello" ".*earth!"
      EXPECT_MESSAGE STREQUAL "expected the output:\n"
        "  Hello world!\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E echo Hello world!\n"
        "to match:\n"
        "  Hello.*earth!")

    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
        EXPECT_OUTPUT STREQUAL "Hello earth!\n"
      EXPECT_MESSAGE STREQUAL "expected the output:\n"
        "  Hello world!\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E echo Hello world!\n"
        "to be equal to:\n"
        "  Hello earth!")
  endsection()
endsection()

section("process execution error assertions")
  file(TOUCH some-file)

  section("it should assert a process execution error")
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
      EXPECT_ERROR "Error creating directory" ".*some-file")

    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
      EXPECT_ERROR MATCHES "Error creating directory" ".*some-file")

    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
      EXPECT_ERROR STREQUAL "Error creating directory \"some-file\".")
  endsection()

  section("it should fail to assert a process execution error")
    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
        EXPECT_ERROR "Error creating directory" ".*some-other-file"
      EXPECT_MESSAGE STREQUAL "expected the error:\n"
        "  Error creating directory \"some-file\".\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E make_directory some-file\n"
        "to match:\n"
        "  Error creating directory.*some-other-file")

    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
        EXPECT_ERROR MATCHES "Error creating directory" ".*some-other-file"
      EXPECT_MESSAGE STREQUAL "expected the error:\n"
        "  Error creating directory \"some-file\".\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E make_directory some-file\n"
        "to match:\n"
        "  Error creating directory.*some-other-file")

    assert_fatal_error(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E make_directory some-file
        EXPECT_ERROR STREQUAL "Error creating directory \"some-other-file\"."
      EXPECT_MESSAGE STREQUAL "expected the error:\n"
        "  Error creating directory \"some-file\".\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E make_directory some-file\n"
        "to be equal to:\n"
        "  Error creating directory \"some-other-file\".")
  endsection()
endsection()
