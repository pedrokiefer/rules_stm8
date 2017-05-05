# STM8 Rules for [Bazel](https://bazel.build) using [sdcc](http://sdcc.sourceforge.net/)

Some rules for stm8 using sdcc compiler. Inspired on Sergio Campamá [MSP430 rules](https://github.com/sergiocampama/bazel-msp430).

This is a work in progress.

## Rules

* [stm8_library](#stm8_library)
* [stm8_binary](#stm8_binary)

## Setup

On your `WORKSPACE` file add this:

```python
git_repository(
    name = "com_github_pedrokiefer_rules_stm8",
    remote = "https://github.com/pedrokiefer/rules_stm8.git",
    tag = "0.0.1",
)

load("@com_github_pedrokiefer_rules_stm8//sdcc:rules.bzl", "sdcc_repositories")

sdcc_repositories()
```

On your BUILD use something like this:

```python
load("@com_github_pedrokiefer_rules_stm8//sdcc:rules.bzl", "stm8_library", "stm8_binary")

stm8_library(
    name = "lib",
    srcs = ["some_source.c", "main.c"]
)

stm8_binary(
    name = "firmware",
    deps = [":lib"],
)
```

## stm8_library

```python
stm8_library(name, srcs, hdrs, deps, defines, copts)
```

## stm8_binary

```python
stm8_binary(name, deps)
```

## stm8flash tool

You can build the stm8flash tool. Needed system dependency: libudev - on ubuntu that's libudev-dev

On your `WORKSPACE` file, add this:

```python
load("@com_github_pedrokiefer_rules_stm8//stm8flash:rules.bzl", "stm8flash_repositories")

stm8flash_repositories()
```

```shell
bazel build @com_github_vdudouyt_stm8flash//:stm8flash
```

