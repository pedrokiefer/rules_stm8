# STM8 Rules for [Bazel](https://bazel.build) using [sdcc](http://sdcc.sourceforge.net/)

Some rules for stm8 using sdcc compiler. Inspired on Sergio Campamá [MSP430 rules](https://github.com/sergiocampama/bazel-msp430).

This is a work in progress.

## Rules

* [stm8_library](#stm8_library)
* [stm8_binary](#stm8_binary)

## Setup

```python
git_repository(
    name = "com_github_pedrokiefer_stm8_rules",
    remote = "https://github.com/pedrokiefer/stm8_rules.git",
    tag = "0.0.1",
)

load("@com_github_pedrokiefer_stm8_rules//sdcc:rules.bzl", "sdcc_repositories")

sdcc_repositories()
```

## stm8_library

```python
stm8_library(name, srcs, hdrs, deps, defines, copts)
```

## stm8_binary

```python
stm8_binary(name, deps)
```

