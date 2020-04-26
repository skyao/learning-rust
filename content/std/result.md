---
date: 2019-04-06T16:00:00+08:00
title: Result
menu:
  main:
    parent: "std"
weight: 2061
description : "Rust标准库中的Result"
---

https://doc.rust-lang.org/std/result/index.html

使用Result类型的错误处理。

Result<T, E>是用于返回和传播错误的类型。它是一个枚举，其中Ok(T)代表成功并包含一值，Err(E)代表错误并包含错误值。

```rust
enum Result<T, E> {
   Ok(T),
   Err(E),
}
```

函数在预计到错误并可恢复时返回Result。在 std crate 中，Result 最显著的作用是用于 I/O。

一个简单的返回Result的函数可以这样定义和使用：

```rust
#[derive(Debug)]
enum Version { Version1, Version2 }

fn parse_version(header: &[u8]) -> Result<Version, &'static str> {
    match header.get(0) {
        None => Err("invalid header length"),
        Some(&1) => Ok(Version::Version1),
        Some(&2) => Ok(Version::Version2),
        Some(_) => Err("invalid version"),
    }
}

let version = parse_version(&[1, 2, 3, 4]);
match version {
    Ok(v) => println!("working with version: {:?}", v),
    Err(e) => println!("error parsing header: {:?}", e),
}
```

在Result上的模式匹配对于简单的案例来说是很清晰和直接的，但是Result自带的一些方便的方法可以让工作更简洁。

```rust
let good_result: Result<i32, i32> = Ok(10);
let bad_result: Result<i32, i32> = Err(10);

// The `is_ok` and `is_err` methods do what they say.
assert!(good_result.is_ok() && !good_result.is_err());
assert!(bad_result.is_err() && !bad_result.is_ok());

// `map` consumes the `Result` and produces another.
let good_result: Result<i32, i32> = good_result.map(|i| i + 1);
let bad_result: Result<i32, i32> = bad_result.map(|i| i - 1);

// Use `and_then` to continue the computation.
let good_result: Result<bool, i32> = good_result.and_then(|i| Ok(i == 11));

// Use `or_else` to handle the error.
let bad_result: Result<i32, i32> = bad_result.or_else(|i| Ok(i + 20));

// Consume the result and return the contents with `unwrap`.
let final_awesome_result = good_result.unwrap();
```

### 结果必须使用

使用返回值来表示错误，一个常见的问题是很容易忽略返回值，从而无法处理错误。Result被注释了 #[must_use] 属性，当忽略了Result值时，编译器会发出警告。这使得Result对于可能会遇到错误但不会返回有用值的函数特别有用。

考虑一下Write属性为I/O类型定义的write_all方法。

```rust
use std::io;

trait Write {
    fn write_all(&mut self, bytes: &[u8]) -> Result<(), io::Error>;
}
```

注意：Write的实际定义使用的是io::Result，它只是Result<T, io::Error>的同义词。

这个方法不会产生一个值，但是写的时候可能会失败。关键是要处理好错误的情况，不要这样写：

```rust
use std::fs::File;
use std::io::prelude::*;

let mut file = File::create("valuable_data.txt").unwrap();
// If `write_all` errors, then we'll never know, because the return
// value is ignored.
file.write_all(b"important message");
```

如果你真的在Rust中写了，编译器会给你一个警告（默认情况下，由 unused_must_use lint 控制）。

相反，如果你不想处理这个错误，你可以直接用 expect 来断言成功。如果写入失败了，这将会panic，并提供一个略微有用的消息来说明原因。

```rust
use std::fs::File;
use std::io::prelude::*;

let mut file = File::create("valuable_data.txt").unwrap();
file.write_all(b"important message").expect("failed to write message");
```

也可以简单地断言成功：

```
assert!(file.write_all(b"important message").is_ok());
```

或者使用 `?` 将错误传播到调用栈上:

```rust
fn write_message() -> io::Result<()> {
    let mut file = File::create("valuable_data.txt")?;
    file.write_all(b"important message")?;
    Ok(())
}
```

### 问号运算符?

当编写调用许多返回结果类型的函数的代码时，错误处理可能会很繁琐。问号操作符 `?`  隐藏了一些在调用堆栈中传播错误的繁文缛节。

下面这段代码:

```rust
use std::fs::File;
use std::io::prelude::*;
use std::io;

struct Info {
    name: String,
    age: i32,
    rating: i32,
}

fn write_info(info: &Info) -> io::Result<()> {
    // Early return on error
    let mut file = match File::create("my_best_friends.txt") {
           Err(e) => return Err(e),
           Ok(f) => f,
    };
    if let Err(e) = file.write_all(format!("name: {}\n", info.name).as_bytes()) {
        return Err(e)
    }
    if let Err(e) = file.write_all(format!("age: {}\n", info.age).as_bytes()) {
        return Err(e)
    }
    if let Err(e) = file.write_all(format!("rating: {}\n", info.rating).as_bytes()) {
        return Err(e)
    }
    Ok(())
}
```

将被替代为：

```rust
use std::fs::File;
use std::io::prelude::*;
use std::io;

struct Info {
    name: String,
    age: i32,
    rating: i32,
}

fn write_info(info: &Info) -> io::Result<()> {
    let mut file = File::create("my_best_friends.txt")?;
    // Early return on error
    file.write_all(format!("name: {}\n", info.name).as_bytes())?;
    file.write_all(format!("age: {}\n", info.age).as_bytes())?;
    file.write_all(format!("rating: {}\n", info.rating).as_bytes())?;
    Ok(())
}
```

这样就好很多了!

以 ? 结束的表达式将导致成功(Ok)值的 unwrap，除非结果是Err，在这种情况下，Err会从包围函数中提前返回。

?只能用于返回 Result 的函数中，因为它提供了 Err 的提前返回。

## Result Enum

```rust
#[must_use = "this `Result` may be an `Err` variant, which should be handled"]
pub enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

Result是一种类型，代表成功（Ok）或失败（Err）。

变量：

- Ok(T)： 包含成功值
- Err(E)：包含错误值

### map_or 方法

对包含的值(如果有的话)应用一个函数，或者返回提供的默认值(如果没有的话)。

传递给map_or的参数会被立即求值；如果你传递的是函数调用的结果，建议使用map_or_else，它是延迟求值。

```rust
let x: Result<_, &str> = Ok("foo");
assert_eq!(x.map_or(42, |v| v.len()), 3);

let x: Result<&str, _> = Err("bar");
assert_eq!(x.map_or(42, |v| v.len()), 42);
```

### map_or_else方法

通过将一个结果<T, E>映射到U，通过将一个函数应用到包含的Ok值，或者将一个fallback函数应用到包含的Err值。

这个函数可以用来在处理错误时解包一个成功的结果。

```rust
let k = 21;

let x : Result<_, &str> = Ok("foo");
assert_eq!(x.map_or_else(|e| k * 2, |v| v.len()), 3);

let x : Result<&str, _> = Err("bar");
assert_eq!(x.map_or_else(|e| k * 2, |v| v.len()), 42);
```