---
title: "Rust的 while let 表达式"
linkTitle: "while let"
weight: 1670
date: 2021-03-29
description:  Rust的 while let 表达式
---

while let 可以简化代码，如这个loop：

```rust
let mut v = vec![1,2,3,4,5];
loop {
    match v.pop() {
        Some(x) => println!("{}", x),
        None => break,
    }
}
```

可以改写为：

```rust
let mut v = vec![1,2,3,4,5];
while let Some(x) = v.pop() {
    println!("{}", x);
}
```

