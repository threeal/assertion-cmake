section("it should fail with a formatted fatal error message")
  assert_fatal_error(
    CALL fail "something happened"
    MESSAGE "something happened")

  assert_fatal_error(
    CALL fail "something happened\non multiple lines"
    MESSAGE "something happened\non multiple lines")

  assert_fatal_error(
    CALL fail "something happened" "on multiple lines"
    MESSAGE "something happened\non multiple lines")
endsection()

section("it should fail with a formatted fatal error message "
  "that contains values")
  set(REASON "some reason")
  set(REASON_MULTILINE "some reason\non multiple lines")

  assert_fatal_error(
    CALL fail "something happened:" REASON
    MESSAGE "something happened:\n  some reason")

  assert_fatal_error(
    CALL fail "something happened:" REASON_MULTILINE
    MESSAGE "something happened:\n  some reason\n  on multiple lines")

  assert_fatal_error(
    CALL fail "something happened\non multiple lines:" REASON
    MESSAGE "something happened\non multiple lines:\n  some reason")

  assert_fatal_error(
    CALL fail "something happened\non multiple lines:" REASON_MULTILINE
    MESSAGE "something happened\non multiple lines:\n"
      "  some reason\n  on multiple lines")

  assert_fatal_error(
    CALL fail "something happened" "on multiple lines:" REASON
    MESSAGE "something happened\non multiple lines:\n  some reason")

  assert_fatal_error(
    CALL fail
      "something happened" "on multiple lines:" REASON
      "something else happened:" REASON_MULTILINE
    MESSAGE "something happened\non multiple lines:\n  some reason\n"
      "something else happened:\n  some reason\n  on multiple lines")
endsection()
