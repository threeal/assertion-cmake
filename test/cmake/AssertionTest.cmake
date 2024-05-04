cmake_minimum_required(VERSION 3.5)

include(Assertion)

function(test_assert_a_true_condition)
  assert_true(TRUE)
endfunction()

function(test_assert_a_false_condition)
  assert_false(FALSE)
endfunction()

function(test_assert_a_defined_variable)
  set(SOME_VARIABLE "some value")
  assert_defined(SOME_VARIABLE)
endfunction()

function(test_assert_an_undefined_variable)
  assert_not_defined(SOME_VARIABLE)
endfunction()

function(test_assert_equal_strings)
  assert_strequal("some string" "some string")
endfunction()

function(test_assert_unequal_strings)
  assert_not_strequal("some string" "some other string")
endfunction()

function(test_mock_message)
  mock_message(ON)

  function(test)
    message(WARNING "some warning message")
    message(WARNING "some other warning message")
    message(ERROR "some error message")
    message(FATAL_ERROR "some fatal error message")
    message(ERROR "some other error message")
  endfunction()
  test()

  mock_message(OFF)

  assert_defined(WARNING_MESSAGES)
  assert_strequal("${WARNING_MESSAGES}" "some warning message;some other warning message")

  assert_defined(ERROR_MESSAGES)
  assert_strequal("${ERROR_MESSAGES}" "some error message")

  assert_defined(FATAL_ERROR_MESSAGES)
  assert_strequal("${FATAL_ERROR_MESSAGES}" "some fatal error message")
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
