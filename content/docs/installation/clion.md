---
title: "Clion设置"
linkTitle: "Clion"
date: 2021-03-29
weight: 204
description: >
  Clion安装和设置
---

## 下载

https://www.jetbrains.com/clion/download/

## 安装

### 安装clion

解压缩安装文件，按照 `Install-Linux-tar.txt` 的提示，执行 

```bash
cd /bib
./clion.sh
```

启动clion界面之后，在左下角点 "Options Menu" 按钮，点 "Create Desktop Entry..." 创建启动菜单。

### 安装rust和toml插件

在 clion 的 "settings" -> "plugin" 中，安装 Rust 和 toml 两个插件。重启 clion。

## 配置

### 安装Rust标准库

进入 "settings" -> "language & framework" 下找到 "rust"，在 "Standard library" 那里选择 "Download via Rustup" 下载。

> 备注：如果下载速度慢，建议科学上网。

### 在CLion中Debug

详细介绍参考：[Debugging - Rust | JetBrains](https://plugins.jetbrains.com/plugin/8182-rust/docs/rust-debugging.html)