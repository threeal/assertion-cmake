section("it should fail with a formatted fatal error message")
  set(REASON "some reason")

  assert_fatal_error(
    CALL fail "something happened:" REASON
    MESSAGE "something happened:\n  some reason")
endsection()
