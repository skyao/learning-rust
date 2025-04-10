---
title: "Sync trait的std文档"
linkTitle: "std文档"
weight: 1352
date: 2021-12-01
description: >
  Sync trait的std文档
---

https://doc.rust-lang.org/std/marker/trait.Sync.html

```rust
pub unsafe auto trait Sync { }
```

可以在线程之间安全共享引用的类型。

当编译器确定适当时，会自动实现此 trait。

精确的定义是：当且仅当 `&T` 是 [`Send`](trait.Send.html) 时，类型 `T` 才是 [`Sync`](trait.Sync.html)。 换句话说，如果在线程之间传递 `&T` 引用时没有 [未定义的行为](../../reference/behavior-considered-undefined.html) (包括数据竞争) 的可能性。

正如人们所料，像 [`u8`](../primitive.u8.html) 和 [`f64`](../primitive.f64.html) 这样的原始类型都是 [`Sync`](trait.Sync.html)，包含它们的简单聚合类型也是如此，比如元组、结构体和枚举。 基本 [`Sync`](trait.Sync.html) 类型的更多示例包括不可变类型 (例如 `&T`) 以及具有简单继承的可变性的类型，例如 [`Box`](../../std/boxed/struct.Box.html)，[`Vec`](../../std/vec/struct.Vec.html) 和大多数其他集合类型。

(泛型参数必须为 [`Sync`](trait.Sync.html)，容器才能 [[Sync](trait.Sync.html)]。)

该定义的一个令人惊讶的结果是 `&mut T` 是 `Sync` (如果 `T` 是 `Sync`)，即使看起来可能提供了不同步的可变的。 诀窍是，共享引用 (即 `& &mut T`) 后面的可变引用将变为只读，就好像它是 `& &T` 一样。 因此，没有数据竞争的风险。

不是 `Sync` 的类型是具有非线程安全形式的 “内部可变性” 的类型，例如 [`Cell`](../cell/struct.Cell.html) 和 [`RefCell`](../cell/struct.RefCell.html)。 这些类型甚至允许通过不可变，共享引用来更改其内容。 例如，[`Cell`](../cell/struct.Cell.html) 上的 `set` 方法采用 `&self`，因此它仅需要共享的引用 [`&Cell`](../cell/struct.Cell.html)。 该方法不执行同步，因此 [`Cell`](../cell/struct.Cell.html) 不能为 `Sync`。

另一个非 `Sync` 类型的例子是引用计数指针 [`Rc`](../../std/rc/struct.Rc.html)。 给定任何引用 [`&Rc`](../../std/rc/struct.Rc.html)，您可以克隆新的 [`Rc`](../../std/rc/struct.Rc.html)，以非原子方式修改引用计数。

对于确实需要线程安全的内部可变性的情况，Rust 提供 [原子数据类型](../sync/atomic/index.html) 以及通过 [`sync::Mutex`](../../std/sync/struct.Mutex.html) 和 [`sync::RwLock`](../../std/sync/struct.RwLock.html) 进行的显式锁定。 这些类型可确保任何可变的都不会引起数据竞争，因此类型为 `Sync`。 同样，[`sync::Arc`](../../std/sync/struct.Arc.html) 提供了 [`Rc`](../../std/rc/struct.Rc.html) 的线程安全模拟。

任何具有内部可变性的类型还必须在 value(s) 周围使用 [`cell::UnsafeCell`](../cell/struct.UnsafeCell.html) 包装器，该包装器可以通过共享的引用进行更改。 [未定义的行为](../../reference/behavior-considered-undefined.html) 无法做到这一点。 例如，从 `&T` 到 `&mut T` 的 [`transmute`](../mem/fn.transmute.html) 无效。

有关 `Sync` 的更多详细信息，请参见 [the Nomicon](https://doc.rust-lang.org/nomicon/send-and-sync.html)。

