---
date: 2019-03-25T07:00:00+08:00
title: 流程控制
weight: 370
description : "Rust的流程控制"
---

Rust 中不叫流程控制语句，而是叫做流程控制表达式。

这是关键：流程表达式是可以作为右值赋值的

### 条件表达式

表达式一定会有值，所以 if 表达式的分支必须返回同一个类型的值。

```rust
let n = 13;
// if 表达式可以用来赋值
let big_n = if n < 10 && n > -10 {
    // 分支必须返回同一个类型的值
    10 * n
} else {
    // 自动截取
    n / 2
};
assert_eq!(big_n, 6);
```

### 循环表达式

Rust 有三种循环表达式：while 、loop 和 for ... in 表达式。

for ... in 循环：

```rust
for n in 1..101 {
    if n % 15 == 0 {
        println!("fizzbuzz");
    } else if n % 3 == 0 {
        println!("fizz");
    } else if n % 5 == 0 {
        println!("buzz");
    } else {
        println!("{}", n);
    }
}
```

注意 for ... in 后面是一个 Rang 类型，左闭右开，所以这个循环的最后一个n值是100。

while 循环，没啥特别：

```rust
let mut n = 1;
while n < 101 {
    if n % 15 == 0 {
        println!("fizzbuzz");
    } else if n % 3 == 0 {
        println!("fizz");
    } else if n % 5 == 0 {
        println!("buzz");
    } else {
        println!("{}", n);
    }
    n += 1;
}
```

loop 循环，相当于一个 while true，需要程序自己 break：

```rust
let mut n = 1;
loop {
    if n > 101 { break; }
    if n % 15 == 0 {
        println!("fizzbuzz");
    } else if n % 3 == 0 {
        println!("fizz");
    } else if n % 5 == 0 {
        println!("buzz");
    } else {
        println!("{}", n);
    }
    n += 1;
}
```

强调：**当使用无限循环时，务必使用 loop**，避免使用 while true。

### match表达式

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



### if let 表达式

if let 表达式用来在某些场合替代 match 表达式.

```rust
let boolean = true;
let mut binary = 0;
// if let 左侧为模式，右侧为匹配的值
if let true = boolean {
    binary = 1;
}
assert_eq!(binary, 1);
```

备注：这个例子看不出 if let 的价值所在。

### while let 表达式

while let 可以简化代码，如这个loop：

```rust
let mut v = vec![1,2,3,4,5];
loop {
    match v.pop() {
        Some(x) => println!("{}", x),
        None => break,
    }
}
```

可以改写为：

```rust
let mut v = vec![1,2,3,4,5];
while let Some(x) = v.pop() {
    println!("{}", x);
}
```

