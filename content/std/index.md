---
date: 2019-03-27T18:00:00+08:00
title: 标准库
weight: 2000
description : "Rust中的标准库"
---

### 介绍

https://doc.rust-lang.org/std/

Rust语言标准库是让Rust语言开发的软件具备可移植性的基础，它是一组最小的、经过实战检验的共享抽象，适用于更广泛的Rust生态系统。它提供了核心类型，如Vec<T>和Option<T>、类库定义的语言原语操作、标准宏、I/O和多线程等。

默认情况下，所有Rust crate都可以使用std。因此，标准库可以在 use 语句中通过路径 std 访问标准库，如 `std:::env`。

标准库的内容有：

- [`std::*` modules / std 模块](https://doc.rust-lang.org/std/#modules)
- [Primitive types / 基本数据类型](https://doc.rust-lang.org/std/#primitives)
- [Standard macros / 标准宏](https://doc.rust-lang.org/std/#macros)
- [The Rust Prelude / Rust语言序幕](https://doc.rust-lang.org/std/prelude/index.html)

Async std中文文档

https://learnku.com/docs/rust-async-std/translation-notes/7132

sync：

- Arc
- Mutex


collections:

- BTreeMap
- HashMap


其他内容：

```rust
#[derive(Debug, Clone)]
```

