# We need to modify the Doxyfile slightly.  We'll copy the Doxyfile into the
# build directory, update the location of the source, and then run Doxygen and
# it will generate the documentation into the build directory.

# First, read the Doxyfile in as a variable.
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile" DOXYFILE_CONTENTS)

# Now, modify all the "INPUT" paths.  I've written each of the three out by
# hand.  If more are added, they'll need to be added here too.
string(REPLACE
    "./src/ssmpack"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/ssmpack"
    DOXYFILE_AUXVAR "${DOXYFILE_CONTENTS}"
    )
#message(status ${PROJECT_BINARY_DIR})
string(REPLACE
    "./doc/global"
    "${CMAKE_CURRENT_SOURCE_DIR}/doc/global"
    DOXYFILE_AUXVAR "${DOXYFILE_AUXVAR}"
    )

#string(REPLACE
#    "./doc/tutorials"
#    "${CMAKE_CURRENT_SOURCE_DIR}/doc/tutorials"
#    DOXYFILE_AUXVAR "${DOXYFILE_CONTENTS}"
#    )
#
#string(REPLACE
#    "./doc/policies"
#    "${CMAKE_CURRENT_SOURCE_DIR}/doc/policies"
#    DOXYFILE_CONTENTS "${DOXYFILE_AUXVAR}")
#
# Change the STRIP_FROM_PATH so that it works right even in the build directory;
# otherwise, every file will have the full path in it.
string(REGEX REPLACE
    "(STRIP_FROM_PATH[ ]*=) ./"
    "\\1 ${CMAKE_CURRENT_SOURCE_DIR}/"
    DOXYFILE_AUXVAR ${DOXYFILE_AUXVAR})

# Save the Doxyfile to its new location.
file(WRITE "${DESTDIR}/Doxyfile" "${DOXYFILE_AUXVAR}")
