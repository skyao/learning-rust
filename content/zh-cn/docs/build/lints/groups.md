---
title: "Lints分组"
linkTitle: "Lints分组"
date: 2021-03-29
weight: 343
description: >
  Rustc的Lints分组
---

> 备注：翻译自英文原文： https://doc.rust-lang.org/rustc/lints/groups.html

`rustc` 具有“Lint Group”的概念，您可以通过一个名称切换多个警告。

例如，`nonstandard-style`  lint 一次性设置 `non-camel-case-types`， `non-snake-case`以及`non-upper-case-globals`。所以一下是等效的：

```bash
$ rustc -D nonstandard-style
$ rustc -D non-camel-case-types -D non-snake-case -D non-upper-case-globals
```

以下是每个Lint组及其组成的Lint的列表：

| 组                  | 描述                               | 棉绒                                                         |
| ------------------- | ---------------------------------- | ------------------------------------------------------------ |
| nonstandard-style   | 违反标准命名约定                   | 非驼峰式，非蛇形，非大写全局<br />non-camel-case-types, non-snake-case, non-upper-case-globals |
| warnings            | 发出警告的所有Lint                 | 发出警告的所有Lint                                           |
| 2018版              | 在Rust 2018中将变成错误的Lint      | tyvar-behind-raw-pointer                                     |
| rust-2018-idioms    | 推动您朝Rust 2018的惯例前进的Lint  | bare-trait-object, unreachable-pub                           |
| unused              | 检测到已声明但未使用的事物的Lint   | unused-imports, unused-variables, unused-assignments, dead-code, unused-mut, unreachable-code, unreachable-patterns, unused-must-use, unused-unsafe, path-statements, unused-attributes, unused-macros, unused-allocation, unused-doc-comment, unused-extern-crates, unused-features, unused-parens |
| future-incompatible | 检测到代码具有未来兼容性问题的Lint | private-in-public, pub-use-of-private-extern-crate, patterns-in-fns-without-body, safe-extern-statics, invalid-type-param-default, legacy-directory-ownership, legacy-imports, legacy-constructor-visibility, missing-fragment-specifier, illegal-floating-point-literal-pattern, anonymous-parameters, parenthesized-params-in-types-and-modules, late-bound-lifetime-arguments, safe-packed-borrows, tyvar-behind-raw-pointer, unstable-name-collision |

此外，还有一个`bad-style` Lint Group，它是 `nonstandard-style` 的别名，但已经不推荐使用。

最后，您还可以通过调用来查看上表`rustc -W help`。这将为您已安装的特定编译器提供确切值。