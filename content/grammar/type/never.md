---
date: 2019-03-05T07:00:00+08:00
title: never类型
menu:
  main:
    parent: "grammar-type"
weight: 329
description : "Rust中的never类型"
---

Rust 的 never 类型（ `!` ）用于表示永远不可能有返回值的计算类型。

Rust 是一个类型安全的语言，所以需要将没有返回值的情况（如线程退出）纳入类型管理。

```rust
#![feature(never_type)]
let x:! = {
    return 123
};
```

报错：

```bash
error[E0554]: #![feature] may not be used on the stable release channel
 --> src/main.rs:1:1
  |
1 | #![feature(never_type)]
  | ^^^^^^^^^^^^^^^^^^^^^^^
```

never 是试验特性，需要使用 nightly 版本。 