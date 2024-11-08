if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
qt_add_resources(RCC_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/teammode.qrc
)
else()
qt5_add_big_resources(RCC_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/teammode.qrc
)
endif()

add_library(TeamMode STATIC
    TeamModeLink.h
    TeamModeLink.cpp
    TeamModeRouter.h
    TeamModeRouter.cpp
    ${RCC_SOURCES}
)

target_link_libraries(TeamMode
    src
    ${RCC_SOURCES}
)

target_include_directories(TeamMode
    INTERFACE
        ${CMAKE_CURRENT_SOURCE_DIR}
)
