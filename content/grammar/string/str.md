---
date: 2019-03-26T07:00:00+08:00
title: str字符串
menu:
  main:
    parent: "grammar-string"
weight: 341
description : "Rust中的str字符串"
---

Rust的原始字符串类型，也称为 字符串切片。

通常以不可变借用的形式存在，既 `&str`。

str 由两部分组成：

- 指向字符串序列的指针
- 记录长度的值

```rust
use std::slice::from_raw_parts;
use std::str::from_utf8;

let truth: &'static str = "Rust是一门优雅的语言";
let ptr = truth.as_ptr();
let len = truth.len();
assert_eq!(28, len);

let s = unsafe {
    let slice = from_raw_parts(ptr, len);
    from_utf8(slice)
};
assert_eq!(s, Ok(truth));
```

Rust 中的字符串本质上是一段有效的 UTF-8 字符序列。


