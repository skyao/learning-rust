---
date: 2019-04-06T16:00:00+08:00
title: Boxed
menu:
  main:
    parent: "std"
weight: 2052
description : "Rust标准库中的Boxed"
---

https://doc.rust-lang.org/std/boxed/index.html

用于堆分配的指针类型。

Box<T>，被随意称为 "box"，在Rust中提供了最简单的堆分配形式。Box为这个分配提供了所有权，当它们超出范围时，会丢弃它们的内容。

### 例子

通过创建Box，将值从栈中移动到堆中：

```rust
let val: u8 = 5;
let boxed: Box<u8> = Box::new(val);
```

通过取消引用（[dereferencing](https://doc.rust-lang.org/std/ops/trait.Deref.html)）将值从Box中移回栈中：

```rust
let boxed: Box<u8> = Box::new(5);
let val: u8 = *boxed;
```

创建一个递归数据结构：

```rust
#[derive(Debug)]
enum List<T> {
    Cons(T, Box<List<T>>),
    Nil,
}

let list: List<i32> = List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))));
println!("{:?}", list);
```

这将打印出  `Cons(1, Cons(2, Nil))`。

递归结构必须是box，因为如果Cons的定义是这样的：

```rust
Cons(T, List<T>),
```

这样做就不行了。这是因为List的大小取决于列表中有多少元素，所以我们不知道要为Cons分配多少内存。通过引入一个Box<T>，它有一个定义的大小，我们就知道Cons需要多大。

### 内存布局

TODO



