# Assertion.cmake

A [CMake](https://cmake.org/) module containing a collection of assertion functions for testing purposes.

## Key Features

- Contains a collection of assertion functions for testing purposes.
- Supports mocking and asserting the `message` function.

## Integration

This module can be integrated into a CMake project in the following ways:

- Manually download the [`Assertion.cmake`](./cmake/Assertion.cmake) file and include it in the CMake project:
  ```cmake
  include(path/to/Assertion.cmake)
  ```
- Use [`file(DOWNLOAD)`](https://cmake.org/cmake/help/latest/command/file.html#download) to automatically download the `Assertion.cmake` file:
  ```cmake
  file(
    DOWNLOAD https://threeal.github.io/assertion-cmake/v0.1.0
    ${CMAKE_BINARY_DIR}/Assertion.cmake
  )
  include(${CMAKE_BINARY_DIR}/Assertion.cmake)
  ```
- Use [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) to add this package to the CMake project:
  ```cmake
  cpmaddpackage(gh:threeal/assertion-cmake@0.1.0)
  include(${Assertion_SOURCE_DIR}/cmake/Assertion.cmake)
  ```

## Example Usages

This example demonstrates how to use functions from this module to perform assertions:

```cmake
assert_true(TRUE)
assert_false(FALSE)

set(SOME_VARIABLE "some value")

assert_defined(SOME_VARIABLE)
assert_strequal("${SOME_VALUE}" "some value")

file(TOUCH some-file)

assert_exists(some-file)
assert_not_directory(some-file)
```

### Mock and Assert Messages

Use the `mock_message` function to mock the `message` function, allowing assertions on the `message` function as shown in the following example:

```cmake
mock_message()
  message(STATUS "some status message")
  message(ERROR "some error message")
end_mock_message()

assert_message(STATUS "some status message")
assert_message(ERROR "some error message")
```

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2024 [Alfi Maulana](https://github.com/threeal)
