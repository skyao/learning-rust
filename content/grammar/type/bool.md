---
date: 2019-03-05T07:00:00+08:00
title: 布尔型
menu:
  main:
    parent: "grammar-type"
weight: 323
description : "Rust中的布尔型"
---

Rust 内置布尔类型

Rust 中的布尔类型使用 `bool` 表示，可以通过as操作将bool转为数字0和1，但是不支持从数字转为bool：

```rust
fn main() {
    let _t = true;

    // 显式指定类型注解
    let _f: bool = false;

    // 用 as 转成 int
    let i:i32 = _f as i32;

    print!("{}", i);
}
```

使用布尔值的主要场景是条件表达式，例如 `if` 表达式。