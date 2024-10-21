cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake
  RESULT_VARIABLE ASSERTION_LIST_FILE)

# Asserts whether the given code of a sample project can be configured
# successfully.
#
# assert_configure_sample_project(<code>...)
#
# This function asserts whether the given CMake `<code>` of a sample project can
# be configured successfully. If more than one `<code>` string is given, they
# are concatenated into a single block of code with no separator between the
# strings.
#
# It performs the assertion by first writing the given `<code>` to a
# `CMakeLists.txt` file under the `sample-project` directory, and then
# configuring the `sample-project` directory using the CMake command.
#
# If the configuration fails, it will output a formatted fatal error message
# with information about the context of the configuration command.
function(assert_configure_sample_project FIRST_CODE)
  cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "")

  file(MAKE_DIRECTORY sample-project)
  file(WRITE sample-project/CMakeLists.txt
    "cmake_minimum_required(VERSION 3.5)\n"
    "project(SomeProject)\n"
    "include(${ASSERTION_LIST_FILE})\n"
    "${FIRST_CODE}"
    ${ARG_UNPARSED_ARGUMENTS})

  assert_execute_process(
    "${CMAKE_COMMAND}" sample-project -B sample-project/build)
endfunction()

section("assert boolean conditions")
  section("it should assert conditions")
    assert(TRUE)
    assert(NOT FALSE)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert FALSE
      EXPECT_FATAL_ERROR STREQUAL "expected:\n  FALSE\nto resolve to true")

    assert_call(assert NOT TRUE
      EXPECT_FATAL_ERROR STREQUAL "expected:\n  NOT TRUE\nto resolve to true")
  endsection()
endsection()

section("assert command existence conditions")
  function(existing_command)
  endfunction()

  section("it should assert conditions")
    assert(COMMAND existing_command)
    assert(NOT COMMAND non_existing_command)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert COMMAND non_existing_command
      EXPECT_FATAL_ERROR STREQUAL
        "expected command:\n  non_existing_command\nto be defined")

    assert_call(assert NOT COMMAND existing_command
      EXPECT_FATAL_ERROR STREQUAL
        "expected command:\n  existing_command\nnot to be defined")
  endsection()
endsection()

section("assert policy existence conditions")
  section("it should assert conditions")
    assert(POLICY CMP0000)
    assert(NOT POLICY CPMXXXX)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert POLICY CMPXXXX
      EXPECT_FATAL_ERROR STREQUAL "expected policy:\n  CMPXXXX\nto exist")

    assert_call(assert NOT POLICY CMP0000
      EXPECT_FATAL_ERROR STREQUAL "expected policy:\n  CMP0000\nnot to exist")
  endsection()
endsection()

section("assert target existence conditions")
  file(MAKE_DIRECTORY project)

  section("it should assert conditions")
    assert_configure_sample_project(
      "add_custom_target(some_target)\n"
      "\n"
      "assert(TARGET some_target)\n"
      "assert(NOT TARGET non_existing_target)\n")
  endsection()

  section("it should fail to assert conditions")
    assert_configure_sample_project(
      "add_custom_target(some_target)\n"
      "\n"
      "assert_call(assert TARGET non_existing_target\n"
      "  EXPECT_FATAL_ERROR STREQUAL\n"
      "    \"expected target:\\n  non_existing_target\\nto exist\")\n"
      "\n"
      "assert_call(assert NOT TARGET some_target\n"
      "  EXPECT_FATAL_ERROR STREQUAL\n"
      "    \"expected target:\\n  some_target\\nnot to exist\")\n")
  endsection()
endsection()

section("assert test existence conditions")
  file(MAKE_DIRECTORY project)

  section("it should assert conditions")
    assert_configure_sample_project(
      "add_test(NAME some_test COMMAND some_command)\n"
      "\n"
      "assert(TEST some_test)\n"
      "assert(NOT TEST non_existing_test)\n")
  endsection()

  section("it should fail to assert conditions")
    assert_configure_sample_project(
      "add_test(NAME some_test COMMAND some_command)\n"
      "\n"
      "assert_call(assert TEST non_existing_test\n"
      "  EXPECT_FATAL_ERROR STREQUAL\n"
      "    \"expected test:\\n  non_existing_test\\nto exist\")\n"
      "\n"
      "assert_call(assert NOT TEST some_test\n"
      "  EXPECT_FATAL_ERROR STREQUAL\n"
      "    \"expected test:\\n  some_test\\nnot to exist\")\n")
  endsection()
