---
title: "Rust的指针概述"
linkTitle: "指针概述"
weight: 1501
date: 2021-03-29
description: >
  Rust的指针概述
---

Rust 中将可以表示内存地址的类型成为 **指针**。

Rust提供了多种类型的指针：

- 引用（Reference）
- 原生指针（Raw Pointer）
- 函数指针（fn Pointer）
- 智能指针（Smart Pointer）

Rust 可以划分为 Safe Rust 和 Unsafe Rust 两部分。

### Safe Rust

引用主要应用于 Safe Rust。

在Safe Rust 中，编译器会对引用进行借用检查，以保证内存安全和类型安全。

### Unsafe Rust

原生引用主要用于 Unsafe Rust。

原生引用不在 Safe Rust 的控制范围内，需要编程人员自己保证安全。



