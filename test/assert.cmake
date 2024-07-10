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

section("boolean condition assertions")
  section("it should assert boolean conditions")
    assert(TRUE)
    assert(NOT FALSE)
  endsection()

  section("it should fail to assert boolean conditions")
    assert_fatal_error(
      CALL assert FALSE
      MESSAGE "expected:\n  FALSE\nto resolve to true")

    assert_fatal_error(
      CALL assert NOT TRUE
      MESSAGE "expected:\n  NOT TRUE\nto resolve to true")
  endsection()
endsection()

section("command existence condition assertions")
  function(existing_command)
  endfunction()

  section("it should assert command existence conditions")
    assert(COMMAND existing_command)
    assert(NOT COMMAND non_existing_command)
  endsection()

  section("it should fail to assert command existence conditions")
    assert_fatal_error(
      CALL assert COMMAND non_existing_command
      MESSAGE "expected command:\n  non_existing_command\nto be defined")

    assert_fatal_error(
      CALL assert NOT COMMAND existing_command
      MESSAGE "expected command:\n  existing_command\nnot to be defined")
  endsection()
endsection()

section("policy existence condition assertions")
  section("it should assert policy existence conditions")
    assert(POLICY CMP0000)
    assert(NOT POLICY CPMXXXX)
  endsection()

  section("it should fail to assert policy existence conditions")
    assert_fatal_error(
      CALL assert POLICY CMPXXXX
      MESSAGE "expected policy:\n  CMPXXXX\nto exist")

    assert_fatal_error(
      CALL assert NOT POLICY CMP0000
      MESSAGE "expected policy:\n  CMP0000\nnot to exist")
  endsection()
endsection()

section("target existence condition assertions")
  file(MAKE_DIRECTORY project)

  section("it should assert target existence conditions")
    assert_configure_sample_project(
      "add_custom_target(some_target)\n"
      "\n"
      "assert(TARGET some_target)\n"
      "assert(NOT TARGET non_existing_target)\n")
  endsection()

  section("it should fail to assert target existence conditions")
    assert_configure_sample_project(
      "add_custom_target(some_target)\n"
      "\n"
      "assert_fatal_error(\n"
      "  CALL assert TARGET non_existing_target\n"
      "  MESSAGE \"expected target:\\n  non_existing_target\\nto exist\")\n"
      "\n"
      "assert_fatal_error(\n"
      "  CALL assert NOT TARGET some_target\n"
      "  MESSAGE \"expected target:\\n  some_target\\nnot to exist\")\n")
  endsection()
endsection()

section("test existence condition assertions")
  file(MAKE_DIRECTORY project)

  section("it should assert test existence conditions")
    assert_configure_sample_project(
      "add_test(NAME some_test COMMAND some_command)\n"
      "\n"
      "assert(TEST some_test)\n"
      "assert(NOT TEST non_existing_test)\n")
  endsection()

  section("it should fail to assert test existence conditions")
    assert_configure_sample_project(
      "add_test(NAME some_test COMMAND some_command)\n"
      "\n"
      "assert_fatal_error(\n"
      "  CALL assert TEST non_existing_test\n"
      "  MESSAGE \"expected test:\\n  non_existing_test\\nto exist\")\n"
      "\n"
      "assert_fatal_error(\n"
      "  CALL assert NOT TEST some_test\n"
      "  MESSAGE \"expected test:\\n  some_test\\nnot to exist\")\n")
  endsection()
endsection()

section("variable existence condition assertions")
  set(EXISTING_VARIABLE TRUE)
  unset(NON_EXISTING_VARIABLE)

  section("it should assert variable existence conditions")
    assert(DEFINED EXISTING_VARIABLE)
    assert(NOT DEFINED NON_EXISTING_VARIABLE)
  endsection()

  section("it should fail to assert variable existence conditions")
    assert_fatal_error(
      CALL assert DEFINED NON_EXISTING_VARIABLE
      MESSAGE "expected variable:\n  NON_EXISTING_VARIABLE\nto be defined")

    assert_fatal_error(
      CALL assert NOT DEFINED EXISTING_VARIABLE
      MESSAGE "expected variable:\n  EXISTING_VARIABLE\nnot to be defined")
  endsection()
endsection()

