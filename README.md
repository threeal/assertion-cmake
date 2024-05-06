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

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2024 [Alfi Maulana](https://github.com/threeal)
