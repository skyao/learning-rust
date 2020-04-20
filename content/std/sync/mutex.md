---
date: 2019-04-06T16:00:00+08:00
title: Mutex/互斥
menu:
  main:
    parent: "std-sync"
weight: 2035
description : "Rust标准库中的Mutex"
---

https://doc.rust-lang.org/std/sync/struct.Mutex.html

用于保护共享数据的互斥原语

这个mutex将阻止等待锁可用的线程。mutex也可以被静态初始化或通过 new 构造函数创建。每个mutex都有一个 type 参数，表示它所保护的数据。这些数据只能通过 lock 和 try_lock 返回的 RAII 守护来访问，这保证了只有当mutex被锁定时，数据才会被访问。

### 毒化/Poisoning

这个模块中的 mutex 实现了一种叫做 " poisoning "的策略，每当持有 mutex 的线程恐慌时，就会认为 mutex 中毒。一旦 mutex 被毒化，所有其他线程都无法默认访问该数据，因为它很可能被污染了（某些不变性没有被维护）。

对于mutex来说，这意味着 lock 和 try_lock 方法会返回一个Result值，表示mutex是否被毒化。大多数使用mutex的方法都会简单地将这些结果 unwrap()，在线程之间传播恐慌，以确保不会出现可能无效的变量。

然而，被毒化的 mutex 并不会阻止对底层数据的所有访问。PoisonError 类型有一个 into_inner 方法，它将返回在成功锁定时返回的守护。这样，尽管锁被毒化了，但仍然可以访问数据。

### new方法

在解锁状态下创建一个新的mutex，可以随时使用。

```
pub fn new(t: T) -> Mutex<T>

use std::sync::Mutex;

let mutex = Mutex::new(0);
```

### lock方法

获取一个mutex，阻塞当前线程，直到它能够这样做。

这个函数将阻塞本地线程，直到它可以获取mutex为止。返回后，该线程是唯一一个持有锁的线程。返回一个RAII守护，允许范围化解锁。当保护罩超出范围时，mutex将被解锁。

在已经持有锁的线程中锁定一个mutex的确切行为没有说明。但是，这个函数在第二次调用时不会返回（例如，它可能会出现恐慌或死锁）。

### try_lock方法

尝试获取此锁。

如果此时无法获得该锁，则返回Err。否则，将返回一个RAII护卫。当护卫被丢弃时，该锁将被解锁。

此功能不阻塞。









