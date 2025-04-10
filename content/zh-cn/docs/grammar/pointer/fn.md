---
title: "Rust的函数指针(Fn Pointer)"
linkTitle: "函数指针(Fn Pointer)"
weight: 1530
date: 2021-03-29
description: >
  Rust的函数指针(Fn Pointer)
---

函数在Rust中是一等公民，函数自身就可以作为函数的参数和返回值使用。

### 函数作为参数

```rust
​```
/// 将函数作为参数传递
pub fn math(op: fn(i32, i32) -> i32, a: i32, b: i32) -> i32{
    /// 通过函数指针调用函数
    op(a, b)
}
fn sum(a: i32, b: i32) -> i32 {
    a + b
}
fn product(a: i32, b: i32) -> i32 {
    a * b
}

let a = 2;
let b = 3;
assert_eq!(math(sum, a, b), 5);
assert_eq!(math(product, a, b), 6);
​```
```

### 函数作为返回值

```rust
fn is_true() -> bool { true }
/// 函数的返回值是另外一个函数
fn true_maker() -> fn() -> bool { is_true }
/// 通过函数指针调用函数
assert_eq!(true_maker()(), true);
​```
```

