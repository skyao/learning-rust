---
title: "Rust的IDE选择和设置"
linkTitle: "IDE"
date: 2021-03-29
weight: 204
description: >
  Rust的IDE选择和设置
---

## IDE的选择

- [Rust目前有比较靠谱的IDE吗？](https://www.zhihu.com/question/40914986)： 来自知乎
- [What IDE do you use?](https://www.reddit.com/r/rust/comments/7vgelh/what_ide_do_you_use/): 来自 reddit

2018年最好的 Rust IDE 应该是 JetBains 家的 CLion，准确来说是 IntelliJ Rust + CLion的组合。

考虑到个人习惯，一直在用InteliJ 、Goland、CLion 系列，因此选择 intellij-rust尤其是 Clion 就是自然而言的事情。

## Intellij Rust

intellij-rust 网站：

https://intellij-rust.github.io/

- [QUICK START](https://intellij-rust.github.io/docs/quick-start.html)
- [FEATURES](https://intellij-rust.github.io/features/): 详细介绍 intellij-rust 的特性和使用方式 

## CLion

### 安装Rust插件

在 `file -> settings -> plugins` 中选择"Marketplace"，然后搜索"rust"和"toml"，分别安装这两个插件。完成后重启。

### 安装Rust标准库

在设置中，搜索rust，进入“language & framework”下，在"Standard library"那里选择用rustc下载。

### Cargo设置

每个项目的 cargo path 可以通过 `Settings > Languages & Frameworks > Rust` 来设置。

### 在CLion中Debug

详细介绍参考：https://github.com/intellij-rust/intellij-rust/issues/535