---
date: 2019-04-06T16:00:00+08:00
title: Thread
menu:
  main:
    parent: "std"
weight: 2051
description : "Rust标准库中的Thread"
---

https://doc.rust-lang.org/std/thread/index.html

原生线程。

### 线程模式

一个正在执行的Rust程序由一系列原生操作系统线程组成，每个线程都有自己的堆栈和本地状态。线程可以被命名，并提供一些内置的低级同步支持。

线程之间的通信可以通过通道、Rust的消息传递类型以及其他形式的线程同步和共享内存数据结构来完成。特别是，那些被保证为线程安全的类型可以很容易地在线程之间使用原子引用计数容器Arc来共享。

Rust中的致命逻辑错误会导致线程恐慌，在这一过程中，线程会解开堆栈，运行解析器并释放拥有的资源。虽然Rust中的恐慌并不是作为 "try/catch"机制，但是，Rust中的恐慌还是可以通过catch_unwind来捕获（除非在编译时使用panic=abort）并恢复，或者用 resume_unwind 来恢复。如果 panic没有被捕获，线程就会退出，但是可以选择从不同的线程中用 join 检测到 panic。如果主线程在没有捕获到恐慌的情况下发生恐慌，应用程序将以非零退出代码退出。

当Rust程序的主线程终止时，即使其他线程还在运行，整个程序也会关闭。但是，这个模块提供了方便的设施，可以自动等待子线程的终止（即join）。

### 生成线程

可以使用 thread:::spawn 函数生成一个新的线程。

```rust
use std::thread;

thread::spawn(move || {
    // some work here
});
```

在这个例子中，生成的线程是与当前线程 "分离 "的。这意味着它可以超过它的父线程（产生它的线程），除非这个父线程是主线程。

父线程也可以等待子线程的完成；调用 spawn 会产生 JoinHandle，它提供了一个用于等待的 join 方法。

```rust
use std::thread;

let child = thread::spawn(move || {
    // some work here
});
// some work here
let res = child.join();
```

join方法返回 thread::Result ，其中包含子线程产生的最终值Ok，如果子线程 panic ，则返回给调用 panic! 的 Err 的值。

### 配置线程

新的线程可以通过 Builder 类型在产生新的线程之前进行配置，目前可以设置子线程的名称和堆栈大小。

```rust
use std::thread;

thread::Builder::new().name("child1".to_string()).spawn(move || {
    println!("Hello, world!");
});
```

### 线程类型

线程是通过线程类型来表示的，你可以通过两种方式之一来获得。

- 通过生成一个新的线程，例如，使用 thread::spawn 函数，并在 JoinHandle上调用 thread。
- 通过使用 thread::current 函数请求当前线程。

Thread::current 函数即使对于不是通过这个模块的API产生的线程也可以使用。

### thread-local存储

这个模块还为Rust程序提供了 thread-local 存储的实现。线程本地存储是一种将数据存储到全局变量中的方法，程序中的每个线程都有自己的副本。线程不共享这个数据，所以访问不需要同步。

线程-本地键拥有它所包含的值，当线程退出时，将销毁该值。它是用 thread_local! 宏创建的，可以包含任何 `'static`  的值（没有借用指针）。它提供了一个访问器函数 with，可以产生一个共享引用到指定的闭包的值。线程本地键只允许对值进行共享访问，因为如果容许可变借用，就没有办法保证唯一性。大多数值都希望通过Cell或RefCell类型利用某种形式的内部可变性。

### 命名线程

线程可以有相关的名称，以便于识别。默认情况下，生成的线程是不命名的。要指定一个线程的名称，用Builder构建线程，并将所需的线程名称传递给 Builder::name。要从线程中获取线程名称，使用Thread::name。几个例子说明了线程名称被使用的情况。

- 如果在一个已命名的线程中发生恐慌，线程名称将被打印在恐慌消息中。
- 线程的名字会被提供给操作系统（例如，在unix-like平台上的pthread_setname_np）。

### 栈的大小

产生线程的默认堆栈大小为 2 MiB，但这个特定的堆栈大小将来可能会改变。有两种方法可以手动指定生成线程的堆栈大小。

- 用Builder构建线程，并将所需的堆栈大小传递给 Builder::stack_size。
- 将 RUST_MIN_STACK 环境变量设置为代表所需堆栈大小的整数（单位为字节）。注意，设置Builder::stack_size将覆盖这个值。

注意，主线程的堆栈大小不是由Rust决定的。

