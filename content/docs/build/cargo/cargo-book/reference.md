---
title: "Rust Cargo Reference笔记"
linkTitle: "Cargo Reference"
weight: 326
date: 2021-10-21
description: >
  Rust Cargo Reference笔记
---

https://doc.rust-lang.org/cargo/reference/index.html

## 3.1 指定依赖关系

你的 crates 可以依赖 crates.io 或其他注册表、git 存储库或你本地文件系统中的子目录中的其他库。你也可以暂时覆盖一个依赖的位置--例如，能够测试出你正在本地工作的依赖中的错误修复。你可以为不同的平台设置不同的依赖关系，以及只在开发期间使用的依赖关系。让我们来看看如何做到这些。

从crates.io中指定依赖项
Cargo的配置是默认在crates.io上寻找依赖项。在这种情况下，只需要名称和一个版本字符串。在货物指南中，我们指定了对时间箱的依赖。

[dependencies]
time = "0.1.12"
字符串 "0.1.12 "是一个semver版本的要求。由于这个字符串中没有任何运算符，它被解释为与我们指定"^0.1.12 "的方式相同，这被称为关心型需求。

