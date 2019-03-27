---
date: 2019-03-05T07:00:00+08:00
title: 元组
menu:
  main:
    parent: "grammar-type"
weight: 326
description : "Rust中的元组"
---

元组（tuple）是一种异构有限序列：

- **异构** 指元组内的元素可以是不同的类型
- **有限** 是指元组有固定长度

### 创建元组

使用包含在圆括号中的逗号分隔的值列表来创建一个元组。元组中的每一个位置都有一个类型，而且这些不同值的类型也不必是相同的：

```rust
fn main() {
    let tup: (i32, f64, u8) = (500, 6.4, 1);
}
```

`tup` 变量绑定到整个元组上，因为元组是一个单独的复合元素。

### 元组取值

为了从元组中获取单个值，可以使用模式匹配（pattern matching）来解构元组值：

```rust
fn main() {
    let tup = (500, 6.4, 1);

    let (x, y, z) = tup;

    println!("The value of y is: {}", y);
}
```

除了使用模式匹配解构外，也可以使用点号（`.`）后跟值的索引来直接访问它们：

```rust
fn main() {
    let x: (i32, f64, u8) = (500, 6.4, 1);

    let five_hundred = x.0;

    let six_point_four = x.1;

    let one = x.2;
}
```

跟大多数编程语言一样，元组的第一个索引值是 0。

###  特殊元组

当元组中只有一个元素时，需要加逗号，即 `(1,)`

空元组，｀()｀