section("list element existence condition assertions")
  set(SOME_LIST "some element" "some other element")

  section("given a string")
    section("it should assert list element existence conditions")
      assert("some element" IN_LIST SOME_LIST)
      assert(NOT "other element" IN_LIST SOME_LIST)
    endsection()

    section("it should fail to assert list element existence conditions")
      assert_fatal_error(
        CALL assert NOT "some element" IN_LIST SOME_LIST
        MESSAGE "expected string:\n  some element\n"
          "not to exist in:\n  some element;some other element\n"
          "of variable:\n  SOME_LIST")

      assert_fatal_error(
        CALL assert "other element" IN_LIST SOME_LIST
        MESSAGE "expected string:\n  other element\n"
          "to exist in:\n  some element;some other element\n"
          "of variable:\n  SOME_LIST")
    endsection()
  endsection()

  section("given a variable")
    set(ELEMENT_VAR "some element")
    set(OTHER_ELEMENT_VAR "other element")

    section("it should assert list element existence conditions")
      assert(ELEMENT_VAR IN_LIST SOME_LIST)
      assert(NOT OTHER_ELEMENT_VAR IN_LIST SOME_LIST)
    endsection()

    section("it should fail to assert list element existence conditions")
      assert_fatal_error(
        CALL assert NOT ELEMENT_VAR IN_LIST SOME_LIST
        MESSAGE "expected string:\n  some element\n"
          "of variable:\n  ELEMENT_VAR\n"
          "not to exist in:\n  some element;some other element\n"
          "of variable:\n  SOME_LIST")

      assert_fatal_error(
        CALL assert OTHER_ELEMENT_VAR IN_LIST SOME_LIST
        MESSAGE "expected string:\n  other element\n"
          "of variable:\n  OTHER_ELEMENT_VAR\n"
          "to exist in:\n  some element;some other element\n"
          "of variable:\n  SOME_LIST")
    endsection()
  endsection()
endsection()

section("path existence condition assertions")
  file(TOUCH some_file)
  file(REMOVE_RECURSE non_existing_file)

  section("it should assert path existence conditions")
    assert(EXISTS some_file)
    assert(NOT EXISTS non_existing_file)
  endsection()

  section("it should fail to assert path existence conditions")
    assert_fatal_error(
      CALL assert EXISTS non_existing_file
      MESSAGE "expected path:\n  non_existing_file\nto exist")

    assert_fatal_error(
      CALL assert NOT EXISTS some_file
      MESSAGE "expected path:\n  some_file\nnot to exist")
  endsection()
endsection()

section("path readability condition assertions")
  file(TOUCH some_file)

  file(REMOVE non_readable_file)
  file(TOUCH non_readable_file)
  file(CHMOD non_readable_file PERMISSIONS OWNER_WRITE)

  section("it should assert path readability conditions")
    assert(IS_READABLE some_file)
    assert(NOT IS_READABLE non_readable_file)
  endsection()

  section("it should fail to assert path readability conditions")
    assert_fatal_error(
      CALL assert IS_READABLE non_readable_file
      MESSAGE "expected path:\n  non_readable_file\nto be readable")

    assert_fatal_error(
      CALL assert NOT IS_READABLE some_file
      MESSAGE "expected path:\n  some_file\nnot to be readable")
  endsection()
endsection()

section("path writability condition assertions")
  file(TOUCH some_file)

  file(TOUCH non_writable_file)
  file(CHMOD non_writable_file PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)

  section("it should assert path writability conditions")
    assert(IS_WRITABLE some_file)
    assert(NOT IS_WRITABLE non_writable_file)
  endsection()

  section("it should fail to assert path writability conditions")
    assert_fatal_error(
      CALL assert IS_WRITABLE non_writable_file
      MESSAGE "expected path:\n  non_writable_file\nto be writable")

    assert_fatal_error(
      CALL assert NOT IS_WRITABLE some_file
      MESSAGE "expected path:\n  some_file\nnot to be writable")
  endsection()
endsection()

