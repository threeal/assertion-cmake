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

add_test(
  NAME "internal assertion message formatting"
  COMMAND "${CMAKE_COMMAND}" -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/InternalFormatMessage.cmake)

add_test(
  NAME "internal message mocking"
  COMMAND "${CMAKE_COMMAND}" -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/InternalMockMessage.cmake)
