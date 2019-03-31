---
date: 2019-03-05T07:00:00+08:00
title: Trait
weight: 440
description : "Rust的trait"
---

### Trait的介绍

Trait 是 Rust 的灵魂：

- Rust 中所有的抽象都是基于trait来实现
	- 接口抽象
	- OOP范式抽象
	- 函数式范式抽象
- trait 也保证了这些抽象几乎都是在运行时零开销

### Trait的使用

Trait 是 Rust 对 Ad-hoc 多态的支持。

从语义上说，trait 是行为上对类型的约束，这种约束让trait 有如下用法：

- 接口抽象：接口是对类型行为的统一约束
- 泛型约束：泛型的行为被trait限定在更有限的范围内
- 抽象类型：在运行时作为一种间接的抽象类型去使用，动态分发给具体的类型
- 标签trait：对类型的约束，可以直接作为一种“标签”使用