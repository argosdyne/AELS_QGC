if(WIN32)
    add_definitions(-DWIN32_LEAN_AND_MEAN)
endif()
add_library(HttpService STATIC
    HttpService.cpp
    HttpService.h
)

target_link_libraries(HttpService
    PUBLIC
        src
)

target_include_directories(HttpService
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)

include_directories(../../libs)
