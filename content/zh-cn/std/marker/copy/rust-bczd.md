---
title: "[Rust编程之道笔记]Copy trait"
linkTitle: "[Rust编程之道笔记]"
weight: 1334
date: 2021-12-01
description: >
  Rust编程之道一书 3.4.4 标签trait 
---



copy trait 用来标识可以按位复制其值的类型，按位复制等价于c语言中的 memcpy。

```rust
pub trait Copy: Clone { }
```

copy trait 继承自 clone trait，意味着要实现 Copy trait 的类型，必须实现 Clone trait 中定义的方法。

要实现 Copy trait，就必须同时实现 Clone trait。

```rust
struct MyStruct;

impl Copy for MyStruct { }

impl Clone for MyStruct {
    fn clone(&self) -> MyStruct {
        *self
    }
}
```

rust提供了更方便的 derive 属性:

```rust
#[derive(Copy, Clone)]
struct MyStruct;
```

copy 的行为是隐式行为，开发者不能重载 Copy 行为，它永远都是一个简单的位复制。

并非所有的类型都可以实现 Copy trait。





