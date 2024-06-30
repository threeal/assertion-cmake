cmake_minimum_required(VERSION 3.5)

find_package(Assertion REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

section("first section")
  assert(CMAKE_MESSAGE_INDENT STREQUAL "  ")

  section("second section")
    assert(CMAKE_MESSAGE_INDENT STREQUAL "  ;  ")
  endsection()

  assert(CMAKE_MESSAGE_INDENT STREQUAL "  ")
endsection()
