---
date: 2019-03-05T07:00:00+08:00
title: 变量隐藏
menu:
  main:
    parent: "grammar-basic"
weight: 313
description : "Rust中的变量隐藏"
---

可以定义一个与之前变量同名的新变量，而新变量会 **隐藏(Shadowing)** 之前的变量。

Rustacean 们称之为第一个变量被第二个 **隐藏** 了，这意味着使用这个变量时会看到第二个值。可以用相同变量名称来隐藏一个变量，以及重复使用 `let` 关键字来多次隐藏，如下所示：

```rust
fn main() {
    let x = 5;

    let x = x + 1;

    let x = x * 2;

    println!("The value of x is: {}", x);
}
```

当再次使用 `let` 时，实际上创建了一个新变量，我们可以改变值的类型，但复用这个名字:

```rust
let spaces = "   ";
let spaces = spaces.len();
```



