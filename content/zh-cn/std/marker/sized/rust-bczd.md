---
title: "[Rust编程之道笔记]Sided trait"
linkTitle: "[Rust编程之道笔记]"
weight: 1314
date: 2021-12-01
description: >
  Rust编程之道一书 3.4.4 标签trait 
---



Sized trait 非常重要，编译期用它来识别在编译期确定大小的类型。

```rust
#[lang = "sized"]
pub trait Sized {
    // Empty.
}
```

Sized trait 是空 trait，仅仅作为标签 trait 供编译期使用。真正起"打标签"作用的是属性 `#[lang = "sized"]`。该属性lang表示Sized trait供rust语言本身使用，声明为 "sized"，称为语言项(Lang Item)。

rust语言中大部分类型都是默认 Sized ，如果需要使用动态大小类型，则需要改为 `<T: ?Sized>` 限定。

```rust
struct Foo<T>(T);
struct Bar<T: ?Sized>(T);
```



### Sized, Unsize和 ?Sized的关系



- Sized 标记的是在编译期可确定大小的类型

- Unsized 标记的是动态大小类型，在编译期无法确定其大小

    目前rust中的动态类型有 trait 和 [T]

    其中 [T] 代表一定数量的T在内存中的一次排列，但不知道具体的数量，所以大小是未知的。

- ?Sized 标记的类型包含了 Sized 和 Unsized 所标识的两种类型。

    所以泛型结构体 `struct Bar<T: ?Sized>(T);` 支持编译期可确定大小类型和动态大小类型两种类型。

### 动态大小类型的限制规则

- 只可以通过胖指针来操作 Unsize 类型，如 `&[T]` 或者 `&trait`
- 变量，参数和枚举变量不能使用动态大小类型
- 结构体中只有最有一个字段可以使用动态大小类型，其他字段不可以使用











