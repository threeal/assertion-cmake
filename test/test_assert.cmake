cmake_minimum_required(VERSION 3.24)

include(Assertion RESULT_VARIABLE ASSERTION_LIST_FILE)

file(MAKE_DIRECTORY sample-project)

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

  file(WRITE sample-project/CMakeLists.txt
    "cmake_minimum_required(VERSION 3.5)\n"
    "project(a-project)\n"
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
      EXPECT_ERROR STREQUAL "expected:\n  FALSE\nto resolve to true")

    assert_call(assert NOT TRUE
      EXPECT_ERROR STREQUAL "expected:\n  NOT TRUE\nto resolve to true")
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
      EXPECT_ERROR STREQUAL
        "expected command:\n  non_existing_command\nto be defined")

    assert_call(assert NOT COMMAND existing_command
      EXPECT_ERROR STREQUAL
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
      EXPECT_ERROR STREQUAL "expected policy:\n  CMPXXXX\nto exist")

    assert_call(assert NOT POLICY CMP0000
      EXPECT_ERROR STREQUAL "expected policy:\n  CMP0000\nnot to exist")
  endsection()
endsection()

section("assert target existence conditions")
  section("it should assert conditions")
    assert_configure_sample_project(
      "add_custom_target(a_target)\n"
      "\n"
      "assert(TARGET a_target)\n"
      "assert(NOT TARGET non_existing_target)\n")
  endsection()

  section("it should fail to assert conditions")
    assert_configure_sample_project(
      "add_custom_target(a_target)\n"
      "\n"
      "assert_call(assert TARGET non_existing_target\n"
      "  EXPECT_ERROR STREQUAL\n"
      "    \"expected target:\\n  non_existing_target\\nto exist\")\n"
      "\n"
      "assert_call(assert NOT TARGET a_target\n"
      "  EXPECT_ERROR STREQUAL\n"
      "    \"expected target:\\n  a_target\\nnot to exist\")\n")
  endsection()
endsection()

section("assert test existence conditions")
  section("it should assert conditions")
    assert_configure_sample_project(
      "add_test(NAME a_test COMMAND cmd)\n"
      "\n"
      "assert(TEST a_test)\n"
      "assert(NOT TEST non_existing_test)\n")
  endsection()

  section("it should fail to assert conditions")
    assert_configure_sample_project(
      "add_test(NAME a_test COMMAND cmd)\n"
      "\n"
      "assert_call(assert TEST non_existing_test\n"
      "  EXPECT_ERROR STREQUAL\n"
      "    \"expected test:\\n  non_existing_test\\nto exist\")\n"
      "\n"
      "assert_call(assert NOT TEST a_test\n"
      "  EXPECT_ERROR STREQUAL\n"
      "    \"expected test:\\n  a_test\\nnot to exist\")\n")
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
      EXPECT_ERROR STREQUAL
        "expected variable:\n  NON_EXISTING_VARIABLE\nto be defined")

    assert_call(assert NOT DEFINED EXISTING_VARIABLE
      EXPECT_ERROR STREQUAL
        "expected variable:\n  EXISTING_VARIABLE\nnot to be defined")
  endsection()
endsection()

section("assert list element existence conditions")
  set(LIST_VAR "an element" "another element")

  section("it should assert conditions")
    set(ELEMENT_VAR "an element")
    set(OTHER_ELEMENT_VAR "a non-existent element")

    assert("an element" IN_LIST LIST_VAR)
    assert(NOT "a non-existent element" IN_LIST LIST_VAR)

    assert(ELEMENT_VAR IN_LIST LIST_VAR)
    assert(NOT OTHER_ELEMENT_VAR IN_LIST LIST_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "a non-existent element" IN_LIST LIST_VAR
      EXPECT_ERROR STREQUAL "expected string:\n  a non-existent element\n"
        "to exist in:\n  an element\;another element\n"
        "of variable:\n  LIST_VAR")

    assert_call(assert NOT "an element" IN_LIST LIST_VAR
      EXPECT_ERROR STREQUAL "expected string:\n  an element\n"
        "not to exist in:\n  an element\;another element\n"
        "of variable:\n  LIST_VAR")
  endsection()
endsection()

section("assert path existence conditions")
  file(TOUCH a_file)
  file(REMOVE_RECURSE non_existing_file)

  section("it should assert conditions")
    assert(EXISTS a_file)
    assert(NOT EXISTS non_existing_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert EXISTS non_existing_file
      EXPECT_ERROR STREQUAL "expected path:\n  non_existing_file\nto exist")

    assert_call(assert NOT EXISTS a_file
      EXPECT_ERROR STREQUAL "expected path:\n  a_file\nnot to exist")
  endsection()

  file(REMOVE a_file)
endsection()

section("assert path readability conditions")
  file(REMOVE a_non_readable_file)
  file(TOUCH a_file a_non_readable_file)
  file(CHMOD a_non_readable_file PERMISSIONS OWNER_WRITE)

  section("it should assert conditions")
    assert(IS_READABLE a_file)
    assert(NOT IS_READABLE a_non_readable_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_READABLE a_non_readable_file
      EXPECT_ERROR STREQUAL
        "expected path:\n  a_non_readable_file\nto be readable")

    assert_call(assert NOT IS_READABLE a_file
      EXPECT_ERROR STREQUAL "expected path:\n  a_file\nnot to be readable")
  endsection()

  file(REMOVE a_file a_non_readable_file)
endsection()

