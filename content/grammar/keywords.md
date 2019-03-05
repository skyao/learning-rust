---
date: 2019-03-05T07:00:00+08:00
title: 语法速查表
menu:
  main:
    parent: "grammar"
weight: 301
description : "Rust的语法速查表"
---


## 关键字

| 关键字 | 说明 | 示例 | 补充 |
|--------|--------|--------|--------|
|   extern crate    |    [链接外部crate](crate/link.md)    | extern crate crate_name | |
|      |     | extern crate crate_name as alias_name | 为create取别名 |
|   fn     |        |  |
|   let     |    [定义变量](basic/variable.html)    | let a = 1; | 定义不可变变量 |
|        |       | let a:i32 = 1; | 显式指定变量类型 |
|        |        | let mut a = 1; | 定义可变变量 |
|   const     |    [定义常量](basic/const.html)    | const MAX_POINTS: u32 = 100; |  |

## 符号

| 符号 | 说明 | 示例 | 补充 |
|--------|--------|--------|--------|
|   ::    |    [调用外部crate](crate/link.md)    | crate_name::modname.publicMeth() | |
