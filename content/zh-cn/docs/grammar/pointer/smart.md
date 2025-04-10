---
title: "Rust的智能指针(Smart Pointer)"
linkTitle: "智能指针(Smart Pointer)"
weight: 1540
date: 2021-03-29
description: >
  Rust的智能指针(Smart Pointer)
---

智能指针 (Smart Pointer) 源自c++，Rust 引入后成为 Rust 语言中最重要的一种数据结构。

### 功能介绍

Rust 中的值默认被分配到 栈内存。可以通过 `Box<T>` 将值装箱（在堆内存中分配）。

- `Box<T>` 是指向类型为T的堆内存分配值的智能指针。
- 当  `Box<T>` 超出作用域范围时，将调用其析构函数，销毁内部对象，并自动释放内存。
- 可以通过解引用操作符来获取`Box<T>`中的T

`Box<T>` 的行为像引用，并可以自动释放内存，所以称为智能指针。

### `Box<T>`类型

Rust 中提供了很多智能指针类型。

```rust
#[derive(Debug, PartialEq)]
struct Point {
    x: f64,
    y: f64,
}
let box_point = Box::new(Point { x: 0.0, y: 0.0 });
let unboxed_point: Point = *box_point;
assert_eq!(unboxed_point, Point { x: 0.0, y: 0.0 });
```

