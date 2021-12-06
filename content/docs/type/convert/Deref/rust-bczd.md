---
title: "[Rust编程之道笔记]Deref解引用"
linkTitle: "[Rust编程之道笔记]"
weight: 512
date: 2021-11-30
description: >
 Rust编程之道一书 3.5.1 Deref解引用
---

## 3.5.1 解引用

rust 的隐式类型转换基本上只有自动解引用。自动解引用的目的主要是方便开发者使用智能指针。

### 自动解引用

自动解引用虽然是编译期来做的，但是自动解引用的行为可以由开发者来定义。

引用使用 `&` 操作符，而解引用使用 `*` 操作符。可以通过实现 Deref trait 来自定义解引用操作。

Deref 有一个特性是强制隐式转换，规则是这样：如果有一个类型T实现了 `Deref<Target=U>` ，则该类型T的引用（或者智能指针）在应用的时候会被自动转换为类型U。

Deref内部实现：

```rust
pub trait Deref {
    type Target: ?Sized;
    fn deref(&self) -> &Self::Target;
}

pub trait DerefMut : Deref {
    fn deref_mut(&mut self) -> &mut Self::Target;
}
```

DerefMut 和 Deref 类似，不过返回的是可变引用。

实现 Deref 的目的是**简化编程**，避免开发者自己手工转换。

### 手动解引用

如果某类型和其解引用目标类型中包含了相同的方法，编译期就不指导该用哪一个了，此时就需要手动解引用。



