---
date: 2019-03-05T07:00:00+08:00
title: 返回值
menu:
  main:
    parent: "grammar-basic"
weight: 318
description : "Rust中的返回值"
---

### 为什么使用返回值而不是异常

[Why Rust uses Return Values for errors instead of Exceptions](https://mattgathu.github.io/why-rust-return-values-errors/)

我经常问自己，为什么Rust中的错误处理使用返回值而不是异常，在此进行解释，我引用在这里以备将来。

> 有些人需要在不允许使用 Exception 的地方使用Rust（因为展开表和清理代码太大）。这些人实际上包括所有浏览器供应商和游戏开发人员。此外， Exception 具有讨厌的代码生成权衡。您要么将它们设为零成本（如C ++，Obj-C和Swift编译器通常所做的那样），在这种情况下，在运行时抛出异常的代价非常高，或者使它们成为非零成本（如Java HotSpot和Go 6g/8g），在这种情况下，即使没有引发异常，您也会为每个 try 块（在Go中为defer）牺牲性能。对于使用RAII的语言，每个带有析构函数的堆栈对象都形成一个隐式try块，因此在实践中这是不切实际的。
>
> 零成本 Exception 的性能开销不是理论问题。我记得关于使用GCJ（使用零成本 Exception）进行编译时，Eclipse 需要花费30秒来启动的故事，因为它在启动时会引发数千个 Exception。
>
> 当您同时考虑错误和成功路径时，相对于 Exception，C处理错误的方法具有出色的性能和代码大小，这就是为什么系统代码非常喜欢它的原因。然而，它的人机工程学和安全性很差，Rust用Result来解决。Rust的方法形成了一种混合体，旨在实现C错误处理的性能，同时消除其陷阱。