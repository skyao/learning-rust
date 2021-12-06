---
title: "[Rust编程之道笔记]From Trait"
linkTitle: "[Rust编程之道笔记]"
weight: 542
date: 2021-12-06
description: >
 Rust编程之道一书 3.5.3 From Trait
---

## 3.5.3 From和Into

From 和 Into 是定义在 std::convert 模块中的trait，定义了 from 和 into 两个方法，互为反操作。

```rust
pub trait From<T> {
    fn from(T) -> Self;
}
pub trait Into<T> {
    fn into(self) -> T;
}
```

Into的默认规则：如果类型 U 实现了 `From<T>`，则 T 类型实例调用 into 方法时可以转换为类型 U。

这是 rust 标准库中有一个默认的实现：

```rust
impl<T, U> Into<U> for T where U: From<T>
```



### tryFrom 和 tryInto trait

是 From 和 Into 的错误处理版本，因为转型转换是有可能发生错误的，所以需要进行错误处理时就可以用 TryFrom 和 TryInto。



### AsRef 和 AsMut trait

将值分别转换为不可变引用和可变引用。

