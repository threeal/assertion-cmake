cmake_minimum_required(VERSION 3.5)

include(Assertion)

function("Empty assertions")
  assert()
  assert(NOT)
endfunction()

function("Boolean assertions")
  assert(TRUE)
  assert(NOT FALSE)

  mock_message()
    assert(FALSE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected:\n  FALSE\nto resolve to true")

  mock_message()
    assert(NOT TRUE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected:\n  TRUE\nto resolve to false")
endfunction()

function("Variable existence assertions")
  set(EXISTING_VARIABLE TRUE)
  unset(NON_EXSITING_VARIABLE)

  assert(DEFINED EXISTING_VARIABLE)
  assert(NOT DEFINED NON_EXSITING_VARIABLE)

  mock_message()
    assert(DEFINED NON_EXISTING_VARIABLE)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected variable:\n  NON_EXISTING_VARIABLE\nto be defined"
  )

  mock_message()
    assert(NOT DEFINED EXISTING_VARIABLE)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected variable:\n  EXISTING_VARIABLE\nnot to be defined"
  )
endfunction()

function("Path existence assertions")
  file(TOUCH some_file)
  file(REMOVE_RECURSE non_existing_file)

  assert(EXISTS some_file)
  assert(NOT EXISTS non_existing_file)

  mock_message()
    assert(EXISTS non_existing_file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path:\n  non_existing_file\nto exist")

  mock_message()
    assert(NOT EXISTS some_file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path:\n  some_file\nnot to exist")
endfunction()

function("Directory path assertions")
  file(MAKE_DIRECTORY some_directory)
  file(TOUCH some_file)

  assert(IS_DIRECTORY some_directory)
  assert(NOT IS_DIRECTORY some_file)

  mock_message()
    assert(IS_DIRECTORY some_file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path:\n  some_file\nto be a directory")

  mock_message()
    assert(NOT IS_DIRECTORY some_directory)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected path:\n  some_directory\nnot to be a directory"
  )
endfunction()

function("Regular expression match assertions")
  set(STRING_VAR "some string")

  foreach(VALUE STRING_VAR "${STRING_VAR}")
    assert("${VALUE}" MATCHES "so.*ing")
    assert(NOT "${VALUE}" MATCHES "so.*other.*ing")

    mock_message()
      assert(NOT "${VALUE}" MATCHES "so.*ing")
    end_mock_message()
    assert_message(
      FATAL_ERROR
      "expected string:\n  some string\nnot to match:\n  so.*ing"
    )

    mock_message()
      assert("${VALUE}" MATCHES "so.*other.*ing")
    end_mock_message()
    assert_message(
      FATAL_ERROR
      "expected string:\n  some string\nto match:\n  so.*other.*ing"
    )
  endforeach()
endfunction()

function("String equality assertions")
  set(STRING_VAR "some string")
  set(OTHER_STRING_VAR "some other string")

  foreach(LEFT_VALUE STRING_VAR "${STRING_VAR}")
    foreach(RIGHT_VALUE STRING_VAR "${STRING_VAR}")
      assert("${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}")
    endforeach()

    foreach(RIGHT_VALUE OTHER_STRING_VAR "${OTHER_STRING_VAR}")
      assert(NOT "${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}")
    endforeach()

    foreach(RIGHT_VALUE OTHER_STRING_VAR "${OTHER_STRING_VAR}")
      mock_message()
        assert("${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}")
      end_mock_message()
      assert_message(
        FATAL_ERROR
        "expected string:\n  some string\nto be equal to:\n  some other string"
      )
    endforeach()

    foreach(RIGHT_VALUE STRING_VAR "${STRING_VAR}")
      mock_message()
        assert(NOT "${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}")
      end_mock_message()
      assert_message(
        FATAL_ERROR
        "expected string:\n  some string\nnot to be equal to:\n  some string"
      )
    endforeach()
  endforeach()
endfunction()

function("Unsupported assertions")
  mock_message()
    assert(first second)
  end_mock_message()
  assert_message(FATAL_ERROR "unsupported condition:\n  first second")

  mock_message()
    assert(first second third)
  end_mock_message()
  assert_message(FATAL_ERROR "unsupported condition:\n  first second third")

  mock_message()
    assert(first second third fourth)
  end_mock_message()
  assert_message(FATAL_ERROR "unsupported condition:\n  first second third fourth")

  mock_message()
    assert(NOT first second)
  end_mock_message()
  assert_message(FATAL_ERROR "unsupported condition:\n  NOT first second")

  mock_message()
    assert(NOT first second third)
  end_mock_message()
  assert_message(FATAL_ERROR "unsupported condition:\n  NOT first second third")

  mock_message()
    assert(NOT first second third fourth)
  end_mock_message()
  assert_message(FATAL_ERROR "unsupported condition:\n  NOT first second third fourth")
endfunction()

function(call_sample_messages)
  message(WARNING "some warning message")
  message(WARNING "some other warning message")
  message(ERROR "some error message")
  message(FATAL_ERROR "some fatal error message")
  message(ERROR "some other error message")
endfunction()

function("Message assertions")
  mock_message()
    call_sample_messages()
  end_mock_message()

  assert_message(WARNING "some warning message")
  assert_message(WARNING "some other warning message")
  assert_message(ERROR "some error message")
  assert_message(FATAL_ERROR "some fatal error message")

  mock_message()
    assert_message(ERROR "some other error message")
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected error message:\n  \nto be equal to:\n  some other error message"
  )
endfunction()

function("Process execution assertions")
  assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E true)
  assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E false ERROR .*)

  mock_message()
    assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E true ERROR .*)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected command:\n  ${CMAKE_COMMAND} -E true\nto fail")

  mock_message()
    assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E false)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected command:\n  ${CMAKE_COMMAND} -E false\nnot to fail")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
    OUTPUT "Hello.*!")

  mock_message()
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      OUTPUT "Hi.*!")
  end_mock_message()
  string(
    JOIN "\n" EXPECTED_MESSAGE
    "expected the output:"
    "  Hello world!"
    "of command:"
    "  ${CMAKE_COMMAND} -E echo Hello world!"
    "to match:"
    "  Hi.*!")
  assert_message(FATAL_ERROR "${EXPECTED_MESSAGE}")

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E touch /
    ERROR "cmake -E touch: failed to update")

  mock_message()
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E touch /
      ERROR "cmake -E touch: not failed to update")
  end_mock_message()
  string(
    JOIN "\n" EXPECTED_MESSAGE
    "expected the error:"
    "  cmake -E touch: failed to update \"/\"."
    "of command:"
    "  ${CMAKE_COMMAND} -E touch /"
    "to match:"
    "  cmake -E touch: not failed to update")
  assert_message(FATAL_ERROR "${EXPECTED_MESSAGE}")
endfunction()

function("Mock message")
  mock_message()
    call_sample_messages()
  end_mock_message()

  assert(DEFINED WARNING_MESSAGES)
  assert(WARNING_MESSAGES STREQUAL "some warning message;some other warning message")

  assert(DEFINED ERROR_MESSAGES)
  assert("${ERROR_MESSAGES}" STREQUAL "some error message")

  assert(DEFINED FATAL_ERROR_MESSAGES)
  assert("${FATAL_ERROR_MESSAGES}" STREQUAL "some fatal error message")
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
