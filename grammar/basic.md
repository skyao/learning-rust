## 基础语法

### 变量

```rust
//默认定义不可变变量
let x = 5;
//定义可变变量
let mut y = 5;
```

变量隐藏（Shadowing），非常不解的特性，感觉容易造成代码可读性问题。能不用就不用吧。

### 常量

常量使用下划线分隔的大写字母的命名规范.

```rust
const MAX_POINTS: u32 = 100_000;
```

注意：常量只能用于常量表达式，而不能作为函数调用的结果，或任何其他只在运行时计算的值。

## 数据类型

- Rust是强类型语言：在Rust中，任何值都属于一种明确的类型。
- Rust是静态类型语言：在编译时就必须知道所有变量的类型

编译器通常可以推断出我们想要用的类型，如果不能，则必须增加类型说明。

```rust
let guess: u32 = "42".parse().expect("Not a number!");
```

### 标量类型

标量（scalar）类型代表一个单独的值。Rust 有四种基本的标量类型：整型、浮点型、布尔类型和字符类型。

详细见：

- https://kaisery.github.io/trpl-zh-cn/ch03-02-data-types.html

### 复合类型

复合类型（Compound types）可以将多个其他类型的值组合成一个类型。Rust 有两个原生的复合类型：元组（tuple）和数组（array）。

#### tuple

元组是一个将多个其他类型的值组合进一个复合类型的主要方式。

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);

//取值方式1：模式匹配
let (x, y, z) = tup;
//取值方式2：索引
let x = tup.0;
```

#### array

- 与元组不同，数组中的每个元素的类型必须相同。
- Rust中的数组是固定长度的
- 数组是一整块分配在**栈**上的内存

```rust
let a = [1, 2, 3, 4, 5];

//取值方式：索引
let x = a.0;
```

## 函数

- 关键字:fn
- 函数名：snake case，所有字母都是小写并使用下划线分隔单词
- 参数：在函数签名中，必须声明每个参数的类型。

### 语句和表达式

- 语句（Statements）是执行一些操作但不返回值的指令。
- 表达式（Expressions）计算并产生一个值。

注意：表达式并不包含结尾的分号。如果在表达式的结尾加上分号，他就变成了语句，这也就使其不返回一个值。

## 注释

只有一种注释方式？

```rust
// Hello, world.
```

## 控制流

### 判断

```rust
if number < 5 {
    println!("condition was true");
} else {
    println!("condition was false");
}
```

- if 后面的表达式，不用加括号
- if 后面的表达式，只能是`bool`

### 循环

#### loop循环

loop 关键字告诉Rust一遍又一遍的执行一段代码直到你明确要求停止。配合if和break实现跳出循环。

```rust
loop {
    println!("again!");
    if x {
        break;
    }
}
```

#### while循环

while等同于loop+if+break。

```rust
let mut number = 3;
while number != 0 {
    println!("{}!", number);

    number = number - 1;
}
```

#### for循环

for循环来对一个集合的每个元素执行一些代码，来作为一个更有效率的替代

```rust
let a = [10, 20, 30, 40, 50];

for element in a.iter() {
    println!("the value is: {}", element);
}
```



