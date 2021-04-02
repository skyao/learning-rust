---
title: "Rust安装"
linkTitle: "安装"
weight: 200
date: 2021-03-29
description: >
  Rust安装
---

### 安装

Rust安装方式参考官方地址：

https://www.rust-lang.org/en-US/install.html

根据不同的操作系统安装方式不同。

### 文档

安装程序自带一份文档的本地拷贝，可以离线阅读。

运行 `rustup doc` 在浏览器中查看本地文档。

### nightly build 版本

```bash
# 默认安装是 stable版本
$ rustc --version
rustc 1.42.0 (b8cedc004 2020-03-09)

# 安装nightly版本
$ rustup toolchain install nightly
info: syncing channel updates for 'nightly-x86_64-unknown-linux-gnu'
info: latest update on 2020-03-29, rust version 1.44.0-nightly (77621317d 2020-03-28)
......
  nightly-x86_64-unknown-linux-gnu installed - rustc 1.44.0-nightly (f509b26a7 2020-03-18)

info: checking for self-updates

# 修改默认使用nightly版本
$ rustup default nightly
info: using existing install for 'nightly-x86_64-unknown-linux-gnu'
info: default toolchain set to 'nightly-x86_64-unknown-linux-gnu'

  nightly-x86_64-unknown-linux-gnu unchanged - rustc 1.44.0-nightly (f509b26a7 2020-03-18)

# 再检查，已经改成nightly版本了
$ rustc --version
rustc 1.44.0-nightly (f509b26a7 2020-03-18)

```

