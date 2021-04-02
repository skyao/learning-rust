---
title: "Rust的打印"
linkTitle: "打印"
date: 2021-03-29
weight: 1160
description: >
  Rust的打印
---

打印操作由[`std::fmt`](http://doc.rust-lang.org/std/fmt/)里面所定义的一系列宏来处理，包括：

- `format!`：将格式化文本输出到 `字符串`(String)
- `print!`：与 `format!`类似，但将文本输出到控制台
- `println!`: 与 `print!`类似，但输出结果追加一个换行符



详细的使用说明见rust官方文档：

https://doc.rust-lang.org/1.0.0/std/fmt/index.html