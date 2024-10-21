cmake_minimum_required(VERSION 3.24)

include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Assertion.cmake)

function(throw_errors)
  message(SEND_ERROR "a send error message")
  message(FATAL_ERROR "a fatal error message")
endfunction()

section("assert command calls")
  section("it should assert command calls")
    assert_call(message DEBUG "a debug message")
    assert_call(CALL message DEBUG "a debug message")
  endsection()

  section("it should fail to assert a command call")
    assert_call(assert_call throw_errors EXPECT_ERROR STREQUAL
      "expected not to receive errors:\n"
      "  a send error message\n"
      "  a fatal error message")
  endsection()
endsection()

section("assert command call errors")
  section("it should assert command call errors")
    assert_call(throw_errors EXPECT_ERROR
      "a se.*or message\n"
      "a fa.*or message")

    assert_call(throw_errors EXPECT_ERROR MATCHES
      "a se.*or message\n"
      "a fa.*or message")

    assert_call(throw_errors EXPECT_ERROR STREQUAL
      "a send error message\n"
      "a fatal error message")
  endsection()

  section("it should fail to assert command call errors")
    macro(assert_failures)
      assert_call(message DEBUG "a debug message"
        EXPECT_ERROR "a debug message")
    endmacro()

    assert_call(assert_failures EXPECT_ERROR STREQUAL
      "expected to receive errors")

    macro(assert_failures)
      assert_call(throw_errors EXPECT_ERROR
        "another se.*or message\n"
        "another fa.*or message")
    endmacro()

    assert_call(assert_failures EXPECT_ERROR STREQUAL
      "expected errors:\n"
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
      "expected errors:\n"
      "  a send error message\n"
      "  a fatal error message\n"
      "to match:\n"
      "  another send error message\n"
      "  another fatal error message")
  endsection()
endsection()
