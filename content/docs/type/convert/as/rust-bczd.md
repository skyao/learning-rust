---
title: "[Rust编程之道笔记]as操作符"
linkTitle: "[Rust编程之道笔记]"
weight: 522
date: 2021-12-06
description: >
 Rust编程之道一书 3.5.2 as操作符
---

## 3.5.2 as操作符

as 操作符最常用的场景就是转换 rust 中的基本数据类型。

as 关键字不支持重载。

长类型转换为短类型的时候会被 截断处理。

### 无歧义完全限定语法

为结构体实现多个trait时，可能会出现同名的方法，使用 as 操作符可以帮助避免歧义。

```rust
fn main() {
    let s = S(1);
    // 当 trait 的静态函数来调用
    A::test(&s, 1);
    B::test(&s, 1);
    // 使用as操作符
    <S as A>::test(&s, 1);
    <S as B>::test(&s, 1);
}
```

### 类型和子类型相互转换

as转换可以用于类型和子类型之间的转换。

`&'static str'` 类型是 `&'a str'` 类型的子类型。两者的生命周期标记不同，`'a` 和 `'static` 都是生命周期标记，其中 `'a` 是泛型标记，是 &str 的通用形式，而 `'static` 则是特指静态生命周期的 &str 字符串。

```rust
fn main() {
    let a: &'static str = "hello"; // 'static str
    let b: &str = a as &str; // &str
    let c: &'static str = b as &'static str; // 'static str
}
```

可以通过 as 操作符将 `&'static str'` 和 `&'a str'` 相互转换。

