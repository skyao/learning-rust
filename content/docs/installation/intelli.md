---
title: "Intellij Rust使用"
linkTitle: "Intellij Rust"
date: 2021-03-29
weight: 205
description: >
  Intellij Rust的使用技巧
---

### 背景

intellij-rust 网站：

https://intellij-rust.github.io/

- [QUICK START](https://intellij-rust.github.io/docs/quick-start.html)
- [FEATURES](https://intellij-rust.github.io/features/): 详细介绍 intellij-rust 的特性和使用方式 

### 格式化代码

`Ctrl+Alt+L`

TBD：这个方式格式化的代码，和 rustfmt 是否一致？待验证

### 选中代码

`ctrl+w` 扩大代码选择范围，可以连续使用

`ctrl+shift+w` 缩小代码选择范围，和 `ctrl+w`  扩大的顺序相反，可以连续使用

### 代码注释

选中代码之后（包括手工选择和 `ctrl+w`），`Ctrl+Shift+/` 用块注释将代码注释为`/*  */`，`Ctrl+/` 用行注释将代码注释为`//`。

### 代码补全

`Ctrl+Space` 做代码补全，但是和输入法快捷键冲突。

`Alt+/` 是 “dumb completion”

### 代码导航

`Alt+F7` 在caret中找到使用

`Ctrl+B` goto declaration

`Ctrl+N` goto class

`Ctrl+Shift+Alt+N` goto symbol，查找任何symbol（types, methods, functions, fields），配合 `Ctrl+N` 使用

`Ctrl+U` goto super

`Ctrl+F12` 在编辑页面弹出窗口显示当前文件的文件结构

`Alt+7`在打开一个导航栏显示当前文件的文件结构

`Ctrl+Q` 显示注释

`Ctrl+Shift+P` 显示表达式的类型