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

set(SINGLE "single line variable")
set(MULTIPLE "multiple\nlines\nvariable")

section("given variables")
  section("it should fail with a formatted fatal error message")
    assert_fatal_error(
      CALL fail SINGLE
      MESSAGE "single line variable")

    assert_fatal_error(
      CALL fail MULTIPLE
      MESSAGE "multiple\nlines\nvariable")

    assert_fatal_error(
      CALL fail SINGLE MULTIPLE
      MESSAGE "single line variable\nmultiple\nlines\nvariable")
  endsection()
endsection()

section("given strings and variables")
  section("it should fail with a formatted fatal error message")
    assert_fatal_error(
      CALL fail "single line string" SINGLE
      MESSAGE "single line string:\n  single line variable")

    assert_fatal_error(
      CALL fail SINGLE "single line string"
      MESSAGE "single line variable\nsingle line string")

    assert_fatal_error(
      CALL fail "multiple\nlines\nstring" MULTIPLE
      MESSAGE "multiple\nlines\nstring:\n  multiple\n  lines\n  variable")

    assert_fatal_error(
      CALL fail MULTIPLE "multiple\nlines\nstring"
      MESSAGE "multiple\nlines\nvariable\nmultiple\nlines\nstring")

    assert_fatal_error(
      CALL fail "single line string" "multiple\nlines\nstring" SINGLE MULTIPLE
      MESSAGE "single line string\nmultiple\nlines\nstring:\n"
        "  single line variable\n  multiple\n  lines\n  variable")

    assert_fatal_error(
      CALL fail SINGLE MULTIPLE "single line string" "multiple\nlines\nstring"
      MESSAGE "single line variable\nmultiple\nlines\nvariable\n"
        "single line string\nmultiple\nlines\nstring")

    assert_fatal_error(
      CALL fail "single line string" SINGLE "multiple\nlines\nstring" MULTIPLE
      MESSAGE "single line string:\n  single line variable\n"
        "multiple\nlines\nstring:\n  multiple\n  lines\n  variable")

    assert_fatal_error(
      CALL fail SINGLE "single line string" MULTIPLE "multiple\nlines\nstring"
      MESSAGE "single line variable\nsingle line string:\n"
        "  multiple\n  lines\n  variable\nmultiple\nlines\nstring")
  endsection()
endsection()
