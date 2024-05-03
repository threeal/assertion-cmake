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

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
