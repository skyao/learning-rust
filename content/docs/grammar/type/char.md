---
title: "Rust的字符型"
linkTitle: "字符型"
date: 2021-03-29
weight: 1240
description: >
  Rust的字符类型
---


使用单引号来定义字符类型。

Rust 的 `char` 类型代表了一个 Unicode 标量值（Unicode Scalar Value），每个字符占4个字节。

```rust
fn main() {
    let x = 'r';
    let x = 'Ú';
    // 支持转义
    println!("{}", '\'');
    println!("{}", '\\');
    println!("{}", '\n');
    println!("{}", '\r');
    println!("{}", '\t');
    // 用 ASCII 码表示字符
    assert_eq!('\x2A', '*');
    assert_eq!('\x25', '%');
    // 用 unicode 表示字符
    assert_eq!('\u{CA0}', 'ಠ');
    assert_eq!('\u{151}', 'ő');
    // 可以使用 as 操作符将字符转为数字类型
    assert_eq!('%' as i8, 37);
    assert_eq!('ಠ' as i8, -96); //该字符值的高位会被截断，最终得到-96
}
```

