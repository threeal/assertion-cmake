cmake_minimum_required(VERSION 3.5)

include(Assertion)

function("Boolean assertions")
  assert(TRUE)
  assert(NOT FALSE)

  mock_message()
    assert(FALSE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected 'FALSE' to resolve to true")

  mock_message()
    assert(NOT TRUE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected 'TRUE' to resolve to false")
endfunction()

function("Variable existence assertions")
  set(EXISTING_VARIABLE TRUE)
  unset(NON_EXSITING_VARIABLE)

  assert(DEFINED EXISTING_VARIABLE)
  assert(NOT DEFINED NON_EXSITING_VARIABLE)

  mock_message()
    assert(DEFINED NON_EXISTING_VARIABLE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected variable 'NON_EXISTING_VARIABLE' to be defined")

  mock_message()
    assert(NOT DEFINED EXISTING_VARIABLE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected variable 'EXISTING_VARIABLE' not to be defined")
endfunction()

function("Path existence assertions")
  file(TOUCH some_file)
  file(REMOVE_RECURSE non_existing_file)

  assert(EXISTS some_file)
  assert(NOT EXISTS non_existing_file)

  mock_message()
    assert(EXISTS non_existing_file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'non_existing_file' to exist")

  mock_message()
    assert(NOT EXISTS some_file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some_file' not to exist")
endfunction()

function("Assert a file path")
  file(TOUCH some-file)

  mock_message()
    assert_directory(some-file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-file' to be a directory")

  assert_not_directory(some-file)
endfunction()

function("Assert a directory path")
  file(MAKE_DIRECTORY some-directory)

  assert_directory(some-directory)

  mock_message()
    assert_not_directory(some-directory)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-directory' not to be a directory")
endfunction()

function("Assert a matching regular expression")
  assert_matches("some string" "so.*ing")

  mock_message()
    assert_not_matches("some string" "so.*ing")
  end_mock_message()
  assert_message(FATAL_ERROR "expected string 'some string' not to match 'so.*ing'")
endfunction()

function("Assert an unmatching regular expression")
  mock_message()
    assert_matches("some string" "so.*other.*ing")
  end_mock_message()
  assert_message(FATAL_ERROR "expected string 'some string' to match 'so.*other.*ing'")

  assert_not_matches("some string" "so.*other.*ing")
endfunction()

function("Assert equal strings")
  assert_strequal("some string" "some string")

  mock_message()
    assert_not_strequal("some string" "some string")
  end_mock_message()
  assert_message(FATAL_ERROR "expected string 'some string' not to be equal to 'some string'")
endfunction()

function("Assert unequal strings")
  assert_not_strequal("some string" "some other string")

  mock_message()
    assert_strequal("some string" "some other string")
  end_mock_message()
  assert_message(FATAL_ERROR "expected string 'some string' to be equal to 'some other string'")
endfunction()

function(call_sample_messages)
  message(WARNING "some warning message")
  message(WARNING "some other warning message")
  message(ERROR "some error message")
  message(FATAL_ERROR "some fatal error message")
  message(ERROR "some other error message")
endfunction()

function("Mock message")
  mock_message()
    call_sample_messages()
  end_mock_message()

  assert(DEFINED WARNING_MESSAGES)
  assert_strequal("${WARNING_MESSAGES}" "some warning message;some other warning message")

  assert(DEFINED ERROR_MESSAGES)
  assert_strequal("${ERROR_MESSAGES}" "some error message")

  assert(DEFINED FATAL_ERROR_MESSAGES)
  assert_strequal("${FATAL_ERROR_MESSAGES}" "some fatal error message")
endfunction()

function("Assert messages")
  mock_message()
    call_sample_messages()
  end_mock_message()

  assert_message(WARNING "some warning message")
  assert_message(WARNING "some other warning message")
  assert_message(ERROR "some error message")
  assert_message(FATAL_ERROR "some fatal error message")

  mock_message()
    assert_message(ERROR "some other error message")
  end_mock_message()
  assert_message(FATAL_ERROR "expected error message '' to be equal to 'some other error message'")
endfunction()

function("Assert successful process execution")
  assert_execute_process("${CMAKE_COMMAND}" -E true)

  mock_message()
    assert_not_execute_process("${CMAKE_COMMAND}" -E true)
  end_mock_message()
  assert_message(FATAL_ERROR "expected command '${CMAKE_COMMAND} -E true' to fail (exit code: 0)")
endfunction()

function("Assert failed process execution")
  mock_message()
    assert_execute_process("${CMAKE_COMMAND}" -E false)
  end_mock_message()
  assert_message(FATAL_ERROR "expected command '${CMAKE_COMMAND} -E false' not to fail (exit code: 1)")

  assert_not_execute_process("${CMAKE_COMMAND}" -E false)
endfunction()

function("Assert matching process execution output")
  assert_execute_process(
    "${CMAKE_COMMAND}" -E echo "Hello world!"
    EXPECTED_OUTPUT "Hello.*!"
  )

  assert_not_execute_process(
    "${CMAKE_COMMAND}" -E invalid
    EXPECTED_OUTPUT "CMake Error:.*Available commands:"
  )
endfunction()

function("Assert non-matching process execution output")
  mock_message()
    assert_execute_process(
      "${CMAKE_COMMAND}" -E echo "Hello world!"
      EXPECTED_OUTPUT "Hi.*!"
    )
  end_mock_message()
  assert_message(FATAL_ERROR "expected the output of command '${CMAKE_COMMAND} -E echo Hello world!' to match 'Hi.*!'")

  mock_message()
    assert_not_execute_process(
      "${CMAKE_COMMAND}" -E invalid
      EXPECTED_OUTPUT "CMake Error:.*Unavailable commands:"
    )
  end_mock_message()
  assert_message(FATAL_ERROR "expected the output of command '${CMAKE_COMMAND} -E invalid' to match 'CMake Error:.*Unavailable commands:'")
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
