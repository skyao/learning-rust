---
title: "Copy trait的std文档"
linkTitle: "std文档"
weight: 1332
date: 2021-12-01
description: >
  Copy trait的std文档
---

https://doc.rust-lang.org/std/marker/trait.Copy.html

```rust
pub trait Copy: Clone { }
```

只需复制位即可复制其值的类型。

默认情况下，变量绑定具有 `move语义`。换句话说:

```rust
#[derive(Debug)]
struct Foo;

let x = Foo;

let y = x;

// `x` 已移至 `y`，因此无法使用

// println!("{:?}", x); // error: use of moved value
```

但是，如果类型实现 `Copy`，则它具有复制语义:

```rust
// 我们可以派生一个 `Copy` 实现。
// `Clone` 也是必需的，因为它是 `Copy` 的父特征。
#[derive(Debug, Copy, Clone)]
struct Foo;

let x = Foo;

let y = x;

// `y` 是 `x` 的副本

println!("{:?}", x); // A-OK!
```

重要的是要注意，在这两个示例中，唯一的区别是分配后是否允许您访问 `x`。 在后台，复制(copy)和移动(move)都可能导致将位复制到内存中，尽管有时会对其进行优化。

### 如何实现 `Copy`?

有两种方法可以在您的类型上实现 `Copy`。最简单的是使用 `derive`:

```rust
#[derive(Copy, Clone)]
struct MyStruct;
```

您还可以手动实现 `Copy` 和 `Clone`:

```rust
struct MyStruct;

impl Copy for MyStruct { }

impl Clone for MyStruct {
    fn clone(&self) -> MyStruct {
        *self
    }
}
```

两者之间的区别很小: `derive` 策略还将 `Copy` 绑定在类型参数上，这并不总是需要的。

### `Copy` 和 `Clone` 有什么区别？

复制是隐式发生的，例如作为分配 `y = x` 的一部分。`Copy` 的行为不可重载; 它始终是简单的按位复制。

克隆是一个明确的动作 `x.clone()`。`Clone` 的实现可以提供安全复制值所需的任何特定于类型的行为。 例如，用于 `String`的 `Clone` 的实现需要在堆中复制指向字符串的缓冲区。 `String` 值的简单按位副本将仅复制指针，从而导致该行向下双重释放。 因此，`String`是 `Clone`，但不是 `Copy`。

`Clone` 是 `Copy` 的父特征，因此 `Copy` 的所有类型也必须实现 `Clone`。 如果类型为 `Copy`，则其 `Clone` 实现仅需要返回 `*self` (请参见上面的示例)。

### 类型何时可以是 `Copy`?

如果类型的所有组件都实现 `Copy`，则它可以实现 `Copy`。例如，此结构体可以是 `Copy`:

```rust
#[derive(Copy, Clone)]
struct Point {
   x: i32,
   y: i32,
}
```

一个结构体可以是 `Copy`，而 `i32` 是 `Copy`，因此 `Point` 有资格成为 `Copy`。 相比之下，考虑

```rust
struct PointList {
    points: Vec<Point>,
}
```

结构体 `PointList` 无法实现 `Copy`，因为 `Vec` 不是 `Copy`。如果尝试派生 `Copy` 实现，则会收到错误消息:

```bash
the trait `Copy` may not be implemented for this type; field `points` does not implement `Copy`
```

共享引用 (`&T`) 也是 `Copy`，因此，即使类型中包含不是 *`Copy` 类型的共享引用 `T`，也可以是 `Copy`。 考虑下面的结构体，它可以实现 `Copy`，因为它从上方仅对我们的非 Copy 类型 `PointList` 持有一个 *shared 引用*:

```rust
#[derive(Copy, Clone)]
struct PointListWrapper<'a> {
    point_list_ref: &'a PointList,
}
```

### 什么时候类型不能为 `Copy`?

某些类型无法安全复制。例如，复制 `&mut T` 将创建一个别名可变引用。 复制 `String` 将重复管理 `String` 缓冲区，从而导致双重释放。

概括后一种情况，任何实现 `Drop` 的类型都不能是 `Copy`，因为它除了管理自己的 `size_of::` 字节外还管理一些资源。

果您尝试在包含非 `Copy` 数据的结构或枚举上实现 `Copy`，则会收到 [E0204](../../error-index.html#E0204) 错误。

### 什么时候类型应该是 `Copy`?

一般来说，如果您的类型可以实现 `Copy`，则应该这样做。 但是请记住，实现 `Copy` 是您类型的公共 API 的一部分。 如果该类型将来可能变为非 `Copy`，则最好现在省略 `Copy` 实现，以避免 API 发生重大更改。

### 其他实现者

除下面列出的实现者外，以下类型还实现 `Copy`:

- 函数项类型 (即，为每个函数定义的不同类型)
- 函数指针类型 (例如 `fn() -> i32`)
- 如果项类型也实现 `Copy` (例如 `[i32; 123456]`)，则所有大小的数组类型
- 如果每个组件还实现 `Copy` (例如 `()`，`(i32, bool)`)，则为元组类型
- 闭包类型，如果它们没有从环境中捕获任何值，或者所有此类捕获的值本身都实现了 `Copy`。 请注意，由共享引用捕获的变量始终实现 `Copy` (即使引用对象没有实现)，而由变量引用捕获的变量从不实现 `Copy`。
