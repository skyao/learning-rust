---
title: "Unsize trait的std文档"
linkTitle: "std文档"
weight: 1322
date: 2021-12-01
description: >
  Unsize trait的std文档
---

https://doc.rust-lang.org/std/marker/trait.Unpin.html

```rust
pub auto trait Unpin { }
```

固定后可以安全移动的类型。

Rust 本身没有固定类型的概念，并认为 move (例如，通过赋值或 `mem::replace` 始终是安全的。

`Pin` 类型代替使用，以防止在类型系统中移动。`Pin<P<T>>` 包装器中包裹的指针 `P<T>` 不能移出。 有关固定的更多信息，请参见 `pin` module 文档。

为 `T` 实现 `Unpin` trait 消除了固定该类型的限制，然后允许使用诸如 [`mem::replace`](../mem/fn.replace.html) 之类的功能将 `T` 从 `Pin<P<T>>` 中移出。

`Unpin` 对于非固定数据完全没有影响。 特别是，[`mem::replace`](../mem/fn.replace.html) 可以愉快地移动 `!Unpin` 数据 (它适用于任何 `&mut T`，而不仅限于 `T: Unpin`)。 但是，您不能对包装在 `Pin<P<T>>`  内的数据使用 [`mem::replace`](../mem/fn.replace.html)，因为您无法获得所需的 `&mut T`，并且 *that* 是使此系统正常工作的原因。

因此，例如，这只能在实现 `Unpin` 的类型上完成:

```rust
use std::mem;
use std::pin::Pin;

let mut string = "this".to_string();
let mut pinned_string = Pin::new(&mut string);

// 我们需要一个可变引用来调用 `mem::replace`。
// 我们可以通过 (implicitly) 调用 `Pin::deref_mut` 来获得这样的引用，但这仅是可能的，因为 `String` 实现了 `Unpin`。
mem::replace(&mut *pinned_string, "other".to_string());
```

trait 几乎针对每种类型自动实现。

