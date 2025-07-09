cmake_minimum_required(VERSION 3.30)

project(NovelReader VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)
#找到espeak-ng
find_package(PkgConfig REQUIRED)
pkg_check_modules(ESPEAK QUIET espeak-ng)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appNovelReader
    main.cpp
)

qt_add_qml_module(appNovelReader
    URI NovelReader
    VERSION 1.0
    QML_FILES
    NovelReader.qml



SOURCES booklistmanager.cpp booklistmanager.h
        bookmanager.cpp bookmanager.h
        readengin.h readengin.cpp
        configmanager.h configmanager.cpp
        textmanager.h textmanager.cpp
        loadtxt.cpp loadtxt.h
        main.cpp

QML_FILES Shelf.qml Search.qml ShelfMainPage.qml
          Icon.qml Navigator.qml
          ListenMainPage.qml
          User.qml UserMainPage.qml

          ReadControl.qml PageManager.qml
          BottomMenu.qml TopMenu.qml
          BrightBoard.qml
          ContentBoard.qml CoverPage.qml FontBoard.qml
          NoteBoard.qml ProgressBoard.qml

RESOURCES
    img/0.png img/ic_downArrow.png img/ic_editInfo.png img/ic_evlp.png img/ic_import.png
    img/ic_search.png img/ic_select.png img/ic_set.png img/ic_top.png img/litsen.png
    img/onlitsen.png img/onread.png img/onuser.png img/read.png img/user.png
    img/head.jpg img/0.jpg
    img/ic_drtNameLeft.png img/ic_drtNameRight.png img/ic_tip.png
    img/ic_brightness.png img/ic_content.png img/ic_font.png img/ic_note.png
    img/ic_progress.png img/ic_quitRead.png

RESOURCES InitTxt.qrc
SOURCES MacroSet.h
SOURCES
SOURCES
SOURCES bookselector.h bookselector.cpp
SOURCES texttospeech.h texttospeech.cpp
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
    PRIVATE Qt6::Core
)
#包含espeak目录和连接库
if(ESPEAK_FOUND)
    target_include_directories(appNovelReader PRIVATE ${ESPEAK_INCLUDE_DIRS})
    target_link_libraries(appNovelReader PRIVATE ${ESPEAK_LIBRARIES})
    target_compile_definitions(appNovelReader PRIVATE USE_ESPEAK_NG=1)
endif()

include(GNUInstallDirs)
install(TARGETS appNovelReader
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
