section("boolean assertions")
  assert(TRUE)
  assert(NOT FALSE)

  assert_fatal_error(
    CALL assert FALSE
    MESSAGE "expected:\n  FALSE\nto resolve to true")

  assert_fatal_error(
    CALL assert NOT TRUE
    MESSAGE "expected:\n  NOT TRUE\nto resolve to true")
endsection()

section("variable existence assertions")
  set(EXISTING_VARIABLE TRUE)
  unset(NON_EXSITING_VARIABLE)

  assert(DEFINED EXISTING_VARIABLE)
  assert(NOT DEFINED NON_EXSITING_VARIABLE)

  assert_fatal_error(
    CALL assert DEFINED NON_EXISTING_VARIABLE
    MESSAGE "expected variable:\n  NON_EXISTING_VARIABLE\nto be defined")

  assert_fatal_error(
    CALL assert NOT DEFINED EXISTING_VARIABLE
    MESSAGE "expected variable:\n  EXISTING_VARIABLE\nnot to be defined")
endsection()

section("path existence assertions")
  file(TOUCH some_file)
  file(REMOVE_RECURSE non_existing_file)

  assert(EXISTS some_file)
  assert(NOT EXISTS non_existing_file)

  assert_fatal_error(
    CALL assert EXISTS non_existing_file
    MESSAGE "expected path:\n  non_existing_file\nto exist")

  assert_fatal_error(
    CALL assert NOT EXISTS some_file
    MESSAGE "expected path:\n  some_file\nnot to exist")
endsection()

section("directory path assertions")
  file(MAKE_DIRECTORY some_directory)
  file(TOUCH some_file)

  assert(IS_DIRECTORY some_directory)
  assert(NOT IS_DIRECTORY some_file)

  assert_fatal_error(
    CALL assert IS_DIRECTORY some_file
    MESSAGE "expected path:\n  some_file\nto be a directory")

  assert_fatal_error(
    CALL assert NOT IS_DIRECTORY some_directory
    MESSAGE "expected path:\n  some_directory\nnot to be a directory")
endsection()

section("regular expression match assertions")
  set(STRING_VAR "some string")

  assert("some string" MATCHES "so.*ing")
  assert(NOT "some string" MATCHES "so.*other.*ing")

  assert(STRING_VAR MATCHES "so.*ing")
  assert(NOT STRING_VAR MATCHES "so.*other.*ing")

  assert_fatal_error(
    CALL assert NOT "some string" MATCHES "so.*ing"
    MESSAGE "expected string:\n  some string\nnot to match:\n  so.*ing")

  assert_fatal_error(
    CALL assert "some string" MATCHES "so.*other.*ing"
    MESSAGE "expected string:\n  some string\nto match:\n  so.*other.*ing")

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

section("string equality assertions")
  set(STRING_VAR "some string")
  set(OTHER_STRING_VAR "some other string")

  assert("some string" STREQUAL "some string")
  assert(NOT "some string" STREQUAL "some other string")

  assert(STRING_VAR STREQUAL "some string")
  assert(NOT STRING_VAR STREQUAL "some other string")

  assert("some string" STREQUAL STRING_VAR)
  assert(NOT "some string" STREQUAL OTHER_STRING_VAR)

  assert(STRING_VAR STREQUAL STRING_VAR)
  assert(NOT STRING_VAR STREQUAL OTHER_STRING_VAR)

  assert_fatal_error(
    CALL assert NOT "some string" STREQUAL "some string"
    MESSAGE "expected string:\n  some string\n"
      "not to be equal to:\n  some string")

  assert_fatal_error(
    CALL assert "some string" STREQUAL "some other string"
    MESSAGE "expected string:\n  some string\n"
      "to be equal to:\n  some other string")

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
