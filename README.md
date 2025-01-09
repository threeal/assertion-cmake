# Assertion.cmake

A [CMake](https://cmake.org/) module containing a collection of assertion functions and other utilities for testing CMake code.

The main feature of this module is the [`assert`](#assert) function, which asserts the given condition in the style of CMake's [`if`](https://cmake.org/cmake/help/latest/command/if.html) function. If the assertion fails, it throws a fatal error message with information about the context of the asserted condition.

This module also supports [CMake test](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Testing%20With%20CMake%20and%20CTest.html) creation using the [`add_cmake_script_test`](#add_cmake_script_test) function. This function creates a new test that processes a CMake file containing tests in script mode.

## Key Features

- Supports condition, command call, and process execution assertions.
- Supports test creation that processes a CMake file.
- Simple syntax and easy integration.

## Usage Guide

### Module Integration

The recommended way to integrate this module into a project is by downloading it during the project configuration using the [`file(DOWNLOAD)`](https://cmake.org/cmake/help/latest/command/file.html#download) function:

```cmake
file(DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v2.0.0/Assertion.cmake
    ${CMAKE_BINARY_DIR}/cmake/Assertion.cmake
  EXPECTED_MD5 5ebe475aee6fc5660633152f815ce9f6)

include(${CMAKE_BINARY_DIR}/cmake/Assertion.cmake)
```

Alternatively, to support offline mode, this module can also be vendored directly into a project and included normally using the [`include`](https://cmake.org/cmake/help/latest/command/include.html) function.

### Assertion Example

There are three functions provided by this module that can be used to perform assertions in CMake code:

- [`assert`](#assert): Performs an assertion on the given condition.
- [`assert_call`](#assert_call): Performs an assertion on the given command call.
- [`assert_execute_process`](#assert_execute_process): Performs an assertion on a process executed with the given command.

For example, given the following `git_clone` function for cloning a Git repository from the given `URL` and setting the `OUTPUT_VAR` with the path of the cloned Git repository directory:

```cmake
function(git_clone URL OUTPUT_VAR)
  string(REGEX REPLACE ".*/" "" DIRECTORY "${URL}")
  execute_process(COMMAND git clone "${URL}" "${DIRECTORY}" RESULT_VARIABLE RES)
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "failed to clone '${URL}' (${RES})")
  endif()

  set("${OUTPUT_VAR}" "${DIRECTORY}" PARENT_SCOPE)
endfunction()
```

You can create the following assertions to verify if it can successfully clone a Git repository and correctly set the output variable:

```cmake
git_clone(https://github.com/threeal/cmake-starter CMAKE_STARTER_DIR)

assert(DEFINED CMAKE_STARTER_DIR)
assert(EXISTS "${CMAKE_STARTER_DIR}")
```

You can further verify if the output variable contains a correct Git directory and if it correctly throws an error on failure:

```cmake
assert(IS_DIRECTORY "${CMAKE_STARTER_DIR}")
assert_execute_process(
  git -C "${CMAKE_STARTER_DIR}" rev-parse --is-inside-work-tree)

assert_call(git_clone https://invalid.com INVALID_DIR
  EXPECT_ERROR "failed to clone 'https://invalid.com'")
```

### Test Creation

In CMake, tests are normally created using the [`add_test`](https://cmake.org/cmake/help/latest/command/add_test.html) function and run separately from the project configuration and build processes. To simplify test creation, this module provides an [`add_cmake_script_test`](#add_cmake_script_test) function.

Given a file named `test_git_checkout.cmake` that contains assertions for a `git_clone` function, you can create a new test target that will process that file as follows:

```cmake
add_cmake_script_test(test_git_checkout.cmake NAME "Test Git checkout")
```

The above line creates a new test target named "Test Git checkout" that will process the `git_checkout_test.cmake` file in script mode.

## API Reference

### `ASSERTION_VERSION`

This variable contains the version of the included `Assertion.cmake` module.

### `add_cmake_script_test`

Adds a new test that processes the given CMake file in script mode.

```cmake
add_cmake_script_test(
  [FILE] <file> [NAME <name>] [DEFINITIONS <variables>...])
```

This function adds a new test that processes the specified `<file>` in script mode. If `NAME` is provided, `<name>` will be used as the test name; otherwise, the test name will default to `<file>`.

If the `CMAKE_SCRIPT_TEST_DEFINITIONS` variable is defined, the script will be processed with the predefined variables listed in that variable. Each entry should be in the format `<name>=<value>`, where `<name>` is the variable name and `<value>` is its value. If `<value>` is not provided, it uses the value of a variable named `<name>` in the current CMake scope. If `DEFINITIONS` is specified, additional variables will also be defined.

#### Example

```cmake
set(BAR bar)
add_cmake_script_test(test_foo.cmake NAME "Test Foo" DEFINITIONS FOO=foo BAR)
```

The example above adds a new test named `Test Foo`, which processes the `test_foo.cmake` file in script mode with predefined `FOO` and `BAR` variables.

### `fail`

Throws a formatted fatal error message.

```cmake
fail(<lines>...)
```

This macro throws a fatal error message formatted from the given `<lines>`.

It formats the message by concatenating all the lines into a single message. If one of the lines is a variable, it will be expanded and indented by two spaces before being concatenated with the other lines. If the expanded variable is another variable, it will format both the name and the value of the other variable.

#### Example

```cmake
set(COMMAND "cmd arg0 arg1 arg2")
set(REASON "unknown reason")

fail("something happened when executing" COMMAND "because of" REASON)
```

The above example throws a fatal error message formatted as follows:

```
something happened when executing:
  cmd arg0 arg1 arg2
because of:
  unknown reason
```

### `assert`

Performs an assertion on the given condition.

```cmake
assert(<condition>...)
```

This function performs an assertion on the given `<condition>`. If the assertion fails, it will output a formatted fatal error message with information about the context of the asserted condition.

Internally, this function uses CMake's [`if`](https://cmake.org/cmake/help/latest/command/if.html) function to check the given condition and throws a fatal error message if the condition resolves to false. Refer to CMake's `if` function documentation for more information about supported conditions for the assertion.

#### Example

```cmake
assert(DEFINED EXECUTABLE_PATH)
assert(IS_EXECUTABLE "${EXECUTABLE_PATH}")
```

The above example asserts whether the `EXECUTABLE_PATH` variable is defined and resolves to the path of an executable. If the variable is not defined, it will throw the following fatal error message:

```
expected variable:
  EXECUTABLE_PATH
to be defined
```

### `assert_call`

Performs an assertion on the given command call.

```cmake
assert_call(
  [CALL] <command> [<arguments>...]
  [EXPECT_ERROR [MATCHES|STREQUAL] <message>...]
  [EXPECT_WARNING [MATCHES|STREQUAL] <message>...])
```

This function asserts whether the function or macro named `<command>`, called with the specified `<arguments>`, does not receive any errors or warnings. Internally, the function captures all errors and warnings from CMake's [`message`](https://cmake.org/cmake/help/latest/command/message.html) function. Each captured error and warning is concatenated with new lines as separators.

If `EXPECT_ERROR` or `EXPECT_WARNING` is specified, it instead asserts whether the call to the function or macro received errors or warnings that satisfy the expected message.

In both `EXPECT_ERROR` and `EXPECT_WARNING` options, `MATCHES` and `STREQUAL` are used to determine the operator for comparing the received errors and warnings with the expected message. If `MATCHES` is specified, they are compared using regular expression matching. If `STREQUAL` is specified, they are compared lexicographically. If neither is specified, it defaults to `MATCHES`.

If more than one `<message>` string is given, they are concatenated into a single message with no separators.

#### Example

```cmake
function(send_errors)
  foreach(MESSAGE IN LISTS ARGN)
    message(SEND_ERROR "${MESSAGE} error")
  endforeach()
endfunction()

assert_call(
  CALL send_errors first second
  EXPECT_ERROR STREQUAL "first error\nsecond error")
```

The above example asserts whether the call to `send_errors(first second)` receives errors equal to `first error\nsecond error`. If it does not receive any errors, it will throw the following error:

```
expected to receive errors
```

### `assert_execute_process`

Performs an assertion on a process executed with the given command.

```cmake
assert_execute_process(
  [COMMAND] <command> [<arguments>...]
  [EXPECT_FAIL]
  [EXPECT_OUTPUT [MATCHES|STREQUAL] <message>...]
  [EXPECT_ERROR [MATCHES|STREQUAL] <message>...])
```

This function asserts whether the given `<command>` and `<arguments>` successfully execute a process. If `EXPECT_FAIL` or `EXPECT_ERROR` is specified, it asserts that the process fails to execute.

If `EXPECT_OUTPUT` or `EXPECT_ERROR` is specified, it also asserts whether the output or error of the executed process matches the expected message.

In both `EXPECT_OUTPUT` and `EXPECT_ERROR` options, `MATCHES` and `STREQUAL` are used to determine the operator for comparing the received output and error with the expected message. If `MATCHES` is specified, they are compared using regular expression matching. If `STREQUAL` is specified, they are compared lexicographically. If neither is specified, it defaults to `MATCHES`.

If more than one `<message>` string is given, they are concatenated into a single message with no separators.

#### Example

```cmake
assert_execute_process(
  COMMAND ${CMAKE_COMMAND} -E echo hello
  EXPECT_OUTPUT hello)
```

The above example asserts that the call to `${CMAKE_COMMAND} -E echo hello` successfully executes a process whose output is equal to `hello`. If the process fails to execute, it will throw the following fatal error message:

```
expected command:
  /path/to/cmake -E echo hello
not to fail with error:
  unknown error
```

### `section`

Begins a new test section.

```cmake
section(<name>...)
```

This function begins a new test section named `<name>`. It prints the test section name and indents all subsequent messages by two spaces.

If more than one `<name>` string is given, they are concatenated into a single name with no separator between the strings.

Use the [`endsection`](#endsection) function to end the test section.

#### Example

```cmake
section("test something")
  section("it should not fail")
    message(STATUS "nothing happened")
  endsection()

  section("it should fail because something might happen")
    fail("something happened")
  endsection()
endsection()
```

The above example begins several test sections. If processed, it will output the following lines:

```
-- test something
--   it should not fail
--     nothing happened
--   it should fail because something might happen
CMake Error (message):
  something happened
```

### `endsection`

Ends the current test section.

```cmake
endsection()
```

This function ends the current test section.

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2024-2025 [Alfi Maulana](https://github.com/threeal)
