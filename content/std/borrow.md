---
date: 2019-04-06T16:00:00+08:00
title: borrow/借用
menu:
  main:
    parent: "std"
weight: 2053
description : "Rust标准库中的borrow module"
---

https://doc.rust-lang.org/std/borrow/index.html

用于处理借用（borrow）数据的模块。

## Cow 枚举

```rust
pub enum Cow<'a, B> where
    B: 'a + ToOwned + ?Sized,  {
    Borrowed(&'a B),
    Owned(<B as ToOwned>::Owned),
}
```

clone-on-write 智能指针。

cow = Clone On Write

类型Cow是一个智能指针，提供了 clone-on-write 功能：它可以封装并提供对借用数据的不可变访问，当需要可变或所有权时，可以延迟克隆数据。该类型是通过 Borrow trait 来处理一般的借用数据。

Cow 实现了 Deref，这意味着你可以直接在它所封装的数据上调用非可变方法。如果需要改变，to_mut 将获得一个到拥有值的可变引用，必要时进行克隆。

```rust
use std::borrow::Cow;

fn abs_all(input: &mut Cow<[i32]>) {
    for i in 0..input.len() {
        let v = input[i];
        if v < 0 {
            // Clones into a vector if not already owned.
            input.to_mut()[i] = -v;
        }
    }
}

// No clone occurs because `input` doesn't need to be mutated.
let slice = [0, 1, 2];
let mut input = Cow::from(&slice[..]);
abs_all(&mut input);

// Clone occurs because `input` needs to be mutated.
let slice = [-1, 0, 1];
let mut input = Cow::from(&slice[..]);
abs_all(&mut input);

// No clone occurs because `input` is already owned.
let mut input = Cow::from(vec![-1, 0, 1]);
abs_all(&mut input);
```











