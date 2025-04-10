---
type: docs
title: "Rust标准库中的条件变量(Condvar)"
linkTitle: "条件变量(Condvar)"
weight: 340
date: 2021-04-02
description: Rust标准库中的条件变量(Condvar)
---

https://doc.rust-lang.org/std/sync/struct.Condvar.html

条件变量

条件变量代表阻止线程的能力，使其在等待事件发生时不消耗CPU时间。条件变量通常与布尔谓词（一个条件/condition）和mutex关联。在确定线程必须阻止之前，该谓词总是在mutex内部进行验证。

这个模块中的函数将阻止当前线程的执行，并尽可能地绑定到系统提供的条件变量。注意，这个模块对系统条件变量有一个额外的限制：每个condvar在运行时只能使用一个mutex。任何试图在同一个条件变量上使用多个mutexes的行为都会导致运行时的恐慌。如果不希望这样，那么sys中的不安全基元就没有这个限制，但可能会导致未定义的行为。

```rust
use std::sync::{Arc, Mutex, Condvar};
use std::thread;

let pair = Arc::new((Mutex::new(false), Condvar::new()));
let pair2 = pair.clone();

// Inside of our lock, spawn a new thread, and then wait for it to start.
thread::spawn(move|| {
    let (lock, cvar) = &*pair2;
    let mut started = lock.lock().unwrap();
    *started = true;
    // We notify the condvar that the value has changed.
    cvar.notify_one();
});

// Wait for the thread to start up.
let (lock, cvar) = &*pair;
let mut started = lock.lock().unwrap();
while !*started {
    started = cvar.wait(started).unwrap();
}
```

### wait-while方法

阻止当前线程，直到这个条件变量收到通知，并且提供的条件为false。

这个函数将原子化地解锁指定的mutex（用 guard 表示），并阻塞当前线程。这意味着，任何在mutex解锁后逻辑上发生的notify_one或notify_all的调用都是唤醒这个线程的候选函数。当这个函数调用返回时，指定的锁将被重新获得。

```rust
// Wait for the thread to start up.
let (lock, cvar) = &*pair;
// As long as the value inside the `Mutex<bool>` is `true`, we wait.
let _guard = cvar.wait_while(lock.lock().unwrap(), |pending| { *pending }).unwrap();
```