find_package(Qt${QT_VERSION_MAJOR} COMPONENTS AndroidExtras REQUIRED)

include_directories(${Qt${QT_VERSION_MAJOR}Quick_PRIVATE_INCLUDE_DIRS})

add_library(qtandroidserialport
	src/qserialport.cpp
	src/qserialport_android.cpp
	src/qserialportinfo.cpp
	src/qserialportinfo_android.cpp
)

target_link_libraries(qtandroidserialport
		src
		Qt${QT_VERSION_MAJOR}::AndroidExtras
)

target_include_directories(qtandroidserialport INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/src)
