---
title: "默认为Deny的Lints"
linkTitle: "默认为Deny"
date: 2021-03-29
weight: 346
description: >
  Rustc 默认为Deny的Lints
---

> 英文原文地址： https://doc.rust-lang.org/rustc/lints/listing/deny-by-default.html

默认情况下，这些 lint 都设置为’deny’级别。

### exceeding-bitshifts

此 lint 检测到移位超出了类型的位数。一些触发此 lint 的示例代码：

```rust
1_i32 << 32;
```

这将产生：

```text
error: bitshift exceeds the type's number of bits
 --> src/main.rs:2:5
  |
2 |     1_i32 << 32;
  |     ^^^^^^^^^^^
  |
```

### invalid-type-param-default

此 lint 检测在无效位置中，允许的类型参数默认值错误。一些触发此 lint 的示例代码：

```rust
fn foo<T=i32>(t: T) {}
```

这将产生：

```text
error: defaults for type parameters are only allowed in `struct`, `enum`, `type`, or `trait` definitions.
 --> src/main.rs:4:8
  |
4 | fn foo<T=i32>(t: T) {}
  |        ^
  |
  = note: #[deny(invalid_type_param_default)] on by default
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
  = note: for more information, see issue #36887 <https://github.com/rust-lang/rust/issues/36887>
```

### legacy-constructor-visibility

[RFC 1506](https://github.com/rust-lang/rfcs/blob/master/text/1506-adt-kinds.md)修改了一些可见性规则，并改变了 struct 构造函数的可见性。一些触发此 lint 的示例代码：

```rust
mod m {
    pub struct S(u8);

    fn f() {
        // this is trying to use S from the 'use' line, but because the `u8` is
        // not pub, it is private
        ::S;
    }
}

use m::S;
```

这将产生：

```text
error: private struct constructors are not usable through re-exports in outer modules
 --> src/main.rs:5:9
  |
5 |         ::S;
  |         ^^^
  |
  = note: #[deny(legacy_constructor_visibility)] on by default
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
  = note: for more information, see issue #39207 <https://github.com/rust-lang/rust/issues/39207>
```

### legacy-directory-ownership

发出 `legacy_directory_ownership` 时发出

- 有一个带有`＃[path]`属性的非内联模块（例如`#[path = "foo.rs"]`mod bar;），
- 模块的文件（上例中的“foo.rs”）是未命名为“mod.rs”，并且
- 模块的文件包含一个`＃[path]`属性的非内联模块。

可以通过将父模块重命名为“mod.rs”，并将其移动到其自己的目录（如果合适的话）来修复警告。

[missing-fragment-specifier](http://llever.com/rustc-zh/lints/listing/deny-by-default.zh.html#missing-fragment-specifier)

当一个未使用的`macro_rules!`宏定义模式出现时，会发出 missing_fragment_specifier 警告，因其有一个元变量（例如`$e`）后面没有片段说明符（例如`:expr`）。

通过删除未使用的`macro_rules!`宏定义模式，可以始终修复此警告。

### mutable-transmutes

这种 lint 抓取`&T`到`&mut T`的转化，因为它是未定义的行为。一些触发此 lint 的示例代码：

```rust
unsafe {
    let y = std::mem::transmute::<&i32, &mut i32>(&5);
}
```

这将产生：

```text
error: mutating transmuted &mut T from &T may cause undefined behavior, consider instead using an UnsafeCell
 --> src/main.rs:3:17
  |
3 |         let y = std::mem::transmute::<&i32, &mut i32>(&5);
  |                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  |
```

### no-mangle-const-items

这个 lint 检测到任何带`#[no_mangle]`属性的`const`项。常量确实没有导出符号，因此，这可能意味着您打算使用`static`不是`const`。一些触发此 lint 的示例代码：

```rust
#[no_mangle]
const FOO: i32 = 5;
```

这将产生：

```text
error: const items should never be #[no_mangle]
 --> src/main.rs:3:1
  |
3 | const FOO: i32 = 5;
  | -----^^^^^^^^^^^^^^
  | |
  | help: try a static value: `pub static`
  |
```

### overflowing-literals

此 lint 检测其类型的字面值超出范围。一些触发此 lint 的示例代码：

```rust
let x: u8 = 1000;
```

这将产生：

```text
error: literal out of range for u8
 --> src/main.rs:2:17
  |
2 |     let x: u8 = 1000;
  |                 ^^^^
  |
```

### parenthesized-params-in-types-and-modules

此 lint 检测到不正确的括号。一些触发此 lint 的示例代码：

```rust
let x = 5 as usize();
```

这将产生：

```text
error: parenthesized parameters may only be used with a trait
 --> src/main.rs:2:21
  |
2 |   let x = 5 as usize();
  |                     ^^
  |
  = note: #[deny(parenthesized_params_in_types_and_modules)] on by default
  = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
  = note: for more information, see issue #42238 <https://github.com/rust-lang/rust/issues/42238>
```

要修复它，请删除多个`()`。

### pub-use-of-private-extern-crate

此 lint 检测重新导出一个私有`extern crate`的特定情况;

[safe-extern-statics](http://llever.com/rustc-zh/lints/listing/deny-by-default.zh.html#safe-extern-statics)

在旧版本的 Rust 中，允许`extern static`以安全代码访问，会存在安全问题。这个 lint 现在抓住并否认这种代码。

[unknown-crate-types](http://llever.com/rustc-zh/lints/listing/deny-by-default.zh.html#unknown-crate-types)

此 lint 检测到在一个`#[crate_type]`指示中，发现一个未知箱类型。一些触发此 lint 的示例代码：

```rust
#![crate_type="lol"]
```

这将产生：

```text
error: invalid `crate_type` value
 --> src/lib.rs:1:1
  |
1 | #![crate_type="lol"]
  | ^^^^^^^^^^^^^^^^^^^^
  |
```

### incoherent-fundamental-impls

此 lint 检测到错误允许的潜在冲突的 impl。一些触发此 lint 的示例代码：

```rust
pub trait Trait1<X> {
    type Output;
}

pub trait Trait2<X> {}

pub struct A;

impl<X, T> Trait1<X> for T where T: Trait2<X> {
    type Output = ();
}

impl<X> Trait1<Box<X>> for A {
    type Output = i32;
}
```

这将产生：

```text
error: conflicting implementations of trait `Trait1<std::boxed::Box<_>>` for type `A`: (E0119)
  --> src/main.rs:13:1
   |
9  | impl<X, T> Trait1<X> for T where T: Trait2<X> {
   | --------------------------------------------- first implementation here
...
13 | impl<X> Trait1<Box<X>> for A {
   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ conflicting implementation for `A`
   |
   = note: #[deny(incoherent_fundamental_impls)] on by default
   = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
   = note: for more information, see issue #46205 <https://github.com/rust-lang/rust/issues/46205>
   
```