cmake_minimum_required(VERSION 3.24)

include(Assertion)

section("assert process executions")
  section("it should assert process executions")
    assert_execute_process("${CMAKE_COMMAND}" -E true)
  endsection()

  section("it should fail to assert process executions")
    assert_call(
      CALL assert_execute_process "${CMAKE_COMMAND}" -E true EXPECT_FAIL
      EXPECT_ERROR STREQUAL "expected command:\n"
        "  ${CMAKE_COMMAND} -E true\nto fail")
  endsection()
endsection()

section("assert failed process executions")
  file(TOUCH a_file)

  section("it should assert failed process executions")
    assert_execute_process(
      "${CMAKE_COMMAND}" -E make_directory a_file EXPECT_FAIL)
  endsection()

  section("it should fail to assert failed process executions")
    assert_call(
      CALL assert_execute_process "${CMAKE_COMMAND}" -E make_directory a_file
      EXPECT_ERROR STREQUAL "expected command:\n"
        "  ${CMAKE_COMMAND} -E make_directory a_file\n"
        "not to fail with error:\n"
        "  Error creating directory \"a_file\".")
  endsection()

  file(REMOVE a_file)
endsection()

section("assert process execution outputs")
  section("it should assert process execution outputs")
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

  section("it should fail to assert process execution outputs")
    assert_call(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
        EXPECT_OUTPUT "Hello" ".*earth!"
      EXPECT_ERROR STREQUAL "expected the output:\n"
        "  Hello world!\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E echo Hello world!\n"
        "to match:\n"
        "  Hello.*earth!")

    assert_call(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
        EXPECT_OUTPUT MATCHES "Hello" ".*earth!"
      EXPECT_ERROR STREQUAL "expected the output:\n"
        "  Hello world!\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E echo Hello world!\n"
        "to match:\n"
        "  Hello.*earth!")

    assert_call(
      CALL assert_execute_process
        COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
        EXPECT_OUTPUT STREQUAL "Hello earth!\n"
      EXPECT_ERROR STREQUAL "expected the output:\n"
        "  Hello world!\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E echo Hello world!\n"
        "to be equal to:\n"
        "  Hello earth!")
  endsection()
endsection()

section("assert process execution errors")
  file(TOUCH a_file)

  section("it should assert process execution errors")
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E make_directory a_file
      EXPECT_ERROR "Error creating directory" ".*a_file")

    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E make_directory a_file
      EXPECT_ERROR MATCHES "Error creating directory" ".*a_file")

    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E make_directory a_file
      EXPECT_ERROR STREQUAL "Error creating directory \"a_file\".")
  endsection()

  section("it should fail to assert process execution errors")
    macro(failed_assert)
      assert_execute_process("${CMAKE_COMMAND}" -E make_directory a_file
        EXPECT_ERROR "Error creating directory" ".*another_file")
    endmacro()

    assert_call(failed_assert
      EXPECT_ERROR STREQUAL "expected the error:\n"
        "  Error creating directory \"a_file\".\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E make_directory a_file\n"
        "to match:\n"
        "  Error creating directory.*another_file")

    macro(failed_assert)
      assert_execute_process("${CMAKE_COMMAND}" -E make_directory a_file
        EXPECT_ERROR MATCHES "Error creating directory" ".*another_file")
    endmacro()

    assert_call(failed_assert
      EXPECT_ERROR STREQUAL "expected the error:\n"
        "  Error creating directory \"a_file\".\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E make_directory a_file\n"
        "to match:\n"
        "  Error creating directory.*another_file")

    macro(failed_assert)
      assert_execute_process("${CMAKE_COMMAND}" -E make_directory a_file
        EXPECT_ERROR STREQUAL "Error creating directory \"another_file\".")
    endmacro()

    assert_call(failed_assert
      EXPECT_ERROR STREQUAL "expected the error:\n"
        "  Error creating directory \"a_file\".\n"
        "of command:\n"
        "  ${CMAKE_COMMAND} -E make_directory a_file\n"
        "to be equal to:\n"
        "  Error creating directory \"another_file\".")
  endsection()

  file(REMOVE a_file)
endsection()
