---
date: 2019-03-31T16:00:00+08:00
title: 接口抽象
menu:
  main:
    parent: "type-trait"
weight: 441
description : "Rust trait的接口抽象"
---

Trait 最基础的用法就是进行接口抽象，有如下特点：

- 接口中可以定义方法，并支持默认实现
- 接口中不能实现另一个接口，但是接口之间可以继承
- 同一个接口可以同时被多个类型实现，但是同一个类型不能多次实现同一个接口
- 使用impl关键字为类型实现接口方法
- 使用trait关键字来定义接口

### 关联类型



```rust
// 为类型参数RHS指定默认值为Self
// Self 是每个trait都带有的隐式类型参数，代表实现当前trait的具体类型
trait Add<RHS = Self> {
    // 用 type 关键字定义参数类型
    type Output;
    // 返回类型可以用 Self::Output 来指定
    fn add(self, rhs: RHS) -> Self::Output;
}

impl Add<&str> for String {
    // 实现时指定 Output 类型
    type Output = String;
    fn add(mut self, other: &str) -> String {
        self.push_str(other);
        self.push_str("!!!");
        self
    }
}

fn main() {
    let a = "hello";
    let b = " world";
    let c = a.to_string().add( b);
    println!("{:?}", c); // "hello world"
}
```

