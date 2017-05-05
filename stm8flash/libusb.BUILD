package(default_visibility = ["//visibility:public"])

genrule(
    name = "config_h",
    outs = ["config.h"],
    cmd = """
cat > $@ <<"EOF"
#define DEFAULT_VISIBILITY __attribute__((visibility("default")))
#define ENABLE_LOGGING 1
#define HAVE_DLFCN_H 1
#define HAVE_GETTIMEOFDAY 1
#define HAVE_INTTYPES_H 1
#define HAVE_LIBUDEV 1
#define HAVE_LIBUDEV_H 1
#define HAVE_MEMORY_H 1
#define HAVE_POLL_H 1
#define HAVE_SIGNAL_H 1
#define HAVE_STDINT_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
#define HAVE_STRUCT_TIMESPEC 1
#define HAVE_SYSLOG_FUNC 1
#define HAVE_SYSLOG_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_TIME_H 1
#define HAVE_SYS_TYPES_H 1
#define HAVE_UNISTD_H 1

#define OS_LINUX 1

#define PACKAGE "libusb"
#define PACKAGE_BUGREPORT "libusb-devel@lists.sourceforge.net"
#define PACKAGE_NAME "libusb"
#define PACKAGE_STRING "libusb 1.0.21"
#define PACKAGE_TARNAME "libusb"
#define PACKAGE_URL "http://libusb.info"
#define PACKAGE_VERSION "1.0.21"
#define POLL_NFDS_TYPE nfds_t
#define STDC_HEADERS 1
#define THREADS_POSIX 1
#define USBI_TIMERFD_AVAILABLE 1
#define USE_UDEV 1
#define VERSION "1.0.21"
#define _GNU_SOURCE 1
EOF""",
)

cc_library(
    name = "libusb_config",
    hdrs = [":config_h"],
    includes = ["./"],
)

cc_library(
    name = "libusb",
    srcs = [
        "libusb/core.c",
        "libusb/descriptor.c",
        "libusb/hotplug.c",
        "libusb/hotplug.h",
        "libusb/io.c",
        "libusb/libusbi.h",
        "libusb/os/linux_udev.c",
        "libusb/os/linux_usbfs.c",
        "libusb/os/linux_usbfs.h",
        "libusb/os/poll_posix.c",
        "libusb/os/poll_posix.h",
        "libusb/os/threads_posix.c",
        "libusb/os/threads_posix.h",
        "libusb/strerror.c",
        "libusb/sync.c",
        "libusb/version.h",
        "libusb/version_nano.h",
    ],
    hdrs = [
        "libusb/libusb.h",
    ],
    linkopts = ["-ludev", "-pthread"],
    includes = ["libusb"],
    strip_include_prefix = "libusb",
    deps = [
        ":libusb_config",
    ],
)