section("executable path condition assertions")
  file(TOUCH some_executable)
  file(
    CHMOD some_executable
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
      GROUP_READ GROUP_EXECUTE
      WORLD_READ WORLD_EXECUTE)

  file(TOUCH some_file)

  section("it should assert executable path conditions")
    assert(IS_EXECUTABLE some_executable)
    assert(NOT IS_EXECUTABLE some_file)
  endsection()

  section("it should fail to assert executable path conditions")
    assert_fatal_error(
      CALL assert IS_EXECUTABLE some_file
      MESSAGE "expected path:\n  some_file\nto be an executable")

    assert_fatal_error(
      CALL assert NOT IS_EXECUTABLE some_executable
      MESSAGE "expected path:\n  some_executable\nnot to be an executable")
  endsection()
endsection()

section("file recency condition assertions")
  if(NOT EXISTS old_file)
    file(WRITE old_file "something")
    execute_process(COMMAND "${CMAKE_COMMAND}" -E sleep 1)
  endif()

  file(WRITE new_file "something")

  section("it should assert file recency conditions")
    assert(new_file IS_NEWER_THAN old_file)
    assert(NOT old_file IS_NEWER_THAN new_file)
  endsection()

  section("it should fail to assert file recency conditions")
    assert_fatal_error(
      CALL assert old_file IS_NEWER_THAN new_file
      MESSAGE "expected file:\n  old_file\nto be newer than:\n  new_file")

    assert_fatal_error(
      CALL assert NOT new_file IS_NEWER_THAN old_file
      MESSAGE "expected file:\n  new_file\nnot to be newer than:\n  old_file")
  endsection()
endsection()

section("directory path condition assertions")
  file(MAKE_DIRECTORY some_directory)
  file(TOUCH some_file)

  section("it should assert directory path conditions")
    assert(IS_DIRECTORY some_directory)
    assert(NOT IS_DIRECTORY some_file)
  endsection()

  section("it should fail to assert directory path conditions")
    assert_fatal_error(
      CALL assert IS_DIRECTORY some_file
      MESSAGE "expected path:\n  some_file\nto be a directory")

    assert_fatal_error(
      CALL assert NOT IS_DIRECTORY some_directory
      MESSAGE "expected path:\n  some_directory\nnot to be a directory")
  endsection()
endsection()

section("symbolic link path condition assertions")
  file(TOUCH some_file)
  file(CREATE_LINK some_file some_symlink SYMBOLIC)

  section("it should assert symbolic link path conditions")
    assert(IS_SYMLINK some_symlink)
    assert(NOT IS_SYMLINK some_file)
  endsection()

  section("it should fail to assert symbolic link path conditions")
    assert_fatal_error(
      CALL assert IS_SYMLINK some_file
      MESSAGE "expected path:\n  some_file\nto be a symbolic link")

    assert_fatal_error(
      CALL assert NOT IS_SYMLINK some_symlink
      MESSAGE "expected path:\n  some_symlink\nnot to be a symbolic link")
  endsection()
endsection()

section("absolute path condition assertions")
  section("it should assert absolute path conditions")
    assert(IS_ABSOLUTE /some/absolute/path)
    assert(NOT IS_ABSOLUTE some/relative/path)
  endsection()

  section("it should fail to assert absolute path conditions")
    assert_fatal_error(
      CALL assert IS_ABSOLUTE some/relative/path
      MESSAGE "expected path:\n  some/relative/path\nto be absolute")

    assert_fatal_error(
      CALL assert NOT IS_ABSOLUTE /some/absolute/path
      MESSAGE "expected path:\n  /some/absolute/path\nnot to be absolute")
  endsection()
endsection()

section("regular expression match condition assertions")
  section("given a string")
    section("it should assert regular expression match conditions")
      assert("some string" MATCHES "so.*ing")
      assert(NOT "some string" MATCHES "so.*other.*ing")
    endsection()

    section("it should fail to assert regular expression match conditions")
      assert_fatal_error(
        CALL assert NOT "some string" MATCHES "so.*ing"
        MESSAGE "expected string:\n  some string\nnot to match:\n  so.*ing")

      assert_fatal_error(
        CALL assert "some string" MATCHES "so.*other.*ing"
        MESSAGE "expected string:\n  some string\nto match:\n  so.*other.*ing")
    endsection()
  endsection()

  section("given a variable")
    set(STRING_VAR "some string")

    section("it should assert regular expression match conditions")
      assert(STRING_VAR MATCHES "so.*ing")
      assert(NOT STRING_VAR MATCHES "so.*other.*ing")
    endsection()

    section("it should fail to assert regular expression match conditions")
      assert_fatal_error(
        CALL assert NOT STRING_VAR MATCHES "so.*ing"
        MESSAGE "expected string:\n  some string\n"
          "of variable:\n  STRING_VAR\n"
          "not to match:\n  so.*ing")

      assert_fatal_error(
        CALL assert STRING_VAR MATCHES "so.*other.*ing"
        MESSAGE "expected string:\n  some string\n"
          "of variable:\n  STRING_VAR\n"
          "to match:\n  so.*other.*ing")
    endsection()
  endsection()
