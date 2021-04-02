---
title: "Rustc的条件编译"
linkTitle: "条件编译"
date: 2021-03-29
weight: 313
description: >
  Rustc的条件编译
---

## 介绍

### 什么是条件编译？

条件编译是指根据某些条件来决定特性代码是否被视为源代码的一部分。

可以使用属性 cfg 和 cfg_attr，还有内置 cfg 宏来有条件地编译源代码。这些条件基于：已编译的crate的目标体系结构，传递给编译器的任意值，以及其他一些杂项。



### 配置谓词

条件编译的每种形式都采用评估加过为 true 或 false 的配置谓词（configuration predicate）。谓词是以下之一：

- 配置选项。如果设置了该选项，则为true；如果未设置，则为false。
- all() 用逗号分隔的配置谓词列表。只要有一个谓词为false，则为false。如果没有谓词，那就是true。
- any() 用逗号分隔的配置谓词列表。如果至少一个谓词为true，则为true。如果没有谓词，则为false。
- not() 带有配置谓词。如果其谓词为false，则为true；如果其谓词为true，则为false。

### 配置选项

配置选项是已设置或未设置的 name 和 key-value 对。name 被写为单个标识符，例如 `unix`。key-value 对被写为标识符，=，然后是字符串。例如，`target_arch = "x86_64"` 是一个配置选项。

> 注意：等号周围的空格将被忽略。`foo="bar"` 和 `foo = "bar"` 是等同的配置选项。

键在键值配置选项集中不是唯一的。例如，`feature = "std"` 和 `feature = "serde"` 可以同时设置。

## 设置配置选项

设置哪些配置选项是在板条箱的编译过程中静态确定的。某些选项在*编译器集合*根据有关统计数据。其他选项是*任意设置*，基于代码外传递给编译器的输入进行设置。无法从正在编译的板条箱的源代码中设置配置选项。

> **注意**：对于`rustc`，可以使用[`--cfg`](https://doc.rust-lang.org/rustc/command-line-arguments.html#--cfg-configure-the-compilation-environment)标志设置任意设置的配置选项 。

警告：任意设置的配置选项可能与编译器设置的配置选项具有相同的值。例如，可以`rustc --cfg "unix" program.rs`在编译到Windows目标时进行，并同时设置`unix`和`windows`配置选项。实际执行此操作是不明智的。




`#[cfg]` 是 Rust 的特殊属性，，允许基于传递给编译器的标记来编译代码。有两种形式：

```
#[cfg(foo)]

#[cfg(bar = "baz")]
```

所有的条件编译都由通过cfg配置实现，cfg支持any、all、not等逻辑谓词组合。




它还有一些帮助选项：

```
#[cfg(any(unix, windows))]

#[cfg(all(unix, target_pointer_width = "32"))]

#[cfg(not(foo))]
```

这些选项可以任意嵌套：

```
#[cfg(any(not(unix), all(target_os="macos", target_arch = "powerpc")))]
```

至于如何启用和禁用这些开关，如果使用Cargo的话，可以在 `Cargo.toml`中的[`[features\]`部分](http://doc.crates.io/manifest.html#the-[features]-section)设置：

```
[features]
# no features by default
default = []

# The “secure-password” feature depends on the bcrypt package.
secure-password = ["bcrypt"]
```

这时，Cargo会传递给 `rustc` 一个标记：

```
--cfg feature="${feature_name}"
```

这些`cfg`标记集合会决定哪些功能被启用，哪些代码会被编译。让我们看看这些代码：

```
#[cfg(feature = "foo")]
mod foo {
}
```

如果你用`cargo build --features "foo"`编译，他会向`rustc`传递`--cfg feature="foo"`标记，并且输出中将会包含`mod foo`。如果我们使用常规的`cargo build`编译，则不会传递额外的标记，因此，（输出）不会存在`foo`模块。

## cfg_attr

你也可以通过一个基于`cfg`变量的`cfg_attr`来设置另一个属性：

```
#[cfg_attr(a, b)]
```

如果`a`通过`cfg`属性设置了的话这与`#[b]`相同，否则不起作用。

# cfg!

`cfg!`[语法扩展](http://doc.rust-lang.org/nightly/book/compiler-plugins.html)也让你可以在你的代码中使用这类标记：

```
if cfg!(target_os = "macos") || cfg!(target_os = "ios") {
    println!("Think Different!");
}
```

这会在编译时被替换为一个`true`或`false`，依配置设定而定。

### 参考资料

- [Conditional compilation@the rust reference]([Conditional compilation](https://doc.rust-lang.org/reference/conditional-compilation.html#conditional-compilation))
- [条件编译@rust book 中文翻译](https://www.kancloud.cn/thinkphp/rust/36050)
- [Rust 交叉编译与条件编译总结](https://www.jianshu.com/p/0e4251bc10eb)

