function(add_cmake_test FILE)
  foreach(NAME ${ARGN})
    add_test(
      NAME "${NAME}"
      COMMAND "${CMAKE_COMMAND}"
        -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -D TEST_COMMAND=${NAME}
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  cmake/AssertionTest.cmake
  "Assert a true condition"
  "Assert a false condition"
  "Assert a defined variable"
  "Assert an undefined variable"
  "Assert a file path"
  "Assert a directory path"
  "Assert a non-existing path"
  "Assert a matching regular expression"
  "Assert an unmatching regular expression"
  "Assert equal strings"
  "Assert unequal strings"
  "Mock message"
  "Assert messages"
  "Assert successful process execution"
  "Assert failed process execution"
)
