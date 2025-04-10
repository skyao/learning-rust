---
title: "Rustup概述"
linkTitle: "Rustup概述"
weight: 391
date: 2021-10-21
description: >
  Rust安装程序
---



## 介绍

rustup 是系统编程语言Rust的安装程序。

rustup 从官方发布渠道安装Rust编程语言，使你能够在稳定版、测试版和nightly编译器之间轻松切换并保持更新。它使交叉编译变得更加简单，为普通平台的标准库建立二进制。而且它可以在Rust支持的所有平台上运行。

### 相关信息

- https://rustup.rs/

- [rustup book](https://rust-lang.github.io/rustup/index.html): 对rustup有详细介绍

## 常用命令

### 安装rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 更新rust

```bash
rustup update
```

### 卸载rust

```bash
rustup self uninstall
```

### 打开本地文档

rust安装时会在本地生成一份离线文档，可以用下面的命令在浏览器中打开：

```bash
rustup doc
```

### 安装目标平台的标准库

 `rustup target` 命令安装目标平台的标准库

```bash
rustup target add arm-linux-androideabi
```



## 镜像安装

参考： https://mirrors.tuna.tsinghua.edu.cn/help/rustup/

