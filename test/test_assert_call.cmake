cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

section("it should assert error messages")
  assert_call(message FATAL_ERROR "an error message"
    EXPECT_ERROR "an e...r message")

  assert_call(message SEND_ERROR "an error message"
    EXPECT_ERROR "an e...r message")

  assert_call(
    CALL message FATAL_ERROR "an error message"
    EXPECT_ERROR "an e...r message")

  assert_call(message FATAL_ERROR "an error message"
    EXPECT_ERROR MATCHES "an e...r message")

  assert_call(message FATAL_ERROR "an error message"
    EXPECT_ERROR STREQUAL "an error message")
endsection()

section("it should fail to assert error messages")
  macro(failed_assertion)
    assert_call(message FATAL_ERROR "an error message"
      EXPECT_ERROR "an..... e...r message")
  endmacro()

  assert_call(failed_assertion
    EXPECT_ERROR STREQUAL "expected error message:\n  an error message\n"
      "to match:\n  an..... e...r message")

  macro(failed_assertion)
    assert_call(message SEND_ERROR "an error message"
      EXPECT_ERROR MATCHES "an..... e...r message")
  endmacro()

  assert_call(failed_assertion
    EXPECT_ERROR STREQUAL "expected error message:\n  an error message\n"
      "to match:\n  an..... e...r message")

  macro(failed_assertion)
    assert_call(message FATAL_ERROR "an error message"
      EXPECT_ERROR STREQUAL "another error message")
  endmacro()

  assert_call(failed_assertion
    EXPECT_ERROR STREQUAL "expected error message:\n  an error message\n"
      "to be equal to:\n  another error message")
endsection()

section("it should fail to assert error messages "
  "due to no error being received")
  macro(failed_assertion)
    assert_call(message "a message" EXPECT_ERROR "a message")
  endmacro()

  assert_call(failed_assertion
    EXPECT_ERROR "expected to receive an error message")
endsection()
