---
date: 2019-03-26T07:00:00+08:00
title: 范围（Range）
menu:
  main:
    parent: "grammar-type"
weight: 333
description : "Rust中的Range"
---

Rust 内置的范围类型，包括 左闭右开 和 全币 两种区间，分别是 std::ops::Range 和 std::ops::RangeInclusive 的实例：

```rust
// (1..5)是结构体std::ops::Range的一个实例
use std::ops::{Range, RangeInclusive};
assert_eq!((1..5), Range{ start: 1, end: 5 });
// (1..=5)是结构体std::ops::RangeInclusive的一个实例
assert_eq!((1..=5), RangeInclusive::new(1, 5));
// 自带的 sum 方法用于求和
assert_eq!(3+4+5, (3..6).sum());
assert_eq!(3+4+5+6, (3..=6).sum());
(3..6)

// 每个范围都是一个迭代器，可用for 循环打印范围内的元素
for i in (1..5) {
    println!("{}", i);
}
for i in (1..=5) {
    println!("{}", i);
}
```





