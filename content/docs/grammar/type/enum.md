---
title: "Rust的枚举（Enum）类型"
linkTitle: "枚举（Enum）"
date: 2021-03-29
weight: 1296
description: >
  Rust的枚举（Enum）类型
---

枚举用 enum 关键字定义，有三种类型。

### 无参数枚举体 

```rust
enum Number {
    Zero,
    One,
    Two,
}
let a = Number::One;
match a {
    Number::Zero => println!("0"),
    Number::One => println!("1"),
    Number::Two => println!("2"),
}
```

### 类C枚举

```rust
enum Color {
    Red = 0xff0000,
    Green = 0x00ff00,
    Blue = 0x0000ff,
}
println!("roses are #{:06x}", Color::Red as i32);
println!("violets are #{:06x}", Color::Blue as i32);
```

### 带参数枚举

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}
let f: fn(u8, u8, u8, u8) -> IpAddr = IpAddr::V4;
let ff: fn(String) -> IpAddr = IpAddr::V6;
let home = IpAddr::V4(127, 0, 0, 1);
```

带参数枚举的值本质上属于函数指针类型：

- fn(u8, u8, u8, u8) -> IpAddr
- fn(String) -> IpAddr

### 参考资料

视频：

- [Rust Enums Part 1: Introduction](https://www.youtube.com/watch?v=TBixFUJDnRI)
- [Rust Enums part 2: Match & Option](https://www.youtube.com/watch?v=o8bFFwRUEAE)
- [Rust Enums Part 3: if let (Syntax)](https://www.youtube.com/watch?v=sWTu4Lm49Kw)