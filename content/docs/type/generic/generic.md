---
title: "Rust的范型概述"
linkTitle: "范型概述"
weight: 2101
date: 2021-04-02
description: >
  Rust的范型概述
---

泛型是一种参数化多态，是把一个泛化的类型作为参数。

### 泛型使用

泛型函数：

```rust
fn foo<T>(x: T) -> T {
   return x;
}
```

泛型结构体：

```rust
struct Point<T> {  x: T, y: T }
impl<T> Point<T> {
    fn new(x: T, y: T) -> Self{
        Point{x: x, y: y}
    }
}
```

Rust 中的泛型属于静多态，是编译期多态，在编译期会被单态化。

泛型和单态化是rust的最重要的功能。

单态化静态分发

- 好处是性能好，没有运行时开销
- 缺点是容易造成编译后的二进制文件膨胀

### 返回值自动推导

可以根据返回值的类型来推导泛型类型：

```rust
#[derive(Debug, PartialEq)]
struct Foo(i32);
#[derive(Debug, PartialEq)]
struct Bar(i32, i32);
trait Inst {
    fn new(i: i32) -> Self;
}
impl Inst for Foo {
    fn new(i: i32) -> Foo {
        Foo(i)
    }
}
impl Inst for Bar {
    fn new(i: i32) -> Bar {
        Bar(i, i + 10)
    }
}
// 泛型函数，返回值是泛型
fn foobar<T: Inst>(i: i32) -> T {
    T::new(i)
}
// 指定泛型类型为Foo，因此foobar实现中调用的是 Foo::new(i)
let f: Foo = foobar(10);
assert_eq!(f, Foo(10));
// 指定泛型类型为Bar，因此foobar实现中调用的是 Bar::new(i)
let b: Bar = foobar(20);
assert_eq!(b, Bar(20, 30));
```

