cmake_minimum_required(VERSION 3.5)

find_package(Assertion REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

_assert_internal_format_message(
  MESSAGE "first line" "second line"
    "third line\nthird line" "fourth line\nfourth line")

assert_fatal_error(
  CALL message FATAL_ERROR "${MESSAGE}"
  MESSAGE "first line:\n"
    "  second line\n"
    "third line\n"
    "third line:\n"
    "  fourth line\n"
    "  fourth line")
