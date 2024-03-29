---
title: "[Rust编程之道笔记]类型大小"
linkTitle: "[Rust编程之道笔记]"
weight: 211
date: 2021-04-02
description: >
 Rust编程之道一书 3.2.1 节类型大小
---

> 内容出处: Rust编程之道一书，第3章类型系统，3.2.1 类型大小

## 3.2 类型大小

编程语言中不同的类型本质上是内存占用空间和编码方式的不同，Rust也不例外。Rust没有GC，内存首先由编译期来分配，rust代码首先由编译期来分配， Rust 代码被编译为 LLVM IR，其中携带了内存分配的信息。

因此，**Rust编译器需要实现知道类型的大小，才能分配合理的内存**。

#### 可确定大小类型和动态大小类型

Rust 中绝大部分类型都是在编译期内可确定大小的类型（称为Sized Type)，也有少量的动态大小的类型（Dynamic Sized Type，简写为 DST）。

对于DST，Rust提供了引用类型，因为引用总会有固定且在编译期已知的大小。如字符串切片 `&str` 就是一种引用类型 ，由指针和长度信息组成。

#### 零大小类型

除了可确定大小类型和 DST 类型，Rust 还支持零大小类型（Zero Sized Type， ZST），如单元类型和单元结构体。

- 单元类型和单元结构体大小为零
- 由单元类型组成的数组大小也为零

ZST类型的特点是：值就是本身，运行时并不占用内存空间。

### 底类型

底类型（Bottom type）是院子类型理论的术语，其实是 never 类型，它的特点是：

- 没有值
- 是其他任意类型的子类型

如果说 ZST 类型表示“空”的话，那么底类型就是表示“无”。

Rust 中的底类型用 `!` 表示，也被称为 Bang Type。

Rust 中有很多中情况确实没有值，但是为了类型安全，必须归入类型系统进行统一处理，这些情况包括：

- 发散函数(Diverging Function)：指会导致线程崩溃的 `panic!` 或者用于退出函数的 `std::process::exit`。
- `continue` 和 `break` 关键字: 只是表示流程的跳转，并不会返回什么
- `loop` 循环：虽然可以返回某个值，但是也有需要无限循环的时候
- 空枚举，比如 `enum Void{}`
