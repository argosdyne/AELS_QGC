if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
qt_add_resources(RCC_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/lte.qrc
)
else()
qt5_add_big_resources(RCC_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/lte.qrc
)
endif()

add_library(LTE STATIC
    LTEManager.cpp
    LTEManager.h
    LTESettings.cpp
    LTESettings.h
    ${RCC_SOURCES}
)

target_link_libraries(LTE
    src
    ${RCC_SOURCES}
)

target_include_directories(LTE
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)