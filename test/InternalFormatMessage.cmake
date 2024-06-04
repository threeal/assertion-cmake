cmake_minimum_required(VERSION 3.5)

include(Assertion)

_assert_internal_format_message(
  MESSAGE "first line" "second line" "third line\nthird line" "fourth line\nfourth line")

string(
  JOIN "\n" EXPECTED_MESSAGE
  "first line"
  "  second line"
  "third line"
  "third line"
  "  fourth line"
  "  fourth line")
assert(MESSAGE STREQUAL EXPECTED_MESSAGE)
