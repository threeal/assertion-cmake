function(add_cmake_test FILE)
  math(EXPR STOP "${ARGC} - 1")
  foreach(I RANGE 1 "${STOP}")
    add_test(
      NAME "${ARGV${I}}"
      COMMAND "${CMAKE_COMMAND}"
        -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -D "TEST_COMMAND=${ARGV${I}}"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  cmake/InternalTest.cmake
  "Variable content retrieval"
  "Assertion message formatting"
)

add_cmake_test(
  cmake/AssertionTest.cmake
  "Boolean assertions"
  "Variable existence assertions"
  "Path existence assertions"
  "Directory path assertions"
  "Regular expression match assertions"
  "String equality assertions"
  "Message assertions"
  "Process execution assertions"
  "Mock message"
)
