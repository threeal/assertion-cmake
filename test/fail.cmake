section("it should fail with a formatted fatal error message")
  assert_fatal_error(
    CALL fail "something happened"
    MESSAGE "something happened")

  assert_fatal_error(
    CALL fail "something happened\non multiple lines"
    MESSAGE "something happened\non multiple lines")

  assert_fatal_error(
    CALL fail "something happened" "not on multiple lines"
    MESSAGE "something happened not on multiple lines")
endsection()

section("it should fail with a formatted fatal error message "
  "that contains values")
  set(REASON "some reason")
  set(REASON_MULTILINE "some reason\non multiple lines")

  assert_fatal_error(
    CALL fail "something happened because of" REASON
    MESSAGE "something happened because of 'some reason'")

  assert_fatal_error(
    CALL fail "something happened because of" REASON_MULTILINE
    MESSAGE "something happened because of:\n"
      "  some reason\n  on multiple lines")

  assert_fatal_error(
    CALL fail "something happened\non multiple lines because of" REASON
    MESSAGE "something happened\non multiple lines because of 'some reason'")

  assert_fatal_error(
    CALL fail "something happened\non multiple lines because of"
      REASON_MULTILINE
    MESSAGE "something happened\non multiple lines because of:\n"
      "  some reason\n  on multiple lines")

  assert_fatal_error(
    CALL fail "something happened" "not on multiple lines because of" REASON
    MESSAGE "something happened not on multiple lines because of 'some reason'")

  assert_fatal_error(
    CALL fail
      "something happened" "not on multiple lines because of" REASON
      "something else happened because of" REASON_MULTILINE
    MESSAGE "something happened not on multiple lines because of 'some reason' "
      "something else happened because of:\n  some reason\n  on multiple lines")
endsection()
