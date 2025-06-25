cmake_minimum_required(VERSION 3.30)

project(NovelReader VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appNovelReader
    main.cpp
)

qt_add_qml_module(appNovelReader
    URI NovelReader
    VERSION 1.0
    QML_FILES
    NovelReader.qml
    SOURCES
    QML_FILES
SOURCES
SOURCES booklistmanager.cpp booklistmanager.h bookmanager.cpp bookmanager.h
QML_FILES  Shelf.qml
SOURCES loadtxt.cpp loadtxt.h
QML_FILES Icon.qml Navigator.qml
RESOURCES
QML_FILES Info.qml
RESOURCES img/0.png img/ic_downArrow.png img/ic_editInfo.png img/ic_evlp.png img/ic_import.png img/ic_search.png img/ic_select.png img/ic_set.png img/ic_top.png img/litsen.png img/onlitsen.png img/onread.png img/onuser.png img/read.png img/user.png
QML_FILES
RESOURCES img/head.jpg img/0.jpg
SOURCES
QML_FILES Search.qml
QML_FILES Read.qml
QML_FILES
QML_FILES PageManager.qml
SOURCES readengin.h readengin.cpp
SOURCES configmanager.h configmanager.cpp
RESOURCES
QML_FILES convert.js
SOURCES textmanager.h textmanager.cpp
)

source_group ("QML Files" FILES
    # Read.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appNovelReader PROPERTIES
    AUTORCC true
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appNovelReader
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appNovelReader
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appNovelReader
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
