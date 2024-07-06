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

  section("given a string and a variable")
    section("it should assert string equality conditions")
      assert("some string" STREQUAL STRING_VAR)
      assert(NOT "some string" STREQUAL OTHER_STRING_VAR)
    endsection()

    section("it should fail to assert string equality conditions")
      assert_fatal_error(
        CALL assert NOT "some string" STREQUAL STRING_VAR
        MESSAGE "expected string:\n  some string\n"
          "not to be equal to string:\n  some string\n"
          "of variable:\n  STRING_VAR")

      assert_fatal_error(
        CALL assert "some string" STREQUAL OTHER_STRING_VAR
        MESSAGE "expected string:\n  some string\n"
          "to be equal to string:\n  some other string\n"
          "of variable:\n  OTHER_STRING_VAR")
    endsection()
  endsection()

  section("given a variable and a string")
    section("it should assert string equality conditions")
      assert(STRING_VAR STREQUAL "some string")
      assert(NOT STRING_VAR STREQUAL "some other string")
    endsection()

    section("it should fail to assert string equality conditions")
      assert_fatal_error(
        CALL assert NOT STRING_VAR STREQUAL "some string"
        MESSAGE "expected string:\n  some string\n"
          "of variable:\n  STRING_VAR\n"
          "not to be equal to:\n  some string")

      assert_fatal_error(
        CALL assert STRING_VAR STREQUAL "some other string"
        MESSAGE "expected string:\n  some string\n"
          "of variable:\n  STRING_VAR\n"
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
          "not to be equal to string:\n  some string\n"
          "of variable:\n  STRING_VAR")

      assert_fatal_error(
        CALL assert STRING_VAR STREQUAL OTHER_STRING_VAR
        MESSAGE "expected string:\n  some string\n"
          "of variable:\n  STRING_VAR\n"
          "to be equal to string:\n  some other string\n"
          "of variable:\n  OTHER_STRING_VAR")
    endsection()
  endsection()
endsection()
