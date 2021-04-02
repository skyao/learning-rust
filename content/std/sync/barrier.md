---
type: docs
title: "Rust标准库中的屏障(Barrier)"
linkTitle: "屏障(Barrier)"
weight: 330
date: 2021-04-02
description: Rust标准库中的屏障(Barrier)
---

https://doc.rust-lang.org/std/sync/struct.Barrier.html

Barrier/屏障可以让多个线程同步开始某些计算。

```rust
use std::sync::{Arc, Barrier};
use std::thread;

let mut handles = Vec::with_capacity(10);
let barrier = Arc::new(Barrier::new(10));
for _ in 0..10 {
    let c = barrier.clone();
    // The same messages will be printed together.
    // You will NOT see any interleaving.
    handles.push(thread::spawn(move|| {
        println!("before wait");
        c.wait();
        println!("after wait");
    }));
}
// Wait for other threads to finish.
for handle in handles {
    handle.join().unwrap();
}
```

### new 方法

```rust
use std::sync::Barrier;

let barrier = Barrier::new(10);
```

创建一个新的屏障，可以阻止给定数量的线程。

屏障将阻止n-1个线程调用等待，然后当第n个线程调用等待时，立即唤醒所有线程。

### wait 方法

屏蔽当前线程，直到所有线程在这里会合。

Barrier在所有线程会合后可以重复使用，并且可以连续使用。

单个（任意）线程在从这个函数返回时，会收到一个 is_leader返回 true 的 BarrierWaitResult，其他所有线程都会收到is_leader返回false的结果。



