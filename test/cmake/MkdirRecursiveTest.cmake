function(test_create_directory_recursively)
  if(EXISTS parent)
    message(STATUS "Removing test directory")
    file(REMOVE_RECURSE parent)
  endif()

  include(MkdirRecursive)

  message(STATUS "Creating test directory recursively")
  mkdir_recursive(parent/child)

  if(NOT EXISTS parent/child)
    message(FATAL_ERROR "Directory `parent/child` should exist!")
  endif()

  message(STATUS "Removing test directory")
  file(REMOVE_RECURSE parent)
endfunction()

# Add more test cases here.
function(test_something)
  # Do something.
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
