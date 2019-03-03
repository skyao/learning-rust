---
date: 2019-03-03T21:00:00+08:00
title: 版本升级
menu:
  main:
    parent: "installation"
weight: 203
description : "升级Rust版本"
---

### 曾经遇到的问题

尝试过升级已经安装的rust/cargo，试图从1.22.1升级到1.23，发现重新运行rustup脚本，虽然报告说安装成功，但是实际不会安装新的版本。

暂时没有找到升级的方法，只好用最笨的办法，先删除再全新安装：

```bash
cd
rm -rf .cargo/ .rustup/
```

这个方式理所当然的很不好，原有的所有内容都要重头来一次。

TBD：需要找到升级rust和cargo的正确方式
TBD：不确认新版本是否还有这个问题，下次升级版本时再试。

### 官方方式

通过 `rustup` 安装了 Rust 之后，更新到最新版本只要运行如下更新脚本：

```
$ rustup update
```

如果要卸载 Rust 和 `rustup`，运行如下卸载脚本:

```
$ rustup self uninstall
```

TBD：下次验证