---
type: docs
title: "Rust标准库中的原子引用计数(Arc)"
linkTitle: "原子引用计数(Arc)"
weight: 320
date: 2021-04-02
description: Rust标准库中的原子引用计数(Arc)
---

https://doc.rust-lang.org/std/sync/struct.Arc.html

线程安全的引用计数指针。'Arc'代表 "Atomically Reference Counted/原子引用计数"。

类型 Arc<T> 提供了一个 T 类型值的共享所有权，在堆中分配。在Arc上调用clone会产生一个新的Arc实例，它指向与源Arc相同的堆上的分配值，同时增加一个引用计数。当给定分配的最后一个Arc指针被销毁时，存储在该分配中的值（通常被称为 "内部值"）也会被丢弃。

Rust中的共享引用默认不允许改变，Arc也不例外：一般情况下，你无法获得Arc内部的东西的可变引用。如果你需要通过Arc进行改变，请使用Mutex、RwLock或Atomic类型。

### 线程安全

与 Rc<T> 不同的是，Arc<T>使用原子操作进行引用计数。这意味着它是线程安全的。缺点是，原子操作比普通内存访问更昂贵。如果你不在线程之间共享引用计数的分配，可以考虑使用Rc<T>来降低开销。Rc<T>是一个安全的默认值，因为编译器会捕捉到任何线程之间发送Rc<T>的尝试。但是，为了给库的用户提供更多的灵活性，库可能会选择Arc<T>。

只要T实现了Send和Sync，Arc<T>就会实现Send和Sync。为什么不能把一个非线程安全类型的T放在Arc<T>中，使其成为线程安全的呢？一开始可能会觉得有点反直觉：毕竟Arc<T>的重点不就是线程安全吗？关键是这样的。Arc<T>使同一数据有多个所有权的线程安全，但它并没有给它的数据增加线程安全。考虑一下 `Arc<RefCell<T>>`。RefCell<T>不是Sync，如果Arc<T>总是Send，那么`Arc<RefCell<T>`也会是Send。但这样一来，我们就有问题了。RefCell<T>不是线程安全的；它使用非原子操作来跟踪借数。

最后，这意味着你可能需要将Arc<T>与某种类型的std:::同步类型配对，通常是Mutex<T>。

### 用 weak 打破循环

downgrade方法可以用来创建一个无主的Weak指针。Weak指针可以升级为Arc，但是如果存储在分配中的值已经被降级，则会返回None。换句话说，Weak指针不会使分配中的值保持活的，但是，它们会使分配（值的后备存储）保持活的。

Arc指针之间的循环永远不会被dealocated。基于这个原因，Weak被用来打破循环。例如，一棵树可以有从父节点到子节点的强Arc指针，而从子节点回到父节点的弱指针。