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

add_test(
  NAME "condition assertions"
  COMMAND "${CMAKE_COMMAND}" -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Assert.cmake)

add_test(
  NAME "fatal error assertions"
  COMMAND "${CMAKE_COMMAND}" -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/AssertFatalError.cmake)

add_test(
  NAME "execute process assertions"
  COMMAND "${CMAKE_COMMAND}" -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/AssertExecuteProcess.cmake)

add_cmake_test(
  cmake/InternalTest.cmake
  "Assertion message formatting"
  "Message function mocking"
)
