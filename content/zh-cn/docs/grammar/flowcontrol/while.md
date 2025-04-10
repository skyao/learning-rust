---
title: "Rust的while循环表达式"
linkTitle: "while"
weight: 1630
date: 2021-03-29
description:  Rust的while循环表达式
---

while 循环，没啥特别：

```rust
let mut n = 1;
while n < 101 {
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

