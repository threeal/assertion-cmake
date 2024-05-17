cmake_minimum_required(VERSION 3.5)

include(Assertion)

function("Assert a true condition")
  assert_true(TRUE)

  mock_message()
    assert_false(TRUE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected the condition to be false")
endfunction()

function("Assert a false condition")
  assert_false(FALSE)

  mock_message()
    assert_true(FALSE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected the condition to be true")
endfunction()

function("Assert a defined variable")
  set(SOME_VARIABLE "some value")
  assert_defined(SOME_VARIABLE)

  mock_message()
    assert_not_defined(SOME_VARIABLE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected variable 'SOME_VARIABLE' not to be defined")
endfunction()

function("Assert an undefined variable")
  assert_not_defined(SOME_VARIABLE)

  mock_message()
    assert_defined(SOME_VARIABLE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected variable 'SOME_VARIABLE' to be defined")
endfunction()

function("Assert a file path")
  file(TOUCH some-file)

  assert_exists(some-file)

  mock_message()
    assert_not_exists(some-file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-file' not to exist")

  mock_message()
    assert_directory(some-file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-file' to be a directory")

  assert_not_directory(some-file)
endfunction()

function("Assert a directory path")
  file(MAKE_DIRECTORY some-directory)

  assert_exists(some-directory)

  mock_message()
    assert_not_exists(some-directory)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-directory' not to exist")

  assert_directory(some-directory)

  mock_message()
    assert_not_directory(some-directory)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-directory' not to be a directory")
endfunction()

function("Assert a non-existing path")
  file(REMOVE some-non-existing-file)
  assert_not_exists(some-non-existing-file)

  mock_message()
    assert_exists(some-non-existing-file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-non-existing-file' to exist")
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

  assert_defined(WARNING_MESSAGES)
  assert_strequal("${WARNING_MESSAGES}" "some warning message;some other warning message")

  assert_defined(ERROR_MESSAGES)
  assert_strequal("${ERROR_MESSAGES}" "some error message")

  assert_defined(FATAL_ERROR_MESSAGES)
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

cmake_language(CALL "${TEST_COMMAND}")
