# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Formats an assertion message with indentation on each even line.
#
# _assert_internal_format_message(<out_var> [<lines>...])
#
# This function formats the given lines by appending all of them into a single
# string. Each even line will be indented by 2 spaces. The formatted string will
# then be stored in the `<out_var>` variable.
function(_assert_internal_format_message OUT_VAR FIRST_LINE)
  set(MESSAGE "${FIRST_LINE}")
  if(ARGC GREATER 2)
    math(EXPR STOP "${ARGC} - 1")
    foreach(I RANGE 2 "${STOP}")
      string(STRIP "${ARGV${I}}" LINE)
      math(EXPR MOD "${I} % 2")
      if(MOD EQUAL 0)
        string(REPLACE "\n" "\n  " LINE "${LINE}")
        set(MESSAGE "${MESSAGE}\n  ${LINE}")
      else()
        set(MESSAGE "${MESSAGE}\n${LINE}")
      endif()
    endforeach()
  endif()
  set("${OUT_VAR}" "${MESSAGE}" PARENT_SCOPE)
endfunction()

# Asserts the given condition.
#
# assert(<condition>)
#
# This function performs an assertion on the given condition. It will output a
# fatal error message if the assertion fails.
#
# Refer to the documentation of the `if` function for supported conditions to
# perform the assertion.
function(assert)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "" "")
  if(${ARG_UNPARSED_ARGUMENTS})
    # Do nothing if the assertion succeeds.
  else()
    string(REPLACE ";" " " ARGS "${ARG_UNPARSED_ARGUMENTS}")
    _assert_internal_format_message(
      MESSAGE "expected:" "${ARGS}" "to resolve to true")

    if(ARGC EQUAL 2)
      if(NOT ARGV0 STREQUAL NOT)
        if(ARGV0 STREQUAL DEFINED)
          _assert_internal_format_message(
            MESSAGE "expected variable:" "${ARGV1}" "to be defined")
        elseif(ARGV0 STREQUAL EXISTS)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV1}" "to exist")
        elseif(ARGV0 STREQUAL IS_DIRECTORY)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV1}" "to be a directory")
        endif()
      endif()
    elseif(ARGC EQUAL 3)
      if(ARGV0 STREQUAL NOT)
        if(ARGV1 STREQUAL DEFINED)
          _assert_internal_format_message(
            MESSAGE "expected variable:" "${ARGV2}" "not to be defined")
        elseif(ARGV1 STREQUAL EXISTS)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV2}" "not to exist")
        elseif(ARGV1 STREQUAL IS_DIRECTORY)
          _assert_internal_format_message(
            MESSAGE "expected path:" "${ARGV2}" "not to be a directory")
        endif()
      else()
        if(ARGV1 STREQUAL MATCHES)
          if(DEFINED "${ARGV0}")
            _assert_internal_format_message(
              MESSAGE
              "expected string:" "${${ARGV0}}"
              "of variable:" "${ARGV0}"
              "to match:" "${ARGV2}")
          else()
            _assert_internal_format_message(
              MESSAGE "expected string:" "${ARGV0}" "to match:" "${ARGV2}")
          endif()
        elseif(ARGV1 STREQUAL STREQUAL)
          if(DEFINED "${ARGV0}")
            if(DEFINED "${ARGV2}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV0}}"
                "of variable:" "${ARGV0}"
                "to be equal to string:" "${${ARGV2}}"
                "of variable:" "${ARGV2}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV0}}"
                "of variable:" "${ARGV0}"
                "to be equal to:" "${ARGV2}")
            endif()
          else()
            if(DEFINED "${ARGV2}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV0}"
                "to be equal to string:" "${${ARGV2}}"
                "of variable:" "${ARGV2}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV0}"
                "to be equal to:" "${ARGV2}")
            endif()
          endif()
        endif()
      endif()
    elseif(ARGC EQUAL 4)
      if(ARGV0 STREQUAL NOT)
        if(ARGV2 STREQUAL MATCHES)
          if(DEFINED "${ARGV1}")
            _assert_internal_format_message(
              MESSAGE
              "expected string:" "${${ARGV1}}"
              "of variable:" "${ARGV1}"
              "not to match:" "${ARGV3}")
          else()
            _assert_internal_format_message(
              MESSAGE "expected string:" "${ARGV1}" "not to match:" "${ARGV3}")
          endif()
        elseif(ARGV2 STREQUAL STREQUAL)
          if(DEFINED "${ARGV1}")
            if(DEFINED "${ARGV3}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV1}}"
                "of variable:" "${ARGV1}"
                "not to be equal to string:" "${${ARGV3}}"
                "of variable:" "${ARGV3}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${${ARGV1}}"
                "of variable:" "${ARGV1}"
                "not to be equal to:" "${ARGV3}")
            endif()
          else()
            if(DEFINED "${ARGV3}")
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV1}"
                "not to be equal to string:" "${${ARGV3}}"
                "of variable:" "${ARGV3}")
            else()
              _assert_internal_format_message(
                MESSAGE
                "expected string:" "${ARGV1}"
                "not to be equal to:" "${ARGV3}")
            endif()
          endif()
        endif()
      endif()
    endif()

    message(FATAL_ERROR "${MESSAGE}")
  endif()
