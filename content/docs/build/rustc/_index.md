---
title: "Rustc"
linkTitle: "Rustc"
weight: 310
date: 2021-03-29
description: >
  Rustc
---



### 介绍

`rustc`是 Rust 编程语言的编译器，由项目组开发提供。编译器将您的源代码和生产二进制代码，变成一个或可执行文件。

大多数 Rust 程序员都不会直接调用`rustc`，而是通过[Cargo](http://llever.com/cargo/index.html)来完成，虽然Cargo也是调用`rustc`流程！如果想看看 Cargo 如何调用`rustc`， 可以

```bash
$ cargo build --verbose
```

它会打印出每个`rustc`调用。

### 资料

- [The rustc book](https://doc.rust-lang.org/rustc/index.html): 官方英文版
- [The rustc book](http://llever.com/rustc-zh/): 中文翻译版。备注：经常打不开，需要科学上网。另外lint相关的内容和英文文档的内容有很大的偏差。