AC_PREREQ(2.61)

AC_INIT([protobuf-plugin-swift],[1.0],[alexeyxo.gmail.com],[protobuf-plugin-swift])

AC_CONFIG_SRCDIR(plugin/compiler/main.cc)
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])

AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([subdir-objects])

# Check for programs
AC_PROG_CC
AC_PROG_CXX
AC_LANG([C++])

AC_MSG_CHECKING([C++ compiler flags...])
AS_IF([test "x${ac_cv_env_CXXFLAGS_set}" = "x"],[
  # Disable debugging checks by default.
  CXXFLAGS="$CXXFLAGS -DNDEBUG"
  AC_MSG_RESULT([use default: $CXXFLAGS])
],[
  AC_MSG_RESULT([use user-supplied: $CXXFLAGS])
])

LT_INIT

# Check for header files
AC_HEADER_STDC
AC_CHECK_HEADERS([fcntl.h inttypes.h limits.h stdlib.h unistd.h])

# Check for libaries
AC_FUNC_MEMCMP
AC_FUNC_STRTOD
AC_CHECK_FUNCS([ftruncate memset mkdir strchr strerror strtol])

# Locate the protobuf library.
AC_CHECK_HEADER(google/protobuf/stubs/common.h,,
                [AC_MSG_ERROR([
ERROR: protobuf headers are required.

You must either install protobuf from google,
or if you have it installed in a custom location
you must add '-Iincludedir' to CXXFLAGS
and '-Llibdir' to LDFLAGS.

If you did not specify a prefix when installing
protobuf, try
  './configure CXXFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib'
In some 64-bit environments, try LDFLAGS=-L/usr/local/lib64.
])])
pbc_savelibs="$LIBS"
LIBS="$LIBS -lprotoc -lprotobuf -lpthread"
CFLAGS="$CFLAGS -DOBJC_ARC"
AC_LINK_IFELSE(
  [AC_LANG_PROGRAM([[#include <google/protobuf/compiler/command_line_interface.h>]],
                   [[google::protobuf::compiler::CommandLineInterface cli;]])],
                   [],
                   [AC_MSG_ERROR([
ERROR:
protobuf test program failed to link:
perhaps you need to add -Llibdir to your LDFLAGS.])])
LIBS="$pbc_savelibs"

AC_CONFIG_FILES([Makefile plugin/compiler/Makefile])
AC_OUTPUT
