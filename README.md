# Assertion.cmake

A [CMake](https://cmake.org/) module containing a collection of assertion functions for testing purposes.

## Key Features

- Contains a collection of assertion functions for testing purposes.
- Supports asserting fatal error messages.
- Supports asserting process execution.
- Supports separating tests into sections.

## Integration

This module can be integrated into a CMake project in the following ways:

- Manually download the [`Assertion.cmake`](./cmake/Assertion.cmake) file and include it in the CMake project:
  ```cmake
  include(path/to/Assertion.cmake)
  ```
- Use [`file(DOWNLOAD)`](https://cmake.org/cmake/help/latest/command/file.html#download) to automatically download the `Assertion.cmake` file:
  ```cmake
  file(
    DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v0.3.0/Assertion.cmake
      ${CMAKE_BINARY_DIR}/Assertion.cmake
    EXPECTED_MD5 851f49c10934d715df5d0b59c8b8c72a)
  include(${CMAKE_BINARY_DIR}/Assertion.cmake)
  ```
- Use [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) to add this package to the CMake project:
  ```cmake
  cpmaddpackage(gh:threeal/assertion-cmake@0.3.0)
  ```

## Example Usages

This example demonstrates how to use the `assert` function from this module to perform assertions:

```cmake
assert(TRUE)
assert(NOT FALSE)

set(SOME_VARIABLE "some value")

assert(DEFINED SOME_VARIABLE)
assert("${SOME_VARIABLE}" STREQUAL "some value")

assert("some other string" MATCHES "some.*string")

file(TOUCH some_file)

assert(EXISTS some_file)
assert(NOT DIRECTORY some_file)
```

### Assert Fatal Errors

Use the `assert_fatal_error` function to assert whether a call to the given function or macro throws the expected fatal error message:

```cmake
function(some_function)
  message(FATAL_ERROR "some fatal error message")
endfunction()

assert_fatal_error(CALL some_function MESSAGE "some fatal error message")
```

### Assert Process Execution

Use the `assert_execute_process` function to assert whether the given command successfully executed a process:

```cmake
assert_execute_process("${CMAKE_COMMAND}" -E true)
```

This function can also assert the standard output and error of the executed process:

```cmake
assert_execute_process(
  COMMAND "${CMAKE_COMMAND}" -E echo "Hello world!"
  OUTPUT "Hello world!")

assert_execute_process(
  COMMAND "${CMAKE_COMMAND}" invalid-dir
  ERROR "CMake Error: The source directory .* does not exist.")
```

### Separate Tests Into Sections

Use the `section` macro to begin a new test section and end it using the `endsection` macro:

```cmake
section("some section")
  set(SOME_VARIABLE "some value")
  assert(DEFINED SOME_VARIABLE)
endsection()
```

## API Reference

### `ASSERTION_LIST_FILE`

This variable contains the path to the included `Assertion.cmake` module.

### `assertion_add_test`

Adds a new test that processes the given CMake file in script mode.

```cmake
assertion_add_test(<file> [NAME <name>])
```

This function adds a new test that processes the given `<file>` in script mode.
If `NAME` is specified, it will use `<name>` as the test name; otherwise, it
will use `<file>`.

Internally, the test will process the `Assertion.cmake` module in script mode
and include the given `<file>` at the end of the module, allowing variables,
functions, and macros in the `Assertion.cmake` module to be available in the
`<file>` without the need to include the `Assertion.cmake` module from the
`<file>`.

#### Example

```cmake
assertion_add_test(test/first_test.cmake)

assertion_add_test(test/second_test.cmake NAME "Second Test")
```

The above example adds two new tests. The first one is named
`test/first_test.cmake`, which will process the file with the same name as the
test. The second one is named `Second Test`, which will process the
`test/second_test.cmake` file.

### `fail`

Throws a formatted fatal error message.

```cmake
fail(<lines>...)
```

This macro throws a fatal error message formatted from the given `<lines>`.

It formats the message by concatenating all the lines into a single message. If
one of the lines is a variable, it will be expanded and indented by two spaces
before being concatenated with the other lines.

#### Example

```cmake
set(COMMAND "some_command arg0 arg1 arg2")
set(REASON "some reason")

fail("something happened when executing" COMMAND "because of" REASON)
```

The above example throws a fatal error message formatted as follows:

```
something happened when executing:
  some_command arg0 arg1 arg2
because of:
  some reason
```

### `assert`

Asserts the given condition.

```cmake
assert(<condition>...)
```

This function performs an assertion on the given `<condition>`. If the assertion
fails, it will output a formatted fatal error message with information about the
context of the asserted condition.

Refer to the documentation of CMake's
[`if`](https://cmake.org/cmake/help/latest/command/if.html) function for more
information about supported conditions for the assertion.

#### Example

```cmake
assert(DEFINED EXECUTABLE_PATH)
assert(IS_EXECUTABLE "${EXECUTABLE_PATH}")
```

The above example asserts whether the `EXECUTABLE_PATH` variable is defined and
resolves to the path of an executable. If the variable is not defined, it will
throw the following fatal error message:

```
expected variable:
  EXECUTABLE_PATH
to be defined
```

### `assert_fatal_error`

Asserts whether a command call throws a fatal error message.

```cmake
assert_fatal_error(CALL <command> [<arguments>...] MESSAGE <message>...)
```

This function asserts whether a function or macro named `<command>`, called with
the specified `<arguments>`, throws a fatal error message that matches the
expected `<message>`.

If more than one `<message>` string is given, they are concatenated into a
single message with no separator between the strings.

#### Example

```cmake
function(throw_fatal_error MESSAGE)
  message(FATAL_ERROR "${MESSAGE}")
endfunction()

assert_fatal_error(
  CALL throw_fatal_error "some message"
  MESSAGE "some message")
```

The above example asserts whether the call to
`throw_fatal_error("some message")` throws a fatal error message that matches
`some message`. If it somehow does not capture any fatal error message, it will
throw the following fatal error message:

```
expected to receive a fatal error message that matches:
  some message
```

### `assert_execute_process`

Asserts whether the given command correctly executes a process.

```cmake
assert_execute_process(
  [COMMAND] <command> [<arguments>...]
  [OUTPUT <output>...]
  [ERROR <error>...])
```

This function asserts whether the given `<command>` and `<arguments>`
successfully execute a process. If `ERROR` is specified, it instead asserts
whether it fails to execute the process.

If `OUTPUT` is specified, it also asserts whether the output of the executed
process matches the expected `<output>`. If more than one `<output>` string is
given, they are concatenated into a single output with no separator between the
strings.

If `ERROR` is specified, it also asserts whether the error of the executed
process matches the expected `<error>`. If more than one `<error>` string is
given, they are concatenated into a single error with no separator between the
strings.

#### Example

```cmake
assert_execute_process(
  COMMAND ${CMAKE_COMMAND} -E echo hello
  OUTPUT hello)
```

The above example asserts whether the call to `${CMAKE_COMMAND} -E echo hello`
successfully executes a process whose output matches `hello`. If it somehow
fails to execute the process, it will throw the following fatal error message:

```
expected command:
  ${CMAKE_COMMAND} -E echo hello
not to fail with error:
  unknown error
```

### `section`

Begins a new test section.

```cmake
section(<name>...)
```

This function begins a new test section named `<name>`. It prints the test
section name and indents all subsequent messages by two spaces.

If more than one `<name>` string is given, they are concatenated into a single
name with no separator between the strings.

Use the `endsection` function to end the test section.

#### Example

```cmake
section("test something")
  section("it should not fail")
    message(STATUS "nothing happened")
  endsection()

  section("it should fail" " because something might happen")
    fail("something happened")
  endsection()
endsection()
```

The above example begins several test sections. If processed, it will output the
following lines:

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

Copyright © 2024 [Alfi Maulana](https://github.com/threeal)
