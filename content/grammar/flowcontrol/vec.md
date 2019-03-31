---
date: 2019-03-26T07:00:00+08:00
title: 向量(Vec)
menu:
  main:
    parent: "grammar-collection"
weight: 371
description : "Rust中的向量"
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
