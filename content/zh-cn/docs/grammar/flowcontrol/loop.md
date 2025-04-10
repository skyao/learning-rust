---
title: "Rust的loop循环表达式"
linkTitle: "loop"
weight: 1630
date: 2021-03-29
description:  Rust的loop循环表达式
---

loop 循环，相当于一个 while true，需要程序自己 break：

```rust
let mut n = 1;
loop {
    if n > 101 { break; }
    if n % 15 == 0 {
        println!("fizzbuzz");
    } else if n % 3 == 0 {
        println!("fizz");
    } else if n % 5 == 0 {
        println!("buzz");
    } else {
        println!("{}", n);
    }
    n += 1;
}
```

强调：**当使用无限循环时，务必使用 loop**，避免使用 while true。


