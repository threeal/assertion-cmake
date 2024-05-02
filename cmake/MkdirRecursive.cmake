include_guard(GLOBAL)

function(mkdir_recursive DIR_PATH)
  file(MAKE_DIRECTORY "${DIR_PATH}")
endfunction()
