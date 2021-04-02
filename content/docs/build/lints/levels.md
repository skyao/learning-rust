---
title: "Lints等级"
linkTitle: "Lints等级"
date: 2021-03-29
weight: 342
description: >
  Rustc的Lints等级
---

> 英文原文地址： https://doc.rust-lang.org/rustc/lints/levels.html

在 `rustc` 中，Lints分为四个*级别*：

1. 允许/allow
2. 警告/warn
3. 拒绝/deny
4. 禁止/forbid

每个Lint都有一个默认级别（在本章后面的Lint列表中有解释），编译器有一个默认警告级别。首先，让我们解释这些级别的含义，然后再讨论配置。

### 允许/allow

这些Lints存在，但默认情况下不执行任何操作。例如，考虑以下源代码：

```rust
pub fn foo() {}
```

编译此文件不会产生警告：

```bash
$ rustc lib.rs --crate-type=lib
$
```

但是此代码违反了`missing_docs` lints。

这些Lint主要是通过配置手动打开的，我们将在本节后面讨论。

### 警告/warn

如果违反lint，“警告/warn” Lints等级将产生警告。例如，此代码违反了`unused_variable` lint：

```rust
pub fn foo() {
    let x = 5;
}
```

这将产生以下警告：

```bash
$ rustc lib.rs --crate-type=lib
warning: unused variable: `x`
 --> lib.rs:2:9
  |
2 |     let x = 5;
  |         ^
  |
  = note: `#[warn(unused_variables)]` on by default
  = note: to avoid this warning, consider using `_x` instead
```

### 拒绝/deny

如果违反，“拒绝” lint 将产生错误。例如，此代码导致了 `exceeding_bitshifts` lint。

```rust
fn main() {
    100u8 << 10;
}
$ rustc main.rs
error: bitshift exceeds the type's number of bits
 --> main.rs:2:13
  |
2 |     100u8 << 10;
  |     ^^^^^^^^^^^
  |
  = note: `#[deny(exceeding_bitshifts)]` on by default
```

Lint错误和常规的旧错误有什么区别？Lint可通过级别进行配置，因此，与“允许/allow” Lint相似，默认情况下设置为“拒绝/deny”，则警告/warn 让您允许它们。同样，您可能希望设置一个Lints，`warn` 默认情况下会产生错误。此Lint等级可为您提供。

### 禁止/forbid

“禁止/forbid”是一种特殊的Lint级别，比“拒绝/deny”级别高。与“拒绝/deny”相同的是，在此级别的Lint将产生错误，但是与“拒绝/deny”级别不同，“禁止/forbid”级别不能被覆盖为低于错误的任何值。但是，Lint的水平可能仍会受到限制`--cap-lints` （请参见下文），因此`rustc --cap-lints warn`将使Lint设置为“禁止/forbid”只是警告。

### 配置警告级别

还记得我们`missing_docs`从“允许/allow”Lint级别开始的示例吗？

```bash
$ cat lib.rs
pub fn foo() {}
$ rustc lib.rs --crate-type=lib
$
```

我们可以使用编译器标志以及源代码中的属性来配置该Lint以更高级别运行。

您还可以“限制”Lint，以便编译器可以选择忽略某些Lint级别。我们将在最后讨论。

#### 通过编译器标志

在`-A`，`-W`，`-D`，和`-F`标志让你把一个或多个Lint设置成允许，警告，拒绝或禁止的等级，就像这样：

```bash
$ rustc lib.rs --crate-type=lib -W missing-docs
warning: missing documentation for crate
 --> lib.rs:1:1
  |
1 | pub fn foo() {}
  | ^^^^^^^^^^^^
  |
  = note: requested on the command line with `-W missing-docs`

warning: missing documentation for a function
 --> lib.rs:1:1
  |
1 | pub fn foo() {}
  | ^^^^^^^^^^^^
$ rustc lib.rs --crate-type=lib -D missing-docs
error: missing documentation for crate
 --> lib.rs:1:1
  |
1 | pub fn foo() {}
  | ^^^^^^^^^^^^
  |
  = note: requested on the command line with `-D missing-docs`

error: missing documentation for a function
 --> lib.rs:1:1
  |
1 | pub fn foo() {}
  | ^^^^^^^^^^^^

error: aborting due to 2 previous errors
```

您还可以多次传递每个标志，以更改多个Lint：

```bash
$ rustc lib.rs --crate-type=lib -D missing-docs -D unused-variables
```

当然，您可以将这四个标志混合在一起：

```bash
$ rustc lib.rs --crate-type=lib -D missing-docs -A unused-variables
```

#### 通过属性

还可以使用crate范围的属性修改Lint级别：

```bash
$ cat lib.rs
#![warn(missing_docs)]

pub fn foo() {}
$ rustc lib.rs --crate-type=lib
warning: missing documentation for crate
 --> lib.rs:1:1
  |
1 | / #![warn(missing_docs)]
2 | |
3 | | pub fn foo() {}
  | |_______________^
  |
note: lint level defined here
 --> lib.rs:1:9
  |
1 | #![warn(missing_docs)]
  |         ^^^^^^^^^^^^

warning: missing documentation for a function
 --> lib.rs:3:1
  |
3 | pub fn foo() {}
  | ^^^^^^^^^^^^
```

所有四种等级，`warn`，`allow`，`deny`，和`forbid`，都可以这样工作。

您还可以为每个属性传递多个Lint：

```rust
#![warn(missing_docs, unused_variables)]

pub fn foo() {}
```

并一起使用多个属性：

```rust
#![warn(missing_docs)]
#![deny(unused_variables)]

pub fn foo() {}
```

### 封顶Lint

`rustc` 支持 `--cap-lints LEVEL` 的标志来设置“Lint上限” 。这是所有Lint的最高等级。因此，例如，如果我们从上面的“ deny” lint级别获取代码示例：

```rust
fn main() {
    100u8 << 10;
}
```

然后我们对其进行编译，并为Lint封顶警告：

```bash
$ rustc lib.rs --cap-lints warn
warning: bitshift exceeds the type's number of bits
 --> lib.rs:2:5
  |
2 |     100u8 << 10;
  |     ^^^^^^^^^^^
  |
  = note: `#[warn(exceeding_bitshifts)]` on by default

warning: this expression will panic at run-time
 --> lib.rs:2:5
  |
2 |     100u8 << 10;
  |     ^^^^^^^^^^^ attempt to shift left with overflow
```

现在仅警告，而不是错误。我们可以走得更远，并允许所有Lint：

```bash
$ rustc lib.rs --cap-lints allow
$
```

Cargo大量使用此特性；它会使用 `--cap-lints allow` 以便在编译依赖项时通过，这样，即使它们有任何警告，也不会污染生成的输出。