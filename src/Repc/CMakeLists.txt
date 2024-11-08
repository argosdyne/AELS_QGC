find_package(Qt${QT_VERSION_MAJOR} COMPONENTS RemoteObjects REQUIRED)

add_library(Repc
	${QT_QM_REP_SRC}
	DynamicRepcManager.h
	DynamicRepcManager.cpp
)

target_link_libraries(Repc
    PUBLIC
        src
        Qt${QT_VERSION_MAJOR}::RemoteObjects
)

target_include_directories(Repc PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
