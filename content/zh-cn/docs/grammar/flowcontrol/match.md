---
title: "Rust的match表达式"
linkTitle: "match"
weight: 1650
date: 2021-03-29
description:  Rust的match表达式
---


match用于匹配各种情况，类似其他语言的 switch 或 case。

在 Rust 语言中，match 分支使用 模式匹配 （pattern matching）技术，match分支：

- 左边是模式：
	- 不同分支可以是不同的模式
	- 必须穷尽每一种可能，所以通常最后使用通配符 _ 
- 右边是执行代码
	- 同样所有分支必须返回同一个值

```rust
let number = 42;
match number {
    // 模式为单个值
    0 => println!("Origin"),
    // 模式为Range
    1...3 => println!("All"),
    // 模式为 多个值
    | 5 | 7 | 13  => println!("Bad Luck"),
    // 绑定模式，将模式中的值绑定给一个变量，供右边执行代码使用
    n @ 42 => println!("Answer is {}", n),
    // _ 通配符处理剩余情况
    _ => println!("Common"),
}
```

match语句可以直接用来赋值，代码比较简练：

```rust
let boolean = true;
let binary = match boolean {
    false => 0,
    true => 1,
};
```

