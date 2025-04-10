---
title: "Sized trait的std文档"
linkTitle: "std文档"
weight: 1312
date: 2021-12-01
description: >
  Sized trait的std文档
---

https://doc.rust-lang.org/std/marker/trait.Sized.html

```rust
pub trait Sized { }
```

在编译时已知常量大小的类型。

所有类型参数的隐含边界均为 `Sized`。如果不合适，可以使用特殊语法 `?Sized` 删除此绑定。

```rust
struct Foo<T>(T);
struct Bar<T: ?Sized>(T);

// struct FooUse(Foo<[i32]>); // 错误：没有为 [i32] 实现大小调整
struct BarUse(Bar<[i32]>); // OK
```

一个例外是 trait 的隐式 `Self` 类型。 trait 没有隐式 `Sized` 绑定，因为它与 [trait 对象](../../book/ch17-02-trait-objects.html) 不兼容，根据定义，trait 需要与所有可能的实现者一起使用，因此可以为任意大小。

尽管 Rust 允许您将 `Sized` 绑定到 trait，但是以后您将无法使用它来形成 trait 对象:

```rust
trait Foo { }
trait Bar: Sized { }

struct Impl;
impl Foo for Impl { }
impl Bar for Impl { }

let x: &dyn Foo = &Impl;    // OK
// let y: &dyn Bar = &Impl; // 错误：无法将 trait `Bar` 创建成对象
```

> 备注：trait object的要求之一就是trait不能是Sized，这也可以作为禁止将某个trait用作trait object的方式
