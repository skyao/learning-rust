---
title: "Rust语法速查表"
linkTitle: "速查表"
date: 2021-03-29
weight: 1001
description: >
  Rust语法速查表
---

语法汇总和速查表。

## 基本语法

### 类型

```rust
let a = 1;  							// 定义变量，默认不可变
let b: bool = true;				// 明确指定变量类型
let mut x = 5;						// 定义可变变量
const MAX_POINTS: u32 = 100_000;   // 定义常量
let i:i32 = _f as i32;		// 转数据类型
type Int = i32;  					// 用关键字 type 为i32类型创建别名Int

// Rust 的 never 类型（ ! ）用于表示永远不可能有返回值的计算类型。
#![feature(never_type)] 	
let x:! = {
    return 123
};

// 对整行进行注释
/* ..  对区块注释  */
/// 生成库文档，一般用于函数或者结构体的说明，置于说明对象的上方
//! 也生成库文档，一般用于说明整个模块的功能，置于模块文件的头部

let tup: (i32, f64, u8) = (500, 6.4, 1);			// 元组（tuple）
let (x, y, z) = tup;													// 模式匹配（pattern matching）来解构元组值
(1,)   // 当元组中只有一个元素时，需要加逗号，即 
｀()｀  // 空元组，
let arr: [i32; 3] = [1, 2, 3];  // 数组
assert_eq!((1..5), Range{ start: 1, end: 5 }); // 范围类型，左闭右开
assert_eq!((1..=5), RangeInclusive::new(1, 5)); // 范围类型，全闭
let arr: [i32; 5] = [1, 2, 3, 4, 5];						// 固定大小数组的切片
let arr = &mut [1, 2, 3];												// 可变数组的切片
let vec = vec![1, 2, 3];												// 使用 vec! 宏定义的动态数组的切片
let str_slice: &[&str] = &["one", "two", "three"];		// 字符串数组的切片
pub struct People {															// Named-Field Struct
    name: &'static str,
    gender: u32,
} // 注意这里没有分号
let alex = People::new("Alex", 1); // 用 :: 来调用new方法，默认不可变
struct Color(i32, i32, i32); // 注意这里要有分号！ Tuple-Like Struct，字段没有名字，只有类型
let color = Color(0, 1, 2);		// 直接构造，不用new方法
struct Integer(u32); // 当元组结构体只有一个字段的时候，称为 New Type 模式
struct Empty;					// 等价于  struct Empty {}，单元结构体是没有任何字段的结构体。

enum Number {		// 无参数枚举
    Zero,
    One,
    Two,
}
enum Color {		// 类C枚举
    Red = 0xff0000,
    Green = 0x00ff00,
    Blue = 0x0000ff,
}
enum IpAddr {		// 带参数枚举
    V4(u8, u8, u8, u8),
    V6(String),
}
let mut v1 = vec![]; 					// 用宏创建可变向量
let v2 = vec![0; 10];					// 用宏创建不可变向量
let mut v3 = Vec::new();			// 用 new 方法创建向量

let a = [1,2,3]; 
let b = &a;										// 引用操作符 &，不可变，本质上是一种非空指针
let mut c = vec![1,2,3];			// 要获取可变引用，必须先声明可变绑定
let d = &mut c;								// 通过 &mut 得到可变引用

let mut x = 10;
let ptr_x = &mut x as *mut i32;			// 可变原始指针 *&mut T
let y = Box::new(20);
let ptr_y = &*y as *const i32;			// 不可变原始指针 *const T


pub fn math(op: fn(i32, i32) -> i32, a: i32, b: i32) -> i32{			/// 将函数作为参数传递
    op(a, b)				/// 通过函数指针调用函数
}
fn true_maker() -> fn() -> bool { is_true }				/// 函数的返回值是另外一个函数

let box_point = Box::new(Point { x: 0.0, y: 0.0 });		// 智能指针


```

## 流程处理

```rust
let big_n = if n < 10 && n > -10 { // if 不带括号，真不适应
    10 * n
} else {
    n / 2
};

for n in 1..101 {} 			// for … in 循环
while n < 101 {}				// while 循环
loop { }								// loop 循环，相当于一个 while true，需要程序自己 break

```