endfunction()

# Begins a new scope for mocking the `message` function.
#
# _assert_internal_mock_message()
#
# This macro begins a new scope for mocking the `message` function by modifying
# its behavior to store the message into a list variable instead of printing it
# to the log.
#
# Use the `_assert_internal_end_mock_message` macro to end the scope for mocking
# the `message` function, reverting it to the original behavior.
macro(_assert_internal_mock_message)
  macro(message MODE MESSAGE)
    if(DEFINED _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
      list(APPEND ${MODE}_MESSAGES "${MESSAGE}")
      set(${MODE}_MESSAGES "${${MODE}_MESSAGES}" PARENT_SCOPE)
      if("${MODE}" STREQUAL FATAL_ERROR)
        return()
      endif()
    else()
      _message("${MODE}" "${MESSAGE}")
    endif()
  endmacro()

  macro(_assert_internal_mock_message)
    if(NOT DEFINED _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
      set(_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL 1)
    else()
      math(
        EXPR _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL
        "${_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL} + 1")
    endif()
  endmacro()
  _assert_internal_mock_message()
endmacro()

# Ends the current scope for mocking the `message` function.
#
# _assert_internal_end_mock_message()
#
# This macro ends the current scope for mocking the `message` function,
# reverting it to the original behavior.
macro(_assert_internal_end_mock_message)
  if(DEFINED _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
    math(
      EXPR _ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL
      "${_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL} - 1")
    if(_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL LESS_EQUAL 0)
      unset(_ASSERT_INTERNAL_MESSAGE_MOCK_LEVEL)
    endif()
  endif()
endmacro()

# Asserts whether a command call throws a fatal error message.
#
# assert_fatal_error(CALL <command> [<arg>...] MESSAGE <message>)
#
# This function asserts whether a function or macro named `<command>` called
# with the specified arguments throws the expected `<message>` fatal error
# message.
function(assert_fatal_error)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" MESSAGE CALL)

  list(POP_FRONT ARG_CALL COMMAND)
  _assert_internal_mock_message()
    cmake_language(CALL "${COMMAND}" ${ARG_CALL})
  _assert_internal_end_mock_message()

  list(POP_FRONT FATAL_ERROR_MESSAGES MESSAGE)
  if(NOT MESSAGE STREQUAL ARG_MESSAGE)
    _assert_internal_format_message(
      ASSERT_MESSAGE "expected fatal error message:" "${MESSAGE}"
      "to be equal to:" "${ARG_MESSAGE}")
    message(FATAL_ERROR "${ASSERT_MESSAGE}")
  endif()
endfunction()

# Asserts whether the given command correctly executes a process.
#
# assert_execute_process(
#   COMMAND <command> [<arg>...] [OUTPUT <output>] [ERROR <error>])
#
# This function asserts whether the given command and arguments successfully
# execute a process.
#
# If `OUTPUT` is specified, it also asserts whether the output of the executed
# process matches the expected `<output>`.
#
# If `ERROR` is specified, this function asserts whether the given command and
# arguments fail to execute a process. It also asserts whether the error of the
# executed process matches the expected `<error>`.
function(assert_execute_process)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "OUTPUT;ERROR" "COMMAND")

  execute_process(
    COMMAND ${ARG_COMMAND}
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
    ERROR_VARIABLE ERR
  )

  if(DEFINED ARG_ERROR AND RES EQUAL 0)
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected command:" "${COMMAND}" "to fail")
    message(FATAL_ERROR "${MESSAGE}")
  elseif(NOT DEFINED ARG_ERROR AND NOT RES EQUAL 0)
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected command:" "${COMMAND}" "not to fail")
    message(FATAL_ERROR "${MESSAGE}")
  elseif(DEFINED ARG_OUTPUT AND NOT "${OUT}" MATCHES "${ARG_OUTPUT}")
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected the output:" "${OUT}"
      "of command:" "${COMMAND}"
      "to match:" "${ARG_OUTPUT}")
    message(FATAL_ERROR "${MESSAGE}")
  elseif(DEFINED ARG_ERROR AND NOT "${ERR}" MATCHES "${ARG_ERROR}")
    string(REPLACE ";" " " COMMAND "${ARG_COMMAND}")
    _assert_internal_format_message(
      MESSAGE "expected the error:" "${ERR}"
      "of command:" "${COMMAND}"
      "to match:" "${ARG_ERROR}")
    message(FATAL_ERROR "${MESSAGE}")
  endif()
endfunction()

# Begins a new test section.
#
# section(<name>)
#
# This macro begins a new test section named `<name>`. Use the `endsection`
# macro to end the test section.
macro(section NAME)
  message(CHECK_START "${NAME}")
endmacro()

# Ends the current test section.
#
# ```cmake
# endsection()
# ```
#
# Ends the current test section and marks it as passed.
macro(endsection)
  message(CHECK_PASS passed)
endmacro()
