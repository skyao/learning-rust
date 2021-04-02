---
title: "Rust的引用(Reference)"
linkTitle: "引用(Reference)"
weight: 1510
date: 2021-03-29
description: Rust的引用(Reference)
---

Rust 提供引用操作符 `&`，可以直接获取表达式的存储单元地址，即内存地址。

引用本质上是一种非空指针。

```rust
let a = [1,2,3];
let b = &a;
println!("{:p}", b); // 0x7ffcbc067704

// 要获取可变引用，必须先声明可变绑定
let mut c = vec![1,2,3];
// 通过 &mut 得到可变引用
let d = &mut c;
d.push(4);
println!("{:?}", d); // [1, 2, 3, 4]

let e = &42;
assert_eq!(42, *e);
```



从语义上说，不管是 `&a` 还是 `&mut c`，都是对原有变量的所有权的借用，所以引用也被称为借用。
