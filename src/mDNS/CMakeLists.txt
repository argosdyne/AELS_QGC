add_library(mDNS STATIC
    mDNSManager.cpp
    mDNSManager.h
)

target_link_libraries(mDNS
    PUBLIC
        src
)

target_include_directories(mDNS
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)
