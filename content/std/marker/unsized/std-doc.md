---
title: "Unsize trait的std文档"
linkTitle: "std文档"
weight: 1322
date: 2021-12-01
description: >
  Unsize trait的std文档
---

https://doc.rust-lang.org/std/marker/trait.Unsize.html

```rust
pub trait Unsize<T: ?Sized> {}
```

可以是未定义大小的类型也可以是动态大小的类型。

例如，按大小排列的数组类型 `[i8; 2]` 实现 `Unsize<[i8]>` 和 `Unsize<dyn fmt::Debug>`。

`Unsize` 的所有实现均由编译器自动提供。

`Unsize` 为以下目的实现:

- `[T; N]` 是 `Unsize<[T]>`

- 当`T: Trait` 时 `T` 为 `Unsize<dyn Trait>`

- `Foo<..., T, ...>` 是 `Unsize<Foo<..., U, ...>>`，如果
    - `T: Unsize<U>`
    - Foo 是一个结构体
    - 仅 `Foo` 的最后一个字段具有涉及 `T` 的类型
    - `T` 不属于任何其他字段的类型
    - `Bar<T>: Unsize<Bar<U>>`, 如果 `Foo` 的最后一个字段的类型为 `Bar<T>`

`Unsize` 与 `ops::CoerceUnsized` 一起使用可允许 “user-defined” 容器 (例如 `Rc` 包含动态大小的类型。 有关更多详细信息，请参见 [DST coercion RFC](https://github.com/rust-lang/rfcs/blob/master/text/0982-dst-coercion.md) 和 [the nomicon entry on coercion](https://doc.rust-lang.org/nomicon/coercions.html)。

