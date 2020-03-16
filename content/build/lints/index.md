---
date: 2019-03-25T07:00:00+08:00
title: Lints
weight: 280
description : "Rust Lints"
---

在软件中，“Lints”是用于帮助改善源代码的工具。Rust编译器包含许多Lints，并且在编译代码时，它还将运行Lints。这些Lints可能会产生警告，错误或根本不产生任何东西，具体取决于您配置事物的方式。

这是一个小例子：

```bash
$ cat main.rs
fn main() {
    let x = 5;
}
$ rustc main.rs
warning: unused variable: `x`
 --> main.rs:2:9
  |
2 |     let x = 5;
  |         ^
  |
  = note: `#[warn(unused_variables)]` on by default
  = note: to avoid this warning, consider using `_x` instead
```

这是`unused_variables` Lints，它告诉您已引入了代码中的变量未使用。这不是*bug*，所以它不是一个错误，但它可能是一个错误，所以你得到一个警告。