package(default_visibility = ["//visibility:public"])

load("//sdcc:rules.bzl", "stm8_library", "stm8_binary")

stm8_library(
    name = "sample",
    srcs = ["sample.c"]
)

stm8_binary(
    name = "sample_firmware",
    deps = [":sample"],
)
