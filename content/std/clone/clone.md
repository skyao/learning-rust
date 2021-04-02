---
type: docs
title: "Rust标准库中的克隆介绍"
linkTitle: "克隆介绍"
weight: 1101
date: 2021-04-02
description: Rust标准库中的克隆介绍
---

https://doc.rust-lang.org/std/clone/index.html

克隆特性，用于不能 "隐式复制 "的类型。

在Rust中，一些简单的类型是 "隐式复制 "的，当你分配它们或传递它们作为参数时，接收方会得到一个副本，保留原值。这些类型不需要分配器来复制，也没有finalizers器（也就是说，它们不包含拥有的box或实现Drop），所以编译器认为它们的复制很便宜，也很安全。对于其他类型，必须显式地进行复制，通过实现Clone特征并调用clone方法。

基本用法示例：

```
let s = String::new(); // String type implements Clone
let copy = s.clone(); // so we can clone it
```

为了方便地实现Clone特征，也可以使用 ``#[derive(Clone)]``。例子：

```rust
#[derive(Clone)] // we add the Clone trait to Morpheus struct
struct Morpheus {
   blue_pill: f32,
   red_pill: i64,
}

fn main() {
   let f = Morpheus { blue_pill: 0.0, red_pill: 0 };
   let copy = f.clone(); // and now we can clone it!
}
```