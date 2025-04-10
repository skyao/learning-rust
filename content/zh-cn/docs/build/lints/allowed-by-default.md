---
title: "默认为Allow的Lints"
linkTitle: "默认为Allow"
date: 2021-03-29
weight: 344
description: >
  Rustc 默认为Allow的Lints
---

> 英文原文地址： https://doc.rust-lang.org/rustc/lints/listing/allowed-by-default.html

默认情况下，这些 lint 都设置为 allow 级别。因此，除非您使用标志或属性将它们设置为更高的 lint 级别，否则它们将不会显示。

### anonymous-parameters

此 lint 检测匿名参数。一些触发此 lint 的示例代码：

```rust
trait Foo {
    fn foo(usize);
}
```

当设置为’deny’时，这将产生：

```text
error: use of deprecated anonymous parameter
 --> src/lib.rs:5:11
  |
5 |     fn foo(usize);
  |           ^
  |
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
  = note: for more information, see issue #41686 <https://github.com/rust-lang/rust/issues/41686>
```

这种语法大多是历史原因，可以很容易地解决：

```rust
trait Foo {
    fn foo(_: usize);
}
```

### bare-trait-object

这个 lint 暗示对 trait 对象，使用`dyn Trait`。一些触发此 lint 的示例代码：

```rust
#![feature(dyn_trait)]

trait Trait { }

fn takes_trait_object(_: Box<Trait>) {
}
```

当设置为’deny’时，这将产生：

```text
error: trait objects without an explicit `dyn` are deprecated
 --> src/lib.rs:7:30
  |
7 | fn takes_trait_object(_: Box<Trait>) {
  |                              ^^^^^ help: use `dyn`: `dyn Trait`
  |
```

要解决此问题，请按照帮助消息的建议执行操作：

```rust
#![feature(dyn_trait)]
#![deny(bare_trait_objects)]

trait Trait { }

fn takes_trait_object(_: Box<dyn Trait>) {
}
```

### box-pointers

给 Box 类型使用的 lints。一些触发此 lint 的示例代码：

```rust
struct Foo {
    x: Box<isize>,
}
```

当设置为’deny’时，这将产生：

```text
error: type uses owned (Box type) pointers: std::boxed::Box<isize>
 --> src/lib.rs:6:5
  |
6 |     x: Box<isize> //~ ERROR type uses owned
  |     ^^^^^^^^^^^^^
  |
```

这种 lint 主要是历史性的，并不是特别有用。以前，`Box`是用于构建语言，以及进行堆分配的唯一方法。今天的 Rust 可以调用其他分配器等。

### elided-lifetime-in-path

此 lint 检测隐藏生命周期参数的使用。一些触发此 lint 的示例代码：

```rust
struct Foo<'a> {
    x: &'a u32
}

fn foo(x: &Foo) {
}
```

当设置为’deny’时，这将产生：

```text
error: hidden lifetime parameters are deprecated, try `Foo<'_>`
 --> src/lib.rs:5:12
  |
5 | fn foo(x: &Foo) {
  |            ^^^
  |
```

生命周期省略规则隐藏这个生命周期，但是这个被弃用了。

### missing-copy-implementations

这个 lint 检测到可能被遗忘的`Copy`实现。一些触发此 lint 的示例代码：

```rust
pub struct Foo {
    pub field: i32
}
```

当设置为’deny’时，这将产生：

```text
error: type could implement `Copy`; consider adding `impl Copy`
 --> src/main.rs:3:1
  |
3 | / pub struct Foo { //~ ERROR type could implement `Copy`; consider adding `impl Copy`
4 | |     pub field: i32
5 | | }
  | |_^
  |
```

您可以通过派生`Copy`，来修复 lint。

这个 lint 被设置为’allow’，因为这个代码并不坏; 特别是常写一个类似这样的新类型，所以一个`Copy`类型不再是`Copy`（it’s common to write newtypes like this specifically so that a `Copy` type is no longer `Copy`）。

### missing-debug-implementations

此 lint 检测到缺少的`fmt::Debug`实现。一些触发此 lint 的示例代码：

```rust
pub struct Foo;
```

当设置为’deny’时，这将产生：

```text
error: type does not implement `fmt::Debug`; consider adding #[derive(Debug)] or a manual implementation
 --> src/main.rs:3:1
  |
3 | pub struct Foo;
  | ^^^^^^^^^^^^^^^
  |
```

您可以通过派生`Debug`来修复 lint。

### missing-docs

此 lint 检测到公有项的缺乏文档。一些触发此 lint 的示例代码：

```rust
pub fn foo() {}
```

当设置为’deny’时，这将产生：

```text
error: missing documentation for crate
 --> src/main.rs:1:1
  |
1 | / #![deny(missing_docs)]
2 | |
3 | | pub fn foo() {}
4 | |
5 | | fn main() {}
  | |____________^
  |

error: missing documentation for a function
 --> src/main.rs:3:1
  |
3 | pub fn foo() {}
  | ^^^^^^^^^^^^
```

要修复 lint，请为所有项添加文档。

### single-use-lifetime

此 lint 检测仅使用一次的生命周期。一些触发此 lint 的示例代码：

```rust
struct Foo<'x> {
    x: &'x u32
}
```

当设置为’deny’时，这将产生：

```text
error: lifetime name `'x` only used once
 --> src/main.rs:3:12
  |
