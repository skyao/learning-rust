---
title: "ops模块概述"
linkTitle: "概述"
weight: 10001
date: 2021-11-29
description: >
 可重载的算符
---



ops = Overloadable operators = 可重载的运算符



## 官方文档

https://doc.rust-lang.org/core/ops/

可重载的运算符。

实现这些 traits 可使您重载某些运算符。

其中的某些 traits 由 prelude 导入，因此在每个 Rust 程序中都可用。只能重载由 traits 支持的运算符。 例如，可以通过 [`Add`](trait.Add.html) trait 重载加法运算符 (`+`)，但是由于赋值运算符 (`=`) 没有后备 trait，因此无法重载其语义。 此外，此模块不提供任何机制来创建新的运算符。 如果需要无特征重载或自定义运算符，则应使用宏或编译器插件来扩展 Rust 的语法。

考虑到它们的通常含义和 [运算符优先级](../../reference/expressions.html#expression-precedence)，运算符 traits 的实现在它们各自的上下文中应该不足为奇。 例如，当实现 [`Mul`](trait.Mul.html) 时，该操作应与乘法有些相似 (并共享期望的属性，如关联性)。

请注意，`&&` 和 `||` 运算符发生短路，即，它们仅在第二操作数对结果有贡献的情况下才对其求值。由于 traits 无法强制执行此行为，因此不支持 `&&` 和 `||` 作为可重载的运算符。

许多运算符都按值取其操作数。在涉及内置类型的非泛型上下文中，这通常不是问题。 但是，如果必须重用值而不是让运算符使用它们，那么在泛型代码中使用这些运算符就需要引起注意。一种选择是偶尔使用 [`clone`](../clone/trait.Clone.html#tymethod.clone)。 另一个选择是依靠所涉及的类型，为引用提供其他运算符实现。 例如，对于应该支持加法的用户定义类型 `T`，将 `T` 和 `&T` 都实现 traits [`Add`](trait.Add.html) 和 [`Add<&T>`](trait.Add.html) 可能是一个好主意，这样就可以编写泛型代码而不必进行不必要的克隆。

### 示例

本示例创建一个实现 [`Add`](trait.Add.html) 和 [`Sub`](trait.Sub.html) 的 `Point` 结构体，然后演示加减两个 Point。

```rust
use std::ops::{Add, Sub};

#[derive(Debug, Copy, Clone, PartialEq)]
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        Self {x: self.x + other.x, y: self.y + other.y}
    }
}

impl Sub for Point {
    type Output = Self;

    fn sub(self, other: Self) -> Self {
        Self {x: self.x - other.x, y: self.y - other.y}
    }
}
```

有关示例实现，请参见每个 trait 的文档。

[`Fn`](trait.Fn.html)，[`FnMut`](trait.FnMut.html) 和 [`FnOnce`](trait.FnOnce.html) traits 由可以像函数一样调用的类型实现。请注意，[`Fn`](trait.Fn.html) 占用 `&self`，[`FnMut`](trait.FnMut.html) 占用 `&mut self`，[`FnOnce`](trait.FnOnce.html) 占用 `self`。 这些对应于可以在实例上调用的三种方法：引用调用、可变引用调用和值调用。 这些 traits 的最常见用法是充当以函数或闭包为参数的高级函数的界限。

以 [`Fn`](trait.Fn.html) 作为参数:

```rust
fn call_with_one<F>(func: F) -> usize
    where F: Fn(usize) -> usize
{
    func(1)
}

let double = |x| x * 2;
assert_eq!(call_with_one(double), 2);
```

以 [`FnMut`](trait.FnMut.html) 作为参数:

```rust
fn do_twice<F>(mut func: F)
    where F: FnMut()
{
    func();
    func();
}

let mut x: usize = 1;
{
    let add_two_to_x = || x += 2;
    do_twice(add_two_to_x);
}

assert_eq!(x, 5);
```

以 [`FnOnce`](trait.FnOnce.html) 作为参数:

```rust
fn consume_with_relish<F>(func: F)
    where F: FnOnce() -> String
{
    // `func` 使用其捕获的变量，因此不能多次运行
    //
    println!("Consumed: {}", func());

    println!("Delicious!");

    // 再次尝试调用 `func()` 将为 `func` 引发 `use of moved value` 错误
    //
}

let x = String::from("x");
let consume_and_return_x = move || x;
consume_with_relish(consume_and_return_x);

// `consume_and_return_x` 现在不能再被调用
```

