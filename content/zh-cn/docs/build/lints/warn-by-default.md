---
title: "默认为Warn的Lints"
linkTitle: "默认为Warn"
date: 2021-03-29
weight: 345
description: >
  Rustc 默认为Warn的Lints
---

> 英文原文地址： https://doc.rust-lang.org/rustc/lints/listing/warn-by-default.html

默认情况下，这些 lint 都设置为“警告”级别。

### const-err

该 lint 在进行持续求值时，检测到一个错误的表达。一些触发此 lint 的示例代码：

```rust
let b = 200u8 + 200u8;
```

这将产生：

```text
warning: attempt to add with overflow
 --> src/main.rs:2:9
  |
2 | let b = 200u8 + 200u8;
  |         ^^^^^^^^^^^^^
  |
```

### dead-code

此 lint 检测未使用的，未导出的项。一些触发此 lint 的示例代码：

```rust
fn foo() {}
```

这将产生：

```text
warning: function is never used: `foo`
 --> src/lib.rs:2:1
  |
2 | fn foo() {}
  | ^^^^^^^^
  |
```

### deprecated

此 lint 检测使用已弃用的项目。一些触发此 lint 的示例代码：

```rust
#[deprecated]
fn foo() {}

fn bar() {
    foo();
}
```

这将产生：

```text
warning: use of deprecated item 'foo'
 --> src/lib.rs:7:5
  |
7 |     foo();
  |     ^^^
  |
```

### illegal-floating-point-literal-pattern

此 lint 检测模式中使用的浮点数字面量。一些触发此 lint 的示例代码：

```rust
let x = 42.0;

match x {
    5.0 => {},
    _ => {},
}
```

这将产生：

```text
warning: floating-point literals cannot be used in patterns
 --> src/main.rs:4:9
  |
4 |         5.0 => {},
  |         ^^^
  |
  = note: #[warn(illegal_floating_point_literal_pattern)] on by default
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
  = note: for more information, see issue #41620 <https://github.com/rust-lang/rust/issues/41620>
```

### improper-ctypes

此 lint 检测到外部模块中， libc 类型的正确使用。一些触发此 lint 的示例代码：

```rust
extern "C" {
    static STATIC: String;
}
```

这将产生：

```text
warning: found struct without foreign-function-safe representation annotation in foreign module, consider adding a #[repr(C)] attribute to the type
 --> src/main.rs:2:20
  |
2 |     static STATIC: String;
  |                    ^^^^^^
  |
```

### late-bound-lifetime-arguments

此 lint 使用后绑定生命周期参数，检测路径片段中的泛型生存周期参数。一些触发此 lint 的示例代码：

```rust
struct S;

impl S {
    fn late<'a, 'b>(self, _: &'a u8, _: &'b u8) {}
}

fn main() {
    S.late::<'static>(&0, &0);
}
```

这将产生：

```text
warning: cannot specify lifetime arguments explicitly if late bound lifetime parameters are present
 --> src/main.rs:8:14
  |
4 |     fn late<'a, 'b>(self, _: &'a u8, _: &'b u8) {}
  |             -- the late bound lifetime parameter is introduced here
...
8 |     S.late::<'static>(&0, &0);
  |              ^^^^^^^
  |
  = note: #[warn(late_bound_lifetime_arguments)] on by default
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
  = note: for more information, see issue #42868 <https://github.com/rust-lang/rust/issues/42868>
```

### non-camel-case-types

此 lint 检测没有驼峰形式名称的类型，变体，trait 和类型参数。一些触发此 lint 的示例代码：

```rust
struct s;
```

这将产生：

```text
warning: type `s` should have a camel case name such as `S`
 --> src/main.rs:1:1
  |
1 | struct s;
  | ^^^^^^^^^
  |
```

### non-shorthand-field-patterns

此 lint 检测在一个模式中，使用`Struct { x: x }`能代替`Struct { x }`。一些触发此 lint 的示例代码：

```rust
struct Point {
    x: i32,
    y: i32,
}


fn main() {
    let p = Point {
        x: 5,
        y: 5,
    };

    match p {
        Point { x: x, y: y } => (),
    }
}
```

这将产生：

```text
warning: the `x:` in this pattern is redundant
  --> src/main.rs:14:17
   |
14 |         Point { x: x, y: y } => (),
   |                 --^^
   |                 |
   |                 help: remove this
   |

warning: the `y:` in this pattern is redundant
  --> src/main.rs:14:23
   |
14 |         Point { x: x, y: y } => (),
   |                       --^^
   |                       |
   |                       help: remove this
```

### non-snake-case

此 lint 检测没有蛇形式名称的变量，方法，函数，生命周期参数和模块。一些触发此 lint 的示例代码：

