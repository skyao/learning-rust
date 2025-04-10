---
title: "Rust集合中的向量(Vec)"
linkTitle: "向量(Vec)"
date: 2021-03-29
weight: 1410
description: Rust集合中的向量(Vec)
---

向量(Vec) 也是一种数组，差别在于可动态增长。

```rust
// 用宏创建可变向量
let mut v1 = vec![];
v1.push(1);
v1.push(2);
v1.push(3);
assert_eq!(v1, [1,2,3]);
assert_eq!(v1[1], 2);

// 用宏创建不可变向量
let v2 = vec![0; 10];

// 用 new 方法创建
let mut v3 = Vec::new();
v3.push(4);
v3.push(5);
v3.push(6);
```
