---
title: "Package和Crate"
linkTitle: "Package和Crate"
weight: 2
date: 2021-11-06
description: >
  Package和Crate
---

https://doc.rust-lang.org/book/ch07-01-packages-and-crates.html

我们要讨论的模块系统的第一部分是 package 和 crate。crate 是一个二进制文件或库。crate root 是一个源文件，Rust编译器从它开始，构成了你的crate的根模块（我们将在 "定义模块以控制范围和隐私" 部分深入解释模块）。包是一个或多个提供一系列功能的crate。Package 包含一个 `Cargo.toml` 文件，描述如何构建这些 crate。

一些规则决定了 package 可以包含什么。一个 package 最多可以包含一个库crate。它可以包含任何你想要的二进制crate，但它必须至少包含一个crate（无论是库还是二进制）。

让我们来看看我们创建一个 package 时发生了什么。首先，我们输入 `cargo new` 命令:

```bash
$ cargo new my-project
     Created binary (application) `my-project` package
$ ls my-project
Cargo.toml
src
$ ls my-project/src
main.rs
```

当我们输入命令时，Cargo创建了一个 `Cargo.toml` 文件，给了我们一个 package。看一下 `Cargo.toml` 的内容，没有提到 `src/main.rs`，因为 Cargo 遵循的惯例是 `src/main.rs` 是与 package 同名的二进制 crate 的 crate 根。同样地，Cargo 知道如果包的目录中包含 `src/lib.rs`，那么该 package 就包含一个与该 package 同名的库 crate，而 `src/lib.rs` 是其 crate 根。Cargo 会将 crate 根文件传递给 rustc 来构建库或二进制文件。

这里，我们有一个只包含 `src/main.rs` 的 package，意味着它只包含一个名为 `my-project` 的二进制 crate。如果一个包包含 `src/main.rs` 和 `src/lib.rs`，那么它就有两个crate：一个库和一个二进制，两者的名字都与包相同。通过在 `src/bin` 目录中放置文件，一个包可以有多个二进制 crate：每个文件都是一个单独的二进制 crate。

一个 crate 将把相关的功能集中在一个范围内，这样功能就很容易在多个项目之间共享。例如，我们在第二章中使用的 `rand` crate 提供了生成随机数的功能。我们可以在自己的项目中使用该功能，方法是将 `rand` crate 带入我们项目的作用域。所有由 `rand` crate 提供的功能都可以通过 crate 的名称 `rand` 来访问。

将 crate 的功能保留在自己的范围内，可以明确特定的功能是在我们的 crate 还是rand crate 中定义的，并防止潜在的冲突。例如，`rand` crate 提供了一个名为 `Rng` 的 trait。我们也可以在自己的 crate 中定义一个名为 `Rng` 的结构。因为 crate 的功能是在它自己的范围内命名的，所以当我们添加 `rand` 作为依赖关系时，编译器不会对 `Rng` 这个名字的含义感到困惑。在我们的 crate 中，它指的是我们定义的 `Rng` 结构体。我们将从 `rand` crate 中访问 `Rng` 的特性，即 `rand::Rng` 。

让我们继续谈一谈模块系统吧。
