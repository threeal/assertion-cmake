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
  "Boolean assertions"
  "Variable existence assertions"
  "Path existence assertions"
  "Directory path assertions"
  "Assert a matching regular expression"
  "Assert an unmatching regular expression"
  "Assert equal strings"
  "Assert unequal strings"
  "Mock message"
  "Assert messages"
  "Assert successful process execution"
  "Assert failed process execution"
  "Assert matching process execution output"
  "Assert non-matching process execution output"
)
