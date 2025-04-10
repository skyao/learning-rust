---
title: "Rust的 if let 表达式"
linkTitle: "if let"
weight: 1660
date: 2021-03-29
description:  Rust的 if let 表达式
---


if let 表达式用来在某些场合替代 match 表达式.

```rust
let boolean = true;
let mut binary = 0;
// if let 左侧为模式，右侧为匹配的值
if let true = boolean {
    binary = 1;
}
assert_eq!(binary, 1);
```

备注：这个例子看不出 if let 的价值所在。


