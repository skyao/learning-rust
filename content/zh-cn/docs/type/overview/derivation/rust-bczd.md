---
title: "[Rust编程之道笔记]类型推导"
linkTitle: "[Rust编程之道笔记]"
weight: 221
date: 2021-04-02
description: >
 Rust编程之道一书 3.2.2 节类型推导
---

> 内容出处: Rust编程之道一书，第3章类型系统，3.2.2 类型推导

## 3.2.2 类型推导

Rust 只能在局部范围内进行类型推导。



### Turbofish操作符

当 Rust 无法从上下文中自动推导出类型的时候，编译期会通过错误信息提示并要求添加类型标注。

标注类型的方式：

```rust
fn main() {
    let x = "1";
    //标注变量的类型
    let int_x : i32 = x.parse().unwrap();
    //通过 Turbofish操作符 标注
    assert_eq!(x.parse::<i32>().unwrap(), 1);
}
```

### 类型推导的不足

总结：rust的类型推导还不够强大， 因此，编码时推荐尽量显式声明类型，避免麻烦。

