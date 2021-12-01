---
title: "[Rust编程之道笔记]Send trait"
linkTitle: "[Rust编程之道笔记]"
weight: 1344
date: 2021-12-01
description: >
  Rust编程之道一书 3.4.4 标签trait 
---

rust 提供了 Send 和 Sync 两个标签 trait，他们是 rust 无数据竞争并发的基石。

- 实现了 Send 的类型，可以安全的在线程间传递值，也就是说可以跨线程传递所有权
- 实现了 Sync 的类型，可以跨线程安全地传递共享（不可变）引用

有了这两个标签，就可以把rust中所有的类型归为两类：

1. 可以安全跨线程传递的值和引用
2. 不可以安全跨线程传递的值和引用

在配合所有权机制，带来的效果就是，rust 能够在编译期就检查出数据竞争的隐患，而不需要到运行时再排查。



```rust
# 备注：这行代码在 marker.rs 中已经找不到了，不知道
# 为所有类型实现 Send
unsafe impl Send for .. {}

#[stable(feature = "rust1", since = "1.0.0")]
# 使用 !Send 语法排除  *const T 和 *mut T
impl<T: ?Sized> !Send for *const T {}
#[stable(feature = "rust1", since = "1.0.0")]
impl<T: ?Sized> !Send for *mut T {}
```











