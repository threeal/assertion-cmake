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
  file(DOWNLOAD https://threeal.github.io/assertion-cmake/v0.3.0 ${CMAKE_BINARY_DIR}/Assertion.cmake)
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

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2024 [Alfi Maulana](https://github.com/threeal)
