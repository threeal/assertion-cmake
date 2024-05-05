cmake_minimum_required(VERSION 3.5)

include(Assertion)

function(test_assert_a_true_condition)
  assert_true(TRUE)

  mock_message()
    assert_false(TRUE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected the condition to be false")
endfunction()

function(test_assert_a_false_condition)
  assert_false(FALSE)

  mock_message()
    assert_true(FALSE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected the condition to be true")
endfunction()

function(test_assert_a_defined_variable)
  set(SOME_VARIABLE "some value")
  assert_defined(SOME_VARIABLE)

  mock_message()
    assert_not_defined(SOME_VARIABLE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected variable 'SOME_VARIABLE' not to be defined")
endfunction()

function(test_assert_an_undefined_variable)
  assert_not_defined(SOME_VARIABLE)

  mock_message()
    assert_defined(SOME_VARIABLE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected variable 'SOME_VARIABLE' to be defined")
endfunction()

function(test_assert_a_file_path)
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

function(test_assert_a_directory_path)
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

function(test_assert_a_non_existing_path)
  file(REMOVE some-non-existing-file)
  assert_not_exists(some-non-existing-file)

  mock_message()
    assert_exists(some-non-existing-file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some-non-existing-file' to exist")
endfunction()

function(test_assert_equal_strings)
  assert_strequal("some string" "some string")

  mock_message()
    assert_not_strequal("some string" "some string")
  end_mock_message()
  assert_message(FATAL_ERROR "expected string 'some string' not to be equal to 'some string'")
endfunction()

function(test_assert_unequal_strings)
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

function(test_mock_message)
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

function(test_assert_messages)
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

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
