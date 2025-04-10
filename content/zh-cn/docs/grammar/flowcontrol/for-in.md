---
title: "Rust的for ... in循环表达式"
linkTitle: "for ... in"
weight: 1620
date: 2021-03-29
description: >
  Rust的for ... in循环表达式
---

### 循环表达式

Rust 有三种循环表达式：while 、loop 和 for ... in 表达式。

for ... in 循环：

```rust
for n in 1..101 {
    if n % 15 == 0 {
        println!("fizzbuzz");
    } else if n % 3 == 0 {
        println!("fizz");
    } else if n % 5 == 0 {
        println!("buzz");
    } else {
        println!("{}", n);
    }
}
```

注意 for ... in 后面是一个 Rang 类型，左闭右开，所以这个循环的最后一个n值是100。



