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
  assert_message(FATAL_ERROR "expected 'FALSE' to resolve to true")

  mock_message()
    assert(NOT TRUE)
  end_mock_message()
  assert_message(FATAL_ERROR "expected 'TRUE' to resolve to false")
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
    "expected variable 'NON_EXISTING_VARIABLE' to be defined"
  )

  mock_message()
    assert(NOT DEFINED EXISTING_VARIABLE)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected variable 'EXISTING_VARIABLE' not to be defined"
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
  assert_message(FATAL_ERROR "expected path 'non_existing_file' to exist")

  mock_message()
    assert(NOT EXISTS some_file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some_file' not to exist")
endfunction()

function("Directory path assertions")
  file(MAKE_DIRECTORY some_directory)
  file(TOUCH some_file)

  assert(IS_DIRECTORY some_directory)
  assert(NOT IS_DIRECTORY some_file)

  mock_message()
    assert(IS_DIRECTORY some_file)
  end_mock_message()
  assert_message(FATAL_ERROR "expected path 'some_file' to be a directory")

  mock_message()
    assert(NOT IS_DIRECTORY some_directory)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected path 'some_directory' not to be a directory"
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
      "expected string 'some string' not to match 'so.*ing'"
    )

    mock_message()
      assert("${VALUE}" MATCHES "so.*other.*ing")
    end_mock_message()
    assert_message(
      FATAL_ERROR
      "expected string 'some string' to match 'so.*other.*ing'"
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
        "expected string 'some string' to be equal to 'some other string'"
      )
    endforeach()

    foreach(RIGHT_VALUE STRING_VAR "${STRING_VAR}")
      mock_message()
        assert(NOT "${LEFT_VALUE}" STREQUAL "${RIGHT_VALUE}")
      end_mock_message()
      assert_message(
        FATAL_ERROR
        "expected string 'some string' not to be equal to 'some string'"
      )
    endforeach()
  endforeach()
endfunction()

function("Unsupported assertions")
  foreach(WITH_NOT IN ITEMS "" NOT)
    mock_message()
      assert(${WITH_NOT} first second)
    end_mock_message()
    assert_message(FATAL_ERROR "unsupported condition: first second")

    mock_message()
      assert(${WITH_NOT} first second third)
    end_mock_message()
    assert_message(FATAL_ERROR "unsupported condition: first second third")

    mock_message()
      assert(${WITH_NOT} first second fourth)
    end_mock_message()
    assert_message(FATAL_ERROR "unsupported condition: first second fourth")
  endforeach()
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
    "expected error message '' to be equal to 'some other error message'"
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
    "expected command '${CMAKE_COMMAND} -E true' to fail"
  )

  mock_message()
    assert_execute_process(COMMAND "${CMAKE_COMMAND}" -E false)
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected command '${CMAKE_COMMAND} -E false' not to fail"
  )

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
    OUTPUT "Hello.*!"
  )

  mock_message()
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
      OUTPUT "Hi.*!"
    )
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected the output of command '${CMAKE_COMMAND} -E echo Hello world!' to match 'Hi.*!'"
  )

  assert_execute_process(
    COMMAND "${CMAKE_COMMAND}" -E invalid
    ERROR "CMake Error:.*Available commands:"
  )

  mock_message()
    assert_execute_process(
      COMMAND "${CMAKE_COMMAND}" -E invalid
      ERROR "CMake Error:.*Unavailable commands:"
    )
  end_mock_message()
  assert_message(
    FATAL_ERROR
    "expected the error of command '${CMAKE_COMMAND} -E invalid' to match 'CMake Error:.*Unavailable commands:'"
  )
endfunction()

function("Mock message")
  mock_message()
    call_sample_messages()
  end_mock_message()

  assert(DEFINED WARNING_MESSAGES)

  set(EXPECTED_WARNING_MESSAGES "some warning message;some other warning message")
  assert(WARNING_MESSAGES STREQUAL EXPECTED_WARNING_MESSAGES)

  assert(DEFINED ERROR_MESSAGES)
  assert("${ERROR_MESSAGES}" STREQUAL "some error message")

  assert(DEFINED FATAL_ERROR_MESSAGES)
  assert("${FATAL_ERROR_MESSAGES}" STREQUAL "some fatal error message")
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
