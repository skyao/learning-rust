---
title: "Send trait的std文档"
linkTitle: "std文档"
weight: 1342
date: 2021-12-01
description: >
  Send trait的std文档
---

https://doc.rust-lang.org/std/marker/trait.Send.html

```rust
pub unsafe auto trait Send { }
```

可以跨线程边界传输的类型。

当编译器确定适当时，会自动实现此 trait。

非 `Send` 类型的一个示例是引用计数指针 [`rc::Rc`](../../std/rc/struct.Rc.html)。 如果两个线程试图克隆指向相同引用计数值的 [`Rc`](../../std/rc/struct.Rc.html)，它们可能会同时尝试更新引用计数，这是 [未定义行为](../../reference/behavior-considered-undefined.html) 因为 [`Rc`](../../std/rc/struct.Rc.html) 不使用原子操作。

它的表亲 [`sync::Arc`](../../std/sync/struct.Arc.html) 确实使用原子操作 (产生一些开销)，因此它是 `Send`。

有关更多详细信息，请参见 [the Nomicon](https://doc.rust-lang.org/nomicon/send-and-sync.html)。