```rust
let X = 5;
```

这将产生：

```text
warning: variable `X` should have a snake case name such as `x`
 --> src/main.rs:2:9
  |
2 |     let X = 5;
  |         ^
  |
```

### non-upper-case-globals

此 lint 检测不大写的静态常量。一些触发此 lint 的示例代码：

```rust
static x: i32 = 5;
```

这将产生：

```text
warning: static variable `x` should have an upper case name such as `X`
 --> src/main.rs:1:1
  |
1 | static x: i32 = 5;
  | ^^^^^^^^^^^^^^^^^^
  |
```

### no-mangle-generic-items

此 lint 检测泛型项必须被修复(mangle)。一些触发此 lint 的示例代码：

```rust
#[no_mangle]
fn foo<T>(t: T) {

}
```

这将产生：

```text
warning: functions generic over types must be mangled
 --> src/main.rs:2:1
  |
1 |   #[no_mangle]
  |   ------------ help: remove this attribute
2 | / fn foo<T>(t: T) {
3 | |
4 | | }
  | |_^
  |
```

### path-statements

此 lint 检测路径语句无效。一些触发此 lint 的示例代码：

```rust
let x = 42;

x;
```

这将产生：

```text
warning: path statement with no effect
 --> src/main.rs:3:5
  |
3 |     x;
  |     ^^
  |
```

### patterns-in-fns-without-body

这个 lint 检测到以前的错误，就是没有body的函数模式。一些触发此 lint 的示例代码：

```rust
trait Trait {
    fn foo(mut arg: u8);
}
```

这将产生：

```text
warning: patterns aren't allowed in methods without bodies
 --> src/main.rs:2:12
  |
2 |     fn foo(mut arg: u8);
  |            ^^^^^^^
  |
  = note: #[warn(patterns_in_fns_without_body)] on by default
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
  = note: for more information, see issue #35203 <https://github.com/rust-lang/rust/issues/35203>
```

要解决此问题，请删除该模式; 它可以在实现中使用，而无需在定义中使用`mut`。那是：

```rust
trait Trait {
    fn foo(arg: u8);
}

impl Trait for i32 {
    fn foo(mut arg: u8) {

    }
}
```

### plugin-as-library

此 lint 检测，当编译器插件用作非插件包中的普通库。一些触发此 lint 的示例代码：

```rust
#![feature(plugin)]
#![plugin(macro_crate_test)]

extern crate macro_crate_test;
```

### private-in-public

此 lint 检测未被旧实现捕获的公有接口中的私有项。一些触发此 lint 的示例代码：

```rust
pub trait Trait {
    type A;
}

pub struct S;

mod foo {
    struct Z;

    impl ::Trait for ::S {
        type A = Z;
    }
}
```

这将产生：

```text
error[E0446]: private type `foo::Z` in public interface
  --> src/main.rs:11:9
   |
11 |         type A = Z;
   |         ^^^^^^^^^^^ can't leak private type
```

### private-no-mangle-fns

此 lint 检测标记`#[no_mangle]`的函数，这也是私有的。鉴于私有函数不公开，并且`#[no_mangle]`控制公有符号，这种组合是错误的。一些触发此 lint 的示例代码：

```rust
#[no_mangle]
fn foo() {}
```

这将产生：

```text
warning: function is marked #[no_mangle], but not exported
 --> src/main.rs:2:1
  |
2 | fn foo() {}
  | -^^^^^^^^^^
  | |
  | help: try making it public: `pub`
  |
```

要解决此问题，请将其公有或删除`#[no_mangle]`。

### private-no-mangle-statics

此 lint 检测到标记`#[no_mangle]`的任何静态是私有的。鉴于私有静态不公开，并且`#[no_mangle]`控制公共符号，这种组合是错误的。一些触发此 lint 的示例代码：

```rust
#[no_mangle]
static X: i32 = 4;
```

这将产生：

```text
warning: static is marked #[no_mangle], but not exported
 --> src/main.rs:2:1
  |
2 | static X: i32 = 4;
  | -^^^^^^^^^^^^^^^^^
  | |
  | help: try making it public: `pub`
  |
```

要解决此问题，请将其公开或删除`#[no_mangle]`。

### renamed-and-removed-lints

此 lint 检测已重命名或删除的 lint。一些触发此 lint 的示例代码：

```rust
#![deny(raw_pointer_derive)]
```

这将产生：

```text
warning: lint raw_pointer_derive has been removed: using derive with raw pointers is ok
 --> src/main.rs:1:9
  |
1 | #![deny(raw_pointer_derive)]
  |         ^^^^^^^^^^^^^^^^^^
  |
```

要解决此问题，请删除 lint 或使用新名称。

### safe-packed-borrows