section("assert path writability conditions")
  file(TOUCH a_file a_non_writable_file)
  file(CHMOD a_non_writable_file PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)

  section("it should assert conditions")
    assert(IS_WRITABLE a_file)
    assert(NOT IS_WRITABLE a_non_writable_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_WRITABLE a_non_writable_file
      EXPECT_ERROR STREQUAL
        "expected path:\n  a_non_writable_file\nto be writable")

    assert_call(assert NOT IS_WRITABLE a_file
      EXPECT_ERROR STREQUAL "expected path:\n  a_file\nnot to be writable")
  endsection()

  file(REMOVE a_file a_non_writable_file)
endsection()

section("assert executable path conditions")
  file(TOUCH a_file an_executable)
  file(CHMOD an_executable PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

  section("it should assert conditions")
    assert(IS_EXECUTABLE an_executable)
    assert(NOT IS_EXECUTABLE a_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_EXECUTABLE a_file
      EXPECT_ERROR STREQUAL "expected path:\n  a_file\nto be an executable")

    assert_call(assert NOT IS_EXECUTABLE an_executable
      EXPECT_ERROR STREQUAL
        "expected path:\n  an_executable\nnot to be an executable")
  endsection()

  file(REMOVE a_file an_executable)
endsection()

section("assert file recency conditions")
  file(TOUCH an_old_file)
  execute_process(COMMAND "${CMAKE_COMMAND}" -E sleep 1)
  file(TOUCH a_new_file)

  section("it should assert conditions")
    assert(a_new_file IS_NEWER_THAN an_old_file)
    assert(NOT an_old_file IS_NEWER_THAN a_new_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert an_old_file IS_NEWER_THAN a_new_file
      EXPECT_ERROR STREQUAL "expected file:\n  an_old_file\n"
        "to be newer than:\n  a_new_file")

    assert_call(assert NOT a_new_file IS_NEWER_THAN an_old_file
      EXPECT_ERROR STREQUAL "expected file:\n  a_new_file\n"
        "not to be newer than:\n  an_old_file")
  endsection()

  file(REMOVE an_old_file a_new_file)
endsection()

section("assert directory path conditions")
  file(MAKE_DIRECTORY a_directory)
  file(TOUCH a_file)

  section("it should assert conditions")
    assert(IS_DIRECTORY a_directory)
    assert(NOT IS_DIRECTORY a_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_DIRECTORY a_file
      EXPECT_ERROR STREQUAL "expected path:\n  a_file\nto be a directory")

    assert_call(assert NOT IS_DIRECTORY a_directory
      EXPECT_ERROR STREQUAL
        "expected path:\n  a_directory\nnot to be a directory")
  endsection()

  file(REMOVE_RECURSE a_directory a_file)
endsection()

section("assert symbolic link path conditions")
  file(TOUCH a_file)
  file(CREATE_LINK a_file a_symlink SYMBOLIC)

  section("it should assert conditions")
    assert(IS_SYMLINK a_symlink)
    assert(NOT IS_SYMLINK a_file)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_SYMLINK a_file
      EXPECT_ERROR STREQUAL
        "expected path:\n  a_file\nto be a symbolic link")

    assert_call(assert NOT IS_SYMLINK a_symlink
      EXPECT_ERROR STREQUAL
        "expected path:\n  a_symlink\nnot to be a symbolic link")
  endsection()

  file(REMOVE a_file a_symlink)
endsection()

section("assert absolute path conditions")
  section("it should assert conditions")
    assert(IS_ABSOLUTE /an/absolute/path)
    assert(NOT IS_ABSOLUTE a/relative/path)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert IS_ABSOLUTE a/relative/path
      EXPECT_ERROR STREQUAL
        "expected path:\n  a/relative/path\nto be absolute")

    assert_call(assert NOT IS_ABSOLUTE /an/absolute/path
      EXPECT_ERROR STREQUAL
        "expected path:\n  /an/absolute/path\nnot to be absolute")
  endsection()
endsection()

section("assert regular expression match conditions")
  section("it should assert conditions")
    set(STRING_VAR "a string")

    assert("a string" MATCHES ". string")
    assert(NOT "a string" MATCHES ".nother string")

    assert(STRING_VAR MATCHES ". string")
    assert(NOT STRING_VAR MATCHES ".nother string")
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "a string" MATCHES ".nother string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "to match:\n  .nother string")

    assert_call(assert NOT "a string" MATCHES ". string"
      EXPECT_ERROR STREQUAL "expected string:\n  a string\n"
        "not to match:\n  . string")
  endsection()
endsection()

section("assert path equality conditions")
  section("it should assert conditions")
    set(PATH_VAR "/a/path")
    set(PATHH_VAR "/a//path")
    set(OTHER_PATH_VAR "/another/path")

    assert("/a/path" PATH_EQUAL "/a//path")
    assert(NOT "/a/path" PATH_EQUAL "/another/path")

    assert(PATH_VAR PATH_EQUAL PATHH_VAR)
    assert(NOT PATH_VAR PATH_EQUAL OTHER_PATH_VAR)
  endsection()

  section("it should fail to assert conditions")
    assert_call(assert "/a/path" PATH_EQUAL "/another/path"
      EXPECT_ERROR STREQUAL "expected path:\n  /a/path\n"
        "to be equal to:\n  /another/path")

    assert_call(assert NOT "/a/path" PATH_EQUAL "/a//path"
      EXPECT_ERROR STREQUAL "expected path:\n  /a/path\n"
        "not to be equal to:\n  /a//path")
  endsection()
endsection()

file(REMOVE_RECURSE sample-project)
