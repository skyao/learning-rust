---
date: 2019-03-26T07:00:00+08:00
title: 枚举（Enum）
menu:
  main:
    parent: "grammar-type"
weight: 336
description : "Rust中的枚举"
---

枚举用 enum 关键字定义，有三种类型。

###无参数枚举体 

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