endsection()

section("assert variable existence conditions")
  set(EXISTING_VARIABLE TRUE)
  unset(NON_EXISTING_VARIABLE)

  section("it should assert conditions")
    assert(DEFINED EXISTING_VARIABLE)
    assert(NOT DEFINED NON_EXISTING_VARIABLE)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert DEFINED NON_EXISTING_VARIABLE
      EXPECT_FATAL_ERROR STREQUAL
        "expected variable:\n  NON_EXISTING_VARIABLE\nto be defined")

    assert_call(assert NOT DEFINED EXISTING_VARIABLE
      EXPECT_FATAL_ERROR STREQUAL
        "expected variable:\n  EXISTING_VARIABLE\nnot to be defined")
  endsection()
endsection()

section("assert list element existence conditions")
  set(SOME_LIST "some element" "some other element")

  section("it should assert conditions")
    set(ELEMENT_VAR "some element")
    set(OTHER_ELEMENT_VAR "other element")

    assert("some element" IN_LIST SOME_LIST)
    assert(NOT "other element" IN_LIST SOME_LIST)

    assert(ELEMENT_VAR IN_LIST SOME_LIST)
    assert(NOT OTHER_ELEMENT_VAR IN_LIST SOME_LIST)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "other element" IN_LIST SOME_LIST
      EXPECT_FATAL_ERROR STREQUAL "expected string:\n  other element\n"
        "to exist in:\n  some element\;some other element\n"
        "of variable:\n  SOME_LIST")

    assert_call(assert NOT "some element" IN_LIST SOME_LIST
      EXPECT_FATAL_ERROR STREQUAL "expected string:\n  some element\n"
        "not to exist in:\n  some element\;some other element\n"
        "of variable:\n  SOME_LIST")
  endsection()
endsection()

