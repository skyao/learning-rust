---
title: "Rust trait的泛型约束"
linkTitle: "泛型约束"
weight: 2220
date: 2021-04-02
description: Rust trait的泛型约束
---

使用泛型编程时，很多情况下，并不是针对所有的类型。因此需要用trait作为泛型的约束。

### trait限定

```rust
use std::ops::Add;
// 如果不加类型约束，只有一个泛型T，则不能保证所有类型都实现了+操作
//fn sum<T>(a: T, b: T) -> T {
// 因此需要为泛型增加约束，限制为实现了Add trait的类型
// 可以简写为 Add<Output=T>
//fn sum<T: Add<Output=T>>(a: T, b: T) -> T {
fn sum<T: Add<T, Output=T>>(a: T, b: T) -> T {
    a + b
}
assert_eq!(sum(1u32, 2u32), 3);
assert_eq!(sum(1u64, 2u64), 3);
```

语法上也可以使用 where 关键字做约束：

```rust
fn sum<T>(a: T, b: T) -> T where T: Add<T, Output=T> {
    a + b
}
```

看上去更清晰一些？