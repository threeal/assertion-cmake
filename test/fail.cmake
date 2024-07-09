section("given strings")
  section("it should fail with a formatted fatal error message")
    assert_fatal_error(
      CALL fail "single line string"
      MESSAGE "single line string")

    assert_fatal_error(
      CALL fail "multiple\nlines\nstring"
      MESSAGE "multiple\nlines\nstring")

    assert_fatal_error(
      CALL fail "single line string" "multiple\nlines\nstring"
      MESSAGE "single line string\nmultiple\nlines\nstring")
  endsection()
endsection()

section("given strings and variables")
  section("it should fail with a formatted fatal error message")
    set(SINGLE "single line variable")
    set(MULTIPLE "multiple\nlines\nvariable")

    assert_fatal_error(
      CALL fail "single line string" SINGLE
      MESSAGE "single line string:\n  single line variable")

    assert_fatal_error(
      CALL fail "multiple\nlines\nstring" MULTIPLE
      MESSAGE "multiple\nlines\nstring:\n  multiple\n  lines\n  variable")

    assert_fatal_error(
      CALL fail "single line string" "multiple\nlines\nstring" SINGLE
      MESSAGE "single line string\nmultiple\nlines\nstring:\n"
        "  single line variable")

    assert_fatal_error(
      CALL fail "single line string" SINGLE "multiple\nlines\nstring" MULTIPLE
      MESSAGE "single line string:\n  single line variable\n"
        "multiple\nlines\nstring:\n  multiple\n  lines\n  variable")
  endsection()
endsection()