此 lint 检测借用除 1 之外的压缩对齐结构内部的字段。触发此 lint 的一些示例代码：

```rust
#[repr(packed)]
pub struct Unaligned<T>(pub T);

pub struct Foo {
    start: u8,
    data: Unaligned<u32>,
}

fn main() {
    let x = Foo { start: 0, data: Unaligned(1) };
    let y = &x.data.0;
}
```

这将产生：

```text
warning: borrow of packed field requires unsafe function or block (error E0133)
  --> src/main.rs:11:13
   |
11 |     let y = &x.data.0;
   |             ^^^^^^^^^
   |
   = note: #[warn(safe_packed_borrows)] on by default
   = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
   = note: for more information, see issue #46043 <https://github.com/rust-lang/rust/issues/46043>
```

### stable-features

此 lint 检测`#[feature]`的属性变得稳定了。一些触发此 lint 的示例代码：这将产生：

```rust
#![feature(test_accepted_feature)]
```

要修复，只需删除

```text
warning: this feature has been stable since 1.0.0. Attribute no longer needed
 --> src/main.rs:1:12
  |
1 | #![feature(test_accepted_feature)]
  |            ^^^^^^^^^^^^^^^^^^^^^
  |
```

属性，因为它不再需要。`#![feature]`类型的别名边界

### type-alias-bounds

这 lint 检测类型别名的边界。目前未被执行。一些触发此 lint 的示例代码：

```rust
type SendVec<T: Send> = Vec<T>;
```

这将产生：

```text
warning: type alias is never used: `SendVec`
 --> src/main.rs:1:1
  |
1 | type SendVec<T: Send> = Vec<T>;
  | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  |
```

### tyvar-behind-raw-pointer

此 lint 检测指向一个推断变量的原始指针。一些触发此 lint 的示例代码：

```rust
let data = std::ptr::null();
let _ = &data as *const *const ();

if data.is_null() {}
```

这将产生：

```text
warning: type annotations needed
 --> src/main.rs:4:13
  |
4 |     if data.is_null() {}
  |             ^^^^^^^
  |
  = note: #[warn(tyvar_behind_raw_pointer)] on by default
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in the 2018 edition!
  = note: for more information, see issue #46906 <https://github.com/rust-lang/rust/issues/46906>
```

### unconditional-recursion

此 lint 检测在不调用自身的情况下，无法返回的函数。一些触发此 lint 的示例代码：

```rust
fn foo() {
    foo();
}
```

这将产生：

```text
warning: function cannot return without recursing
 --> src/main.rs:1:1
  |
1 | fn foo() {
  | ^^^^^^^^ cannot return without recursing
2 |     foo();
  |     ----- recursive call site
  |
```

### unions-with-drop-fields

此 lint 检测联合的使用，其包含可能是重要丢弃代码的字段。一些触发此 lint 的示例代码：

```rust
#![feature(untagged_unions)]

union U {
    s: String,
}
```

这将产生：

```text
warning: union contains a field with possibly non-trivial drop code, drop code of union fields is ignored when dropping the union
 --> src/main.rs:4:5
  |
4 |     s: String,
  |     ^^^^^^^^^
  |
```

### unknown-lints

此 lint 检测无法识别的 lint 属性。一些触发此 lint 的示例代码：

```rust
#[allow(not_a_real_lint)]
```

这将产生：

```text
warning: unknown lint: `not_a_real_lint`
 --> src/main.rs:1:10
  |
1 | #![allow(not_a_real_lint)]
  |          ^^^^^^^^^^^^^^^
  |
```

### unreachable-code

此 lint 检测无法访问的代码路径。一些触发此 lint 的示例代码：

```rust
panic!("we never go past here!");

let x = 5;
```

这将产生：

```text
warning: unreachable statement
 --> src/main.rs:4:5
  |
4 |     let x = 5;
  |     ^^^^^^^^^^
  |
```

### unreachable-patterns

此 lint 检测到无法访问的模式。一些触发此 lint 的示例代码：

```rust
let x = 5;
match x {
    y => (),
    5 => (),
}
```

这将产生：

```text
warning: unreachable pattern
 --> src/main.rs:5:5
  |
5 |     5 => (),
  |     ^
  |
```

该`y`模式永远匹配，所以五个是不可能达到的。记住，匹配武器按顺序匹配，你可能想把它`5`上面的案例`y`案件。

