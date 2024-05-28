# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Asserts whether the given condition is true.
#
# This function performs an assertion on the given condition. It will output a
# fatal error message if the assertion fails.
#
# Refer to the documentation of the 'if' function for supported conditions to
# perform the assertion.
function(assert)
  list(LENGTH ARGN ARGUMENTS_LENGTH)
  if(ARGUMENTS_LENGTH GREATER 0)
    set(ARGUMENTS ${ARGN})

    # Determines whether the given arguments start with 'NOT'.
    list(GET ARGUMENTS 0 ARGUMENTS_0)
    if(ARGUMENTS_0 STREQUAL NOT)
      list(REMOVE_AT ARGUMENTS 0)
      set(BOOLEAN_WORD " false")
      set(NOT_WORD " not")
    else()
      set(ARGUMENT_NOT NOT)
      set(BOOLEAN_WORD " true")
    endif()

    list(LENGTH ARGUMENTS ARGUMENTS_LENGTH)
    if(ARGUMENTS_LENGTH EQUAL 2)
      list(GET ARGUMENTS 0 OPERATOR)
      list(GET ARGUMENTS 1 VALUE)

      if(OPERATOR STREQUAL DEFINED)
        set(MESSAGE "expected variable '${VALUE}'${NOT_WORD} to be defined")
      elseif(OPERATOR STREQUAL EXISTS)
        set(MESSAGE "expected path '${VALUE}'${NOT_WORD} to exist")
      elseif(OPERATOR STREQUAL IS_DIRECTORY)
        set(MESSAGE "expected path '${VALUE}'${NOT_WORD} to be a directory")
      else()
        string(REPLACE ";" " " ARGUMENTS "${ARGUMENTS}")
        message(FATAL_ERROR "unsupported condition: ${ARGUMENTS}")
      endif()
    elseif(ARGUMENTS_LENGTH EQUAL 3)
      list(GET ARGUMENTS 0 LEFT_VALUE)
      list(GET ARGUMENTS 1 OPERATOR)
      list(GET ARGUMENTS 2 RIGHT_VALUE)

      if(OPERATOR STREQUAL MATCHES)
        if(DEFINED "${LEFT_VALUE}")
          set(LEFT_VALUE "${${LEFT_VALUE}}")
        endif()
        set(MESSAGE "expected string '${LEFT_VALUE}'${NOT_WORD} to match '${RIGHT_VALUE}'")
      elseif(OPERATOR STREQUAL STREQUAL)
        if(DEFINED "${LEFT_VALUE}")
          set(LEFT_VALUE "${${LEFT_VALUE}}")
        endif()
        if(DEFINED "${RIGHT_VALUE}")
          set(RIGHT_VALUE "${${RIGHT_VALUE}}")
        endif()
        set(MESSAGE "expected string '${LEFT_VALUE}'${NOT_WORD} to be equal to '${RIGHT_VALUE}'")
      else()
        string(REPLACE ";" " " ARGUMENTS "${ARGUMENTS}")
        message(FATAL_ERROR "unsupported condition: ${ARGUMENTS}")
      endif()
    elseif(ARGUMENTS_LENGTH GREATER 1)
      string(REPLACE ";" " " ARGUMENTS "${ARGUMENTS}")
      message(FATAL_ERROR "unsupported condition: ${ARGUMENTS}")
    endif()

    if(${ARGUMENT_NOT} ${ARGUMENTS})
      if(DEFINED MESSAGE)
        message(FATAL_ERROR "${MESSAGE}")
      else()
        message(FATAL_ERROR "expected '${ARGUMENTS}' to resolve to${BOOLEAN_WORD}")
      endif()
    endif()
  endif()
endfunction()

# Begins a scope for mocking the 'message' function.
#
# This function begins a scope for mocking the 'message' function by modifying
# its behavior to store the message into a list variable instead of printing it
# to the log.
#
# Use the 'end_mock_message' function to end the scope for mocking the
# 'message' function, reverting it to the original behavior.
function(mock_message)
  set_property(GLOBAL PROPERTY message_mocked ON)

  macro(message MODE MESSAGE)
    get_property(ENABLED GLOBAL PROPERTY message_mocked)
    if("${ENABLED}")
      list(APPEND ${MODE}_MESSAGES "${MESSAGE}")
      set(${MODE}_MESSAGES "${${MODE}_MESSAGES}" PARENT_SCOPE)
      if("${MODE}" STREQUAL FATAL_ERROR)
        return()
      endif()
    else()
      _message("${MODE}" "${MESSAGE}")
    endif()
  endmacro()

  function(mock_message)
    set_property(GLOBAL PROPERTY message_mocked ON)
  endfunction()
endfunction()

# Ends a scope for mocking the 'message' function.
#
# This function ends the scope for mocking the 'message' function, reverting it
# to the original behavior.
function(end_mock_message)
  set_property(GLOBAL PROPERTY message_mocked OFF)
endfunction()

# Asserts whether the 'message' function was called with the expected arguments.
#
# This function asserts whether a message with the specified mode was called
# with the expected message content.
#
# This function can only assert calls to the mocked 'message' function, which is
# enabled by calling the 'mock_message' function.
#
# Arguments:
#   - MODE: The message mode.
#   - EXPECTED_MESSAGE: The expected message content.
function(assert_message MODE EXPECTED_MESSAGE)
  list(POP_FRONT ${MODE}_MESSAGES MESSAGE)
  if(NOT MESSAGE STREQUAL EXPECTED_MESSAGE)
    string(TOLOWER "${MODE}" MODE)
    string(REPLACE "_" " " MODE "${MODE}")
    message(FATAL_ERROR "expected ${MODE} message '${MESSAGE}' to be equal to '${EXPECTED_MESSAGE}'")
  endif()

  if(DEFINED ${MODE}_MESSAGES)
    set(${MODE}_MESSAGES "${${MODE}_MESSAGES}" PARENT_SCOPE)
  endif()
endfunction()

# Asserts whether the given command executes a process.
#
# This function asserts whether the given command successfully executes a
# process. If the `ERROR` argument is specified, this function asserts
# whether the given command fails to execute the process.
#
# Optional arguments:
#   - COMMAND: The command to execute.
#   - OUTPUT: If set, asserts whether the output of the executed process matches
#     the given regular expression.
#   - ERROR: If set, asserts whether the error of the executed process matches
#     the given regular expression.
function(assert_execute_process)
  cmake_parse_arguments(ARG "" "OUTPUT;ERROR" "COMMAND" ${ARGN})

  execute_process(
    COMMAND ${ARG_COMMAND}
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
    ERROR_VARIABLE ERR
  )

  if(DEFINED ARG_ERROR AND RES EQUAL 0)
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected command '${ARG_COMMAND}' to fail"
    )
  elseif(NOT DEFINED ARG_ERROR AND NOT RES EQUAL 0)
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected command '${ARG_COMMAND}' not to fail"
    )
  elseif(DEFINED ARG_OUTPUT AND NOT "${OUT}" MATCHES "${ARG_OUTPUT}")
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected the output of command '${ARG_COMMAND}' to match '${ARG_OUTPUT}'"
    )
  elseif(DEFINED ARG_ERROR AND NOT "${ERR}" MATCHES "${ARG_ERROR}")
    string(REPLACE ";" " " ARG_COMMAND "${ARG_COMMAND}")
    message(
      FATAL_ERROR
      "expected the error of command '${ARG_COMMAND}' to match '${ARG_ERROR}'"
    )
  endif()
endfunction()
