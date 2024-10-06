include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake
  RESULT_VARIABLE ASSERTION_LIST_FILE)

file(REMOVE_RECURSE project)
file(WRITE project/test.cmake "message(\"all ok\")\n")

section("it should create a new test")
  file(WRITE project/CMakeLists.txt
    "cmake_minimum_required(VERSION 3.21)\n"
    "project(Sample LANGUAGES NONE)\n"
    "\n"
    "include(${ASSERTION_LIST_FILE})\n"
    "\n"
    "enable_testing()\n"
    "add_cmake_script_test(test.cmake)\n")

  assert_execute_process("${CMAKE_COMMAND}" --fresh -S project -B project/build)
  assert_execute_process(
    ctest --test-dir project/build -R ^test.cmake$ --no-tests=error)
endsection()

section("it should create a new test "
  "with the file specified using an absolute path")
  file(WRITE project/CMakeLists.txt
    "cmake_minimum_required(VERSION 3.21)\n"
    "project(Sample LANGUAGES NONE)\n"
    "\n"
    "include(${ASSERTION_LIST_FILE})\n"
    "\n"
    "enable_testing()\n"
    "add_cmake_script_test(\${CMAKE_CURRENT_SOURCE_DIR}/test.cmake)\n")

  assert_execute_process("${CMAKE_COMMAND}" --fresh -S project -B project/build)
  assert_execute_process(
    ctest --test-dir project/build -R project/test.cmake$ --no-tests=error)
endsection()

section("it should create a new test with the specified name")
  file(WRITE project/CMakeLists.txt
    "cmake_minimum_required(VERSION 3.21)\n"
    "project(Sample LANGUAGES NONE)\n"
    "\n"
    "include(${ASSERTION_LIST_FILE})\n"
    "\n"
    "enable_testing()\n"
    "add_cmake_script_test(test.cmake NAME \"a test\")\n")

  assert_execute_process("${CMAKE_COMMAND}" --fresh -S project -B project/build)
  assert_execute_process(
    ctest --test-dir project/build -R "^a test$" --no-tests=error)
endsection()

section("it should fail to create a new test due to a non-existing file")
  file(WRITE project/CMakeLists.txt
    "cmake_minimum_required(VERSION 3.21)\n"
    "project(Sample LANGUAGES NONE)\n"
    "\n"
    "include(${ASSERTION_LIST_FILE})\n"
    "\n"
    "enable_testing()\n"
    "add_cmake_script_test(invalid.cmake)\n")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" --fresh -S project -B project/build
    ERROR "Cannot find test file:.*invalid.cmake")
endsection()

file(REMOVE_RECURSE project)
