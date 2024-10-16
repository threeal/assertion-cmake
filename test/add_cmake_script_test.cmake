cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake
  RESULT_VARIABLE ASSERTION_LIST_FILE)

set(CMAKELISTS_HEADER
  "cmake_minimum_required(VERSION 3.24)\n"
  "project(Sample LANGUAGES NONE)\n"
  "include(${ASSERTION_LIST_FILE})\n"
  "enable_testing()\n")


file(REMOVE_RECURSE project)
file(WRITE project/test.cmake "message(\"all ok\")\n")

section("it should create a new test")
  file(WRITE project/CMakeLists.txt ${CMAKELISTS_HEADER}
    "add_cmake_script_test(test.cmake)\n")

  assert_execute_process("${CMAKE_COMMAND}" --fresh -S project -B project/build)
  assert_execute_process(
    ctest --test-dir project/build -R ^test.cmake$ --no-tests=error)
endsection()

section("it should create a new test "
  "with the file specified using an absolute path")
  file(WRITE project/CMakeLists.txt ${CMAKELISTS_HEADER}
    "add_cmake_script_test(\${CMAKE_CURRENT_SOURCE_DIR}/test.cmake)\n")

  assert_execute_process("${CMAKE_COMMAND}" --fresh -S project -B project/build)
  assert_execute_process(
    ctest --test-dir project/build -R project/test.cmake$ --no-tests=error)
endsection()

section("it should create a new test with the specified name")
  file(WRITE project/CMakeLists.txt ${CMAKELISTS_HEADER}
    "add_cmake_script_test(test.cmake NAME \"a test\")\n")

  assert_execute_process("${CMAKE_COMMAND}" --fresh -S project -B project/build)
  assert_execute_process(
    ctest --test-dir project/build -R "^a test$" --no-tests=error)
endsection()

file(WRITE project/test.cmake
  "include(\"\${ASSERTION_LIST_FILE}\")\n"
  "assert(FOO STREQUAL foo)\n")

section("it should create a new test with predefined variables")
  file(WRITE project/CMakeLists.txt ${CMAKELISTS_HEADER}
    "add_cmake_script_test(test.cmake\n"
    "  DEFINES ASSERTION_LIST_FILE=\${ASSERTION_LIST_FILE} FOO=foo)\n")

  assert_execute_process("${CMAKE_COMMAND}" --fresh -S project -B project/build)
  assert_execute_process(
    ctest --test-dir project/build -R --no-tests=error)
endsection()

file(REMOVE project/test.cmake)

section("it should fail to create a new test due to a non-existent file")
  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" --fresh -S project -B project/build
    EXPECT_ERROR "Cannot find test file:.*test.cmake")
endsection()

file(REMOVE_RECURSE project)