3 | struct Foo<'x> {
  |            ^^
  |
```

### trivial-casts

这种 lint 可以检测到可以移除的琐碎成本。一些触发此 lint 的示例代码：

```rust
let x: &u32 = &42;
let _ = x as *const u32;
```

当设置为’deny’时，这将产生：

```text
error: trivial cast: `&u32` as `*const u32`. Cast can be replaced by coercion, this might require type ascription or a temporary variable
 --> src/main.rs:5:13
  |
5 |     let _ = x as *const u32;
  |             ^^^^^^^^^^^^^^^
  |
note: lint level defined here
 --> src/main.rs:1:9
  |
1 | #![deny(trivial_casts)]
  |         ^^^^^^^^^^^^^
```

### trivial-numeric-casts

此 lint 检测可以删除的数字类型的简单转换。一些触发此 lint 的示例代码：

```rust
let x = 42i32 as i32;
```

当设置为’deny’时，这将产生：

```text
error: trivial numeric cast: `i32` as `i32`. Cast can be replaced by coercion, this might require type ascription or a temporary variable
 --> src/main.rs:4:13
  |
4 |     let x = 42i32 as i32;
  |             ^^^^^^^^^^^^
  |
```

### unreachable-pub

无法从crate root到达的`pub`项会出发这个lint。一些触发此 lint 的示例代码：

```rust
mod foo {
    pub mod bar {

    }
}
```

当设置为’deny’时，这将产生：

```text
error: unreachable `pub` item
 --> src/main.rs:4:5
  |
4 |     pub mod bar {
  |     ---^^^^^^^^
  |     |
  |     help: consider restricting its visibility: `pub(crate)`
  |
```

### unsafe-code

这种 lint 可以使用`unsafe`码。一些触发此 lint 的示例代码：

```rust
fn main() {
    unsafe {

    }
}
```

当设置为’deny’时，这将产生：

```text
error: usage of an `unsafe` block
 --> src/main.rs:4:5
  |
4 | /     unsafe {
5 | |
6 | |     }
  | |_____^
  |
```

### unstable-features

此 lint 已弃用，不再使用。

### unused-extern-crates

这种 lint 可以检测标记为 `extern crate` 但是从未使用过的情况。一些触发此 lint 的示例代码：

```rust
extern crate semver;
```

当设置为’deny’时，这将产生：

```text
error: unused extern crate
 --> src/main.rs:3:1
  |
3 | extern crate semver;
  | ^^^^^^^^^^^^^^^^^^^^
  |
```

### unused-import-braces

此 lint 捕获导入项目周围，有不必要的括号。一些触发此 lint 的示例代码：

```rust
use test::{A};

pub mod test {
    pub struct A;
}
```

当设置为’deny’时，这将产生：

```text
error: braces around A is unnecessary
 --> src/main.rs:3:1
  |
3 | use test::{A};
  | ^^^^^^^^^^^^^^
  |
```

要解决这个问题，`use test::A;`

### unused-qualifications

此 lint 检测到不必要的限定名称。一些触发此 lint 的示例代码：

```rust
mod foo {
    pub fn bar() {}
}

fn main() {
    use foo::bar;
    foo::bar();
}
```

当设置为’deny’时，这将产生：

```text
error: unnecessary qualification
 --> src/main.rs:9:5
  |
9 |     foo::bar();
  |     ^^^^^^^^
  |
```

你可以直接调用`bar()`，没有`foo::`。

### unused-results

此 lint 检查语句中表达式的未使用结果。一些触发此 lint 的示例代码：

```rust
fn foo<T>() -> T { panic!() }

fn main() {
    foo::<usize>();
}
```

当设置为’deny’时，这将产生：

```text
error: unused result
 --> src/main.rs:6:5
  |
6 |     foo::<usize>();
  |     ^^^^^^^^^^^^^^^
  |
```

### variant-size-differences

此 lint 检测具有各种变量大小的枚举。一些触发此 lint 的示例代码：

```rust
enum En {
    V0(u8),
    VBig([u8; 1024]),
}
```

当设置为’deny’时，这将产生：

```text
error: enum variant is more than three times larger (1024 bytes) than the next largest
 --> src/main.rs:5:5
  |
5 |     VBig([u8; 1024]),   //~ ERROR variant is more than three times larger
  |     ^^^^^^^^^^^^^^^^
  |
```