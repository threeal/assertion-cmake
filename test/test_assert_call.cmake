cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

function(throw_errors)
  message(SEND_ERROR "a send error message")
  message(FATAL_ERROR "a fatal error message")
endfunction()

section("it should assert error messages")
  assert_call(throw_errors EXPECT_ERROR
    "a se.*or message\n"
    "a fa.*or message")

  assert_call(CALL throw_errors EXPECT_ERROR
    "a se.*or message\n"
    "a fa.*or message")

  assert_call(throw_errors EXPECT_ERROR MATCHES
    "a se.*or message\n"
    "a fa.*or message")

  assert_call(throw_errors EXPECT_ERROR STREQUAL
    "a send error message\n"
    "a fatal error message")
endsection()

section("it should fail to assert error messages")
  macro(assert_failures)
    assert_call(throw_errors EXPECT_ERROR
      "another se.*or message\n"
      "another fa.*or message")
  endmacro()

  assert_call(assert_failures EXPECT_ERROR STREQUAL
    "expected error message:\n"
    "  a send error message\n"
    "  a fatal error message\n"
    "to match:\n"
    "  another se.*or message\n"
    "  another fa.*or message")

  macro(assert_failures)
    assert_call(throw_errors EXPECT_ERROR
      "another send error message\n"
      "another fatal error message")
  endmacro()

  assert_call(assert_failures EXPECT_ERROR STREQUAL
    "expected error message:\n"
    "  a send error message\n"
    "  a fatal error message\n"
    "to match:\n"
    "  another send error message\n"
    "  another fatal error message")
endsection()

section("it should fail to assert error messages "
  "due to no error being received")
  macro(failed_assertion)
    assert_call(message "a message" EXPECT_ERROR "a message")
  endmacro()

  assert_call(failed_assertion EXPECT_ERROR
    "expected to receive an error message")
endsection()
