vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO AcademySoftwareFoundation/OpenShadingLanguage
    REF v1.14.4.0-beta1
    SHA512 9fdf0e3dcdc6b97643ceddb29ba2b82757ed0c58fc3211410375bbe11142b5735f62f2552896f8db0d2573e9207257e4581eea38bc70d2b20f4fcce0a6d07a38
    HEAD_REF main
    )

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_from_github(
        OUT_SOURCE_PATH FLEX_BISON_SOURCE_PATH
        REPO lexxmark/winflexbison
        REF v2.5.25
        SHA512 7a797d5a1aef21786b4ce8bc8f2a31c4957e55012a4d29b14fbe6d89c1b8ad33e7ab6d1afec6b37ddccd1696dc5b861da568fc8a14d22bb33aa7c1116172d7cf
        )

    vcpkg_execute_build_process(
        COMMAND "buildVS2022.bat" 
        WORKING_DIRECTORY "${FLEX_BISON_SOURCE_PATH}"
        LOGNAME winflexbison_build
        )

    set(BISON_ROOT "${FLEX_BISON_SOURCE_PATH}/bin/Release")
    message(STATUS "BISON_ROOT=${BISON_ROOT}")

    # set(LLVM_VERSION 18.1.8)

    # get_filename_component(PARENT_DIR ${FLEX_BISON_SOURCE_PATH} DIRECTORY)

    # set(LLVM_INSTALL_DIR "${PARENT_DIR}/llvm")
    # set(LLVM_FILE_NAME "clang+llvm-${LLVM_VERSION}-x86_64-pc-windows-msvc")

    # vcpkg_download_distfile(
    #     LLVM_INSTALL_FILE
    #     URLS "https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/${LLVM_FILE_NAME}.tar.xz"
    #     FILENAME "${LLVM_FILE_NAME}.tar.xz"
    #     SHA512 77a1028963f46930ff2208f69614f0eea3f57ad3fb536b198337ec38ada19d2f443eabaa99852787524d227deb2d513ceee5cf468543f2916ad2578deafc7158
    # )

    # if(NOT EXISTS ${LLVM_INSTALL_DIR})
    #     vcpkg_extract_archive(
    #         ARCHIVE ${LLVM_INSTALL_FILE}
    #         DESTINATION ${LLVM_INSTALL_DIR}
    #     )
    # endif()
elseif(VCPKG_TARGET_IS_LINUX)
    vcpkg_find_acquire_program(FLEX)
    vcpkg_find_acquire_program(BISON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DOSL_USE_OPTIX=OFF
        -DUSE_partio=OFF
        -DUSE_PYTHON=OFF
        -DUSE_PYTHON3=OFF
        -DUSE_QT5=OFF
        -DUSE_QT6=OFF
        -DBISON_ROOT="${BISON_ROOT}"
        -DFLEX_ROOT="${BISON_ROOT}"
        # -DLLVM_ROOT="${LLVM_INSTALL_DIR}/${LLVM_FILE_NAME}"
    )

vcpkg_cmake_build()

vcpkg_cmake_install()

vcpkg_copy_pdbs()

file(INSTALL "${CURRENT_PACKAGES_DIR}/cmake/llvm_macros.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(GLOB DEBUG_CMAKE_FILES "${CURRENT_PACKAGE_DIR}/debug/lib/cmake/OSL/OSL*.cmake")
file(GLOB REL_CMAKE_FILES "${CURRENT_PACKAGE_DIR}/lib/cmake/OSL/OSL*.cmake")

file(COPY ${DEBUG_CMAKE_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(COPY ${REL_CMAKE_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_fixup_pkgconfig()