section("assert path existence conditions")
  file(TOUCH some_file)
  file(REMOVE_RECURSE non_existing_file)

  section("it should assert conditions")
    assert(EXISTS some_file)
    assert(NOT EXISTS non_existing_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert EXISTS non_existing_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  non_existing_file\nto exist")

    assert_call(assert NOT EXISTS some_file
      EXPECT_FATAL_ERROR STREQUAL "expected path:\n  some_file\nnot to exist")
  endsection()
endsection()

section("assert path readability conditions")
  file(TOUCH some_file)

  file(REMOVE non_readable_file)
  file(TOUCH non_readable_file)
  file(CHMOD non_readable_file PERMISSIONS OWNER_WRITE)

  section("it should assert conditions")
    assert(IS_READABLE some_file)
    assert(NOT IS_READABLE non_readable_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_READABLE non_readable_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  non_readable_file\nto be readable")

    assert_call(assert NOT IS_READABLE some_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_file\nnot to be readable")
  endsection()
endsection()

section("assert path writability conditions")
  file(TOUCH some_file)

  file(TOUCH non_writable_file)
  file(CHMOD non_writable_file PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)

  section("it should assert conditions")
    assert(IS_WRITABLE some_file)
    assert(NOT IS_WRITABLE non_writable_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_WRITABLE non_writable_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  non_writable_file\nto be writable")

    assert_call(assert NOT IS_WRITABLE some_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_file\nnot to be writable")
  endsection()
endsection()

section("assert executable path conditions")
  file(TOUCH some_executable)
  file(
    CHMOD some_executable
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
      GROUP_READ GROUP_EXECUTE
      WORLD_READ WORLD_EXECUTE)

  file(TOUCH some_file)

  section("it should assert conditions")
    assert(IS_EXECUTABLE some_executable)
    assert(NOT IS_EXECUTABLE some_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_EXECUTABLE some_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_file\nto be an executable")

    assert_call(assert NOT IS_EXECUTABLE some_executable
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_executable\nnot to be an executable")
  endsection()
endsection()

section("assert file recency conditions")
  if(NOT EXISTS old_file)
    file(WRITE old_file "something")
    execute_process(COMMAND "${CMAKE_COMMAND}" -E sleep 1)
  endif()

  file(WRITE new_file "something")

  section("it should assert conditions")
    assert(new_file IS_NEWER_THAN old_file)
    assert(NOT old_file IS_NEWER_THAN new_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert old_file IS_NEWER_THAN new_file
      EXPECT_FATAL_ERROR STREQUAL "expected file:\n  old_file\n"
        "to be newer than:\n  new_file")

    assert_call(assert NOT new_file IS_NEWER_THAN old_file
      EXPECT_FATAL_ERROR STREQUAL "expected file:\n  new_file\n"
        "not to be newer than:\n  old_file")
  endsection()
endsection()

section("assert directory path conditions")
  file(MAKE_DIRECTORY some_directory)
  file(TOUCH some_file)

  section("it should assert conditions")
    assert(IS_DIRECTORY some_directory)
    assert(NOT IS_DIRECTORY some_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_DIRECTORY some_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_file\nto be a directory")

    assert_call(assert NOT IS_DIRECTORY some_directory
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_directory\nnot to be a directory")
  endsection()
endsection()

section("assert symbolic link path conditions")
  file(TOUCH some_file)
  file(CREATE_LINK some_file some_symlink SYMBOLIC)

  section("it should assert conditions")
    assert(IS_SYMLINK some_symlink)
    assert(NOT IS_SYMLINK some_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_SYMLINK some_file
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_file\nto be a symbolic link")

    assert_call(assert NOT IS_SYMLINK some_symlink
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some_symlink\nnot to be a symbolic link")
  endsection()
endsection()

section("assert absolute path conditions")
  section("it should assert conditions")
    assert(IS_ABSOLUTE /some/absolute/path)
    assert(NOT IS_ABSOLUTE some/relative/path)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_ABSOLUTE some/relative/path
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  some/relative/path\nto be absolute")

    assert_call(assert NOT IS_ABSOLUTE /some/absolute/path
      EXPECT_FATAL_ERROR STREQUAL
        "expected path:\n  /some/absolute/path\nnot to be absolute")
  endsection()
endsection()

section("assert regular expression match conditions")
  section("it should assert conditions")
    set(STRING_VAR "some string")

    assert("some string" MATCHES "so.*ing")
    assert(NOT "some string" MATCHES "so.*other.*ing")

    assert(STRING_VAR MATCHES "so.*ing")
    assert(NOT STRING_VAR MATCHES "so.*other.*ing")
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "some string" MATCHES "so.*other.*ing"
      EXPECT_FATAL_ERROR STREQUAL "expected string:\n  some string\n"
        "to match:\n  so.*other.*ing")

    assert_call(assert NOT "some string" MATCHES "so.*ing"
      EXPECT_FATAL_ERROR STREQUAL "expected string:\n  some string\n"
        "not to match:\n  so.*ing")
  endsection()
endsection()

section("assert path equality conditions")
  section("it should assert conditions")
    set(PATH_VAR "/some/path")
    set(PATHH_VAR "/some//path")
    set(OTHER_PATH_VAR "/some/other/path")

    assert("/some/path" PATH_EQUAL "/some//path")
    assert(NOT "/some/path" PATH_EQUAL "/some/other/path")

    assert(PATH_VAR PATH_EQUAL PATHH_VAR)
    assert(NOT PATH_VAR PATH_EQUAL OTHER_PATH_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "/some/path" PATH_EQUAL "/some/other/path"
      EXPECT_FATAL_ERROR STREQUAL "expected path:\n  /some/path\n"
        "to be equal to:\n  /some/other/path")

    assert_call(assert NOT "/some/path" PATH_EQUAL "/some//path"
      EXPECT_FATAL_ERROR STREQUAL "expected path:\n  /some/path\n"
        "not to be equal to:\n  /some//path")
  endsection()
endsection()
