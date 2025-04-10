---
title: "Rust的if条件表达式"
linkTitle: "if"
weight: 1610
date: 2021-03-29
description: >
  Rust的if条件表达式
---


表达式一定会有值，所以 if 条件表达式的分支必须返回同一个类型的值。

```rust
let n = 13;
// if 表达式可以用来赋值
let big_n = if n < 10 && n > -10 {
    // 分支必须返回同一个类型的值
    10 * n
} else {
    // 自动截取
    n / 2
};
assert_eq!(big_n, 6);
```

