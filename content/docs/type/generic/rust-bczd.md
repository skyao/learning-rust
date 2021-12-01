---
title: "[Rust编程之道笔记]泛型"
linkTitle: "[Rust编程之道笔记]"
weight: 310
date: 2021-11-29
description: >
 Rust编程之道一书 3.3 节泛型
---

> 内容出处: Rust编程之道一书，第3.3节泛型

## 3.3 泛型

Rust的泛型是参数化多态。简单说就是把泛化的类型作为参数，单个类型可以抽象为一簇类型。

### 泛型的实现

#### 泛型类型

类似 Box<T>, Option<T>, Result<T, E> 都是泛型类型。

#### 泛型函数

```rust
fn foo<T>(x: T) -> T {
    return x;
}
```

#### 泛型结构体

```rust
struct Point<T> {
    x: T,
    y: T,
}
impl<T> Point<T> {
    fn new(x:T, y:T) -> Self {
        Point{x:x, y:y}
    }
}
```

#### 泛型枚举

TDB

### 泛型单态化

Rust的泛型是静多态，是编译期多态，在编译期会被单态化(Monomorphization)。

单态化意味着编译期要将一个泛型函数生成多个具体类型对应的函数。

泛型和单态化是 Rust 最重要的功能。

单态化静态分发的好处是性能好，没有运行时开销；缺点是容易造成编译后生成的二进制文件膨胀。

### 3.3.2 泛型返回值自动推导

编译期可以对泛型进行自动推导。

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

