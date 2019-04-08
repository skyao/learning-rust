---
date: 2019-03-26T07:00:00+08:00
title: 结构体（Struct）
menu:
  main:
    parent: "grammar-type"
weight: 335
description : "Rust中的结构体struct"
---

Rust 提供三种结构体：

- Named-Field Struct
- Tuple-Like Struct
- Unit-Like Struct

###Named-Field Struct 

Named-Field 是最常见的。

```rust
#[derive(Debug, PartialEq)]
pub struct People {
    name: &'static str,
    gender: u32,
} // 注意这里没有分号

impl People {
    // new 方法的参数并没有 &self
    fn new(name: &'static str, gender: u32) -> Self {
        return People { name: name, gender: gender };
    }
    // 读方法，传递的是 &self 不可变引用
    fn name(&self) {
        println!("name: {:?}", self.name);
    }
    // 写方法，传递的是 &mut self 可变引用
    fn set_name(&mut self, name: &'static str) {
        self.name = name;
    }
    fn gender(&self) {
        let gender = if self.gender == 1 { "boy" } else { "girl" };
        println!("gender: {:?}", gender);
    }
}

fn main() {
    // 用 :: 来调用new方法，默认不可变
    let alex = People::new("Alex", 1);
    // 调用其他方法用 . 号，不用传递 &self
    // 为啥不直接把 &self 改成类型java的this语法呢？反正也不传递
    alex.name();
    alex.gender();
    // 也可以直接构建结构体，绕过new方法
    assert_eq!(alex, People { name: "Alex", gender: 1 });

    // 创建可变结构体
    let mut alice = People::new("Alice", 0);
    alice.name();
    alice.gender();
    assert_eq!(alice, People { name: "Alice", gender: 0 });
    // 就可以调用set方法了
    alice.set_name("Rose");
    alice.name();
    assert_eq!(alice, People { name: "Rose", gender: 0 });
}
```

结构体名字要用驼峰法。

### Tuple-Like Struct

元组结构体像元组和结构体的混合体：字段没有名字，只有类型：	

```rust
#[derive(Debug, PartialEq)]
struct Color(i32, i32, i32); // 注意这里要有分号！

fn main() {
    // 直接构造，不用new方法
    let color = Color(0, 1, 2);
    assert_eq!(color.0, 0);
    assert_eq!(color.1, 1);
    assert_eq!(color.2, 2);
}
```

使用 `.` 号按下标访问字段。

当元组结构体只有一个字段的时候，称为 New Type 模式：

```rust
#[derive(Debug, PartialEq)]
struct Integer(u32);

// 用关键字 type 为i32类型创建别名Int
type Int = i32;  

fn main() {
    let int = Integer(10);
    assert_eq!(int.0, 10);

    let int: Int = 10;
    assert_eq!(int, 10);
}
```



### Unit-Like Struct 

单元结构体是没有任何字段的结构体。

```rust
// 等价于  struct Empty {}
struct Empty;
let x = Empty;
println!("{:p}", &x);
let y = x;
println!("{:p}", &y as *const _);
let z = Empty;
println!("{:p}", &z as *const _);

// struct RangeFull;  // 标准库源码中RangeFull就是一个单元结构体
assert_eq!((..), std::ops::RangeFull); //  RangeFull就是(..)，表示全范围
```

单元结构体和  new type 模式类似，也相当于定义了一个新的类型。

单元结构体一般用于特定场景，标准库源码中RangeFull就是一个单元结构体。

### 参考资料

视频：

- [Rust: Structs](https://www.youtube.com/watch?v=jE-nqgIoN9o)
- [Rust Structs by Example Part 1](https://www.youtube.com/watch?v=WZYnqJ37QcI)
- [Rust Structs by Example Part 2](https://www.youtube.com/watch?v=tEg0PlC7Fqs)

