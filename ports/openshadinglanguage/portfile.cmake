vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO AcademySoftwareFoundation/OpenShadingLanguage
    REF v1.14.4.0-beta1
    SHA512 9fdf0e3dcdc6b97643ceddb29ba2b82757ed0c58fc3211410375bbe11142b5735f62f2552896f8db0d2573e9207257e4581eea38bc70d2b20f4fcce0a6d07a38
    HEAD_REF main
    )

vcpkg_find_acquire_program(FLEX)
vcpkg_find_acquire_program(BISON)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING:BOOL=OFF
        -DOSL_USE_OPTIX:BOOL=OFF
        -DUSE_partio:BOOL=OFF
        -DUSE_PYTHON:BOOL=OFF
    )

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