endsection()

section("string equality condition assertions")
  set(STRING_VAR "some string")
  set(OTHER_STRING_VAR "some other string")

  section("given strings")
    section("it should assert string equality conditions")
      assert("some string" STREQUAL "some string")
      assert(NOT "some string" STREQUAL "some other string")
    endsection()

    section("it should fail to assert string equality conditions")
      assert_fatal_error(
        CALL assert NOT "some string" STREQUAL "some string"
        MESSAGE "expected string:\n  some string\n"
          "not to be equal to:\n  some string")

      assert_fatal_error(
        CALL assert "some string" STREQUAL "some other string"
        MESSAGE "expected string:\n  some string\n"
          "to be equal to:\n  some other string")
    endsection()
  endsection()

  section("given variables")
    section("it should assert string equality conditions")
      assert(STRING_VAR STREQUAL STRING_VAR)
      assert(NOT STRING_VAR STREQUAL OTHER_STRING_VAR)
    endsection()

    section("it should fail to assert string equality conditions")
      assert_fatal_error(
        CALL assert NOT STRING_VAR STREQUAL STRING_VAR
        MESSAGE "expected string:\n  some string\n"
          "of variable:\n  STRING_VAR\n"
          "not to be equal to:\n  some string\n"
          "of variable:\n  STRING_VAR")

      assert_fatal_error(
        CALL assert STRING_VAR STREQUAL OTHER_STRING_VAR
        MESSAGE "expected string:\n  some string\n"
          "of variable:\n  STRING_VAR\n"
          "to be equal to:\n  some other string\n"
          "of variable:\n  OTHER_STRING_VAR")
    endsection()
  endsection()
endsection()

section("path equality condition assertions")
  section("given strings")
    section("it should assert path equality conditions")
      assert("/some/path" PATH_EQUAL "/some//path")
      assert(NOT "/some/path" PATH_EQUAL "/some/other/path")
    endsection()

    section("it should fail to assert path equality conditions")
      assert_fatal_error(
        CALL assert "/some/path" PATH_EQUAL "/some/other/path"
        MESSAGE "expected path:\n  /some/path\n"
          "to be equal to:\n  /some/other/path")

      assert_fatal_error(
        CALL assert NOT "/some/path" PATH_EQUAL "/some//path"
        MESSAGE "expected path:\n  /some/path\n"
          "not to be equal to:\n  /some//path")
    endsection()
  endsection()

  section("given variables")
    set(PATH_VAR "/some/path")
    set(PATHH_VAR "/some//path")
    set(OTHER_PATH_VAR "/some/other/path")

    section("it should assert path equality conditions")
      assert(PATH_VAR PATH_EQUAL PATHH_VAR)
      assert(NOT PATH_VAR PATH_EQUAL OTHER_PATH_VAR)
    endsection()

    section("it should fail to assert path equality conditions")
      assert_fatal_error(
        CALL assert PATH_VAR PATH_EQUAL OTHER_PATH_VAR
        MESSAGE "expected path:\n  /some/path\n"
          "of variable:\n  PATH_VAR\n"
          "to be equal to:\n  /some/other/path\n"
          "of variable:\n  OTHER_PATH_VAR")

      assert_fatal_error(
        CALL assert NOT PATH_VAR PATH_EQUAL PATHH_VAR
        MESSAGE "expected path:\n  /some/path\n"
          "of variable:\n  PATH_VAR\n"
          "not to be equal to:\n  /some//path\n"
          "of variable:\n  PATHH_VAR")
    endsection()
  endsection()
endsection()
