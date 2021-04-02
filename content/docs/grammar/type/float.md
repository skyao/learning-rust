---
title: "Rust的浮点型"
linkTitle: "浮点型"
date: 2021-03-29
weight: 1220
description: >
  Rust的浮点类型
---

Rust 有两个原生的 **浮点数** `f32` 和 `f64`，分别占 32 位和 64 位。

默认类型是 `f64`，因为在现代 CPU 中，它与 `f32` 速度几乎一样，不过精度更高。

```rust
let num = 3.1415926f64;
assert_eq!(-3.14, -3.14f64);
assert_eq!(2., 2.0f64);
assert_eq!(2e4, 20000f64);
```

特殊值：

```rust
use std::f32::{INFINITY, NEG_INFINITY, NAN, MIN, MAX};
println!("{:?}", INFINITY);
println!("{:?}", NEG_INFINITY);
println!("{:?}", NAN);
println!("{:?}", MIN);
println!("{:?}", MAX);
```
打印结果为：

```bash
inf
-inf
NaN
-340282350000000000000000000000000000000.0
340282350000000000000000000000000000000.0
```

