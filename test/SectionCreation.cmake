section("first section")
  assert(CMAKE_MESSAGE_INDENT STREQUAL "  ")

  section("second section")
    assert(CMAKE_MESSAGE_INDENT STREQUAL "  ;  ")
  endsection()

  assert(CMAKE_MESSAGE_INDENT STREQUAL "  ")

  section("third section with a very very very very very very very very very"
    " very very very very very very very very long title" )
    assert(CMAKE_MESSAGE_INDENT STREQUAL "  ;  ")
  endsection()

  assert(CMAKE_MESSAGE_INDENT STREQUAL "  ")
endsection()