[unstable-name-collision](http://llever.com/rustc-zh/lints/listing/warn-by-default.zh.html#unstable-name-collision)

此 lint 检测到您使用了标准库计划在将来添加的名称，这意味着将来如果没有其他类型注释，您的代码可能无法编译。请重命名，或立即添加这些注释。

### unused-allocation

此 lint 检测可以消除的不必要的内存分配。

### unused-assignments

此 lint 检测永远不会读取的内存分配。一些触发此 lint 的示例代码：

```rust
let mut x = 5;
x = 6;
```

这将产生：

```text
warning: value assigned to `x` is never read
 --> src/main.rs:4:5
  |
4 |     x = 6;
  |     ^
  |
```

### unused-attributes

此 lint 检测编译器未使用的属性。一些触发此 lint 的示例代码：

```rust
#![feature(custom_attribute)]

#![mutable_doc]
```

这将产生：

```text
warning: unused attribute
 --> src/main.rs:4:1
  |
4 | #![mutable_doc]
  | ^^^^^^^^^^^^^^^
  |
```

### unused-comparisons

此 lint 检测到所涉及的类型限制使得 比较操作 变得无用。一些触发此 lint 的示例代码：

```rust
fn foo(x: u8) {
    x >= 0;
}
```

这将产生：

```text
warning: comparison is useless due to type limits
 --> src/main.rs:6:5
  |
6 |     x >= 0;
  |     ^^^^^^
  |
```

### unused-doc-comment

此 lint 检测 rustdoc 未使用的 doc 注释。一些触发此 lint 的示例代码：

```rust
/// docs for x
let x = 12;
```

这将产生：

```text
warning: doc comment not used by rustdoc
 --> src/main.rs:2:5
  |
2 |     /// docs for x
  |     ^^^^^^^^^^^^^^
  |
```

### unused-features

此 lint 检测在 crate-level 的`#[feature]`指令 中，找到的未使用或未知功能。要解决此问题，只需删除功能标志即可。

### unused-imports

此 lint 检测从未使用过的导入。一些触发此 lint 的示例代码：

```rust
use std::collections::HashMap;
```

这将产生：

```text
warning: unused import: `std::collections::HashMap`
 --> src/main.rs:1:5
  |
1 | use std::collections::HashMap;
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^
  |
```

### unused-macros

此 lint 检测未使用的宏。一些触发此 lint 的示例代码：

```rust
macro_rules! unused {
    () => {};
}

fn main() {
}
```

这将产生：

```text
warning: unused macro definition
 --> src/main.rs:1:1
  |
1 | / macro_rules! unused {
2 | |     () => {};
3 | | }
  | |_^
  |
```

### unused-must-use

此 lint 检测标记为`＃[must_use]`的类型的未使用结果。一些触发此 lint 的示例代码：

```rust
fn returns_result() -> Result<(), ()> {
    Ok(())
}

fn main() {
    returns_result();
}
```

这将产生：

```text
warning: unused `std::result::Result` that must be used
 --> src/main.rs:6:5
  |
6 |     returns_result();
  |     ^^^^^^^^^^^^^^^^^
  |
```

### unused-mut

此 lint 检测不需要可变的 mut 变量。一些触发此 lint 的示例代码：

```rust
let mut x = 5;
```

这将产生：

```text
warning: variable does not need to be mutable
 --> src/main.rs:2:9
  |
2 |     let mut x = 5;
  |         ----^
  |         |
  |         help: remove this `mut`
  |
```

### unused-parens

这个Lint检测到`if`，`match`，`while`和`return`的括号; 这个括号是不需要的。触发此 lint 的示例代码：

```rust
if(true) {}
```

这将产生：

```text
warning: unnecessary parentheses around `if` condition
 --> src/main.rs:2:7
  |
2 |     if(true) {}
  |       ^^^^^^ help: remove these parentheses
  |
```

### unused-unsafe

这个 lint 检测到不必要的使用`unsafe`块。一些触发此 lint 的示例代码：

```rust
unsafe {}
```

这将产生：

```text
warning: unnecessary `unsafe` block
 --> src/main.rs:2:5
  |
2 |     unsafe {}
  |     ^^^^^^ unnecessary `unsafe` block
  |
```

### unused-variables

此 lint 检测未以任何方式使用的变量。触发此 lint 的示例代码：

```rust
let x = 5;
```

这将产生：

```text
warning: unused variable: `x`
 --> src/main.rs:2:9
  |
2 |     let x = 5;
  |         ^ help: consider using `_x` instead
  |
```

### warnings

这种 lint 有点特别;通过更改其级别，您可以更改每个其他警告，这些警告会对您想要的任何值产生警告：

```rust
#![deny(warnings)]
```

因此，您不会直接在代码中触发此 lint。

### while-true

这个 lint 检测到`while true { }`。一些触发此 lint 的示例代码：

```rust
while true {

}
```

这将产生：

```text
warning: denote infinite loops with `loop { ... }`
 --> src/main.rs:2:5
  |
2 |     while true {
  |     ^^^^^^^^^^ help: use `loop`
  |
```