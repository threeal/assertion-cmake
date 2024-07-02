section("it should format lines for an assertion message")
  _assert_internal_format_message(
    ACTUAL_MESSAGE "first line" "second line" "third line\nthird line")

  string(JOIN "\n" EXPECTED_MESSAGE
    "first line"
    "second line"
    "third line"
    "third line")
  assert(ACTUAL_MESSAGE STREQUAL EXPECTED_MESSAGE)
endsection()

section("it should format lines that contain variables for an assertion message")
  set(FIRST_VALUE "first value")
  set(SECOND_VALUE "second value")
  set(THIRD_VALUE "third value\nthird value")

  _assert_internal_format_message(
    ACTUAL_MESSAGE "first line" FIRST_VALUE
      "second line" SECOND_VALUE
      THIRD_VALUE "third line\nthird line")

  string(JOIN "\n" EXPECTED_MESSAGE
    "first line"
    "  first value"
    "second line"
    "  second value"
    "  third value"
    "  third value"
    "third line"
    "third line")
  assert(ACTUAL_MESSAGE STREQUAL EXPECTED_MESSAGE)
endsection()
