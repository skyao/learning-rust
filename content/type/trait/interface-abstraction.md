---
date: 2019-03-31T16:00:00+08:00
title: 接口抽象
menu:
  main:
    parent: "type-trait"
weight: 441
description : "Rust trait的接口抽象"
---

使用泛型编程时，很多情况下，并不是针对所有的类型。因此需要用trait作为泛型的约束。

### Trait限定

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

### trait一致性

孤儿规则（Orphan Rule）：

如果要实现某个trait，那么该trait和要实现该trait的类型至少有一个要在当前crate中定义。

```rust
// 不能使用标准库中的Add，需要在当前crate中定义Add
trait Add<RHS=Self> {
    type Output;
    fn add(self, rhs: RHS) -> Self::Output;
}
impl Add<u64> for u32{
    type Output = u64;
    fn add(self, other: u64) -> Self::Output {
        (self as u64) + other
    }
}
let a = 1u32;
let b = 2u64;
// 要用add方法，而不是+操作符
assert_eq!(a.add(b), 3);
```

### trait继承

Rust不支持对象继承，但是支持 trait 继承。

```rust
    trait Page{
        fn set_page(&self, p: i32){
            println!("Page Default: 1");
        }
    }
    trait PerPage{
        fn set_perpage(&self, num: i32){
            println!("Per Page Default: 10");
        }
    }
	// 冒号表示继承，加号表示继承有多个trait
    trait Paginate: Page + PerPage{
        fn set_skip_page(&self, num: i32){
            println!("Skip Page : {:?}", num);
        }
    }
	// 为泛型T实现Paginate
	// 而泛型T定义为实现了Page + PerPage
	// 好处就是可以自动实现各种类型的Impl，而不必如下面显式声明
    impl <T: Page + PerPage>Paginate for T{}

    struct MyPaginate{ page: i32 }
    impl Page for MyPaginate{}
    impl PerPage for MyPaginate{}
	// 可以手工实现对Paginate的impl
	// 也可以通过上面的泛型T自动实现
	//impl Paginate for MyPaginate{}
    let my_paginate = MyPaginate{page: 1};
    my_paginate.set_page(2);
    my_paginate.set_perpage(100);
    my_paginate.set_skip_page(12);
```

