---
title: "trait core::ops::Fn"
linkTitle: "Fn"
weight: 10130
date: 2021-11-29
description: >
 Fn 由只对捕获的变量进行不可变引用或根本不捕获任何内容
---



## 源码

Trait `core::ops::Fn` 的定义如下：

```rust
pub trait Fn<Args>: FnMut<Args> {
    /// Performs the call operation.
    #[unstable(feature = "fn_traits", issue = "29625")]
    extern "rust-call" fn call(&self, args: Args) -> Self::Output;
}
```





## 官方文档

https://doc.rust-lang.org/core/ops/trait.Fn.html

采用不可变接收者的调用运算符的版本。

`Fn` 的实例可以在不改变状态的情况下重复调用。

*请勿将此 trait (`Fn`) 与 [函数指针](https://doc.rust-lang.org/1.56.1/std/primitive.fn.html) (`fn`) 混淆。*

`Fn` 由闭包自动实现，闭包只对捕获的变量进行不可变引用或根本不捕获任何内容，还有 (安全) [函数指针](https://doc.rust-lang.org/1.56.1/std/primitive.fn.html) (有一些警告，请参见其文档以获取更多详细信息)。

此外，对于实现 `Fn` 的任何类型 `F`，`&F` 也实现了 `Fn`。

由于 [`FnMut`](trait.FnMut.html) 和 [`FnOnce`](trait.FnOnce.html) 都是 `Fn` 的 supertraits，因此 `Fn` 的任何实例都可以用作参数，其中需要 [`FnMut`](trait.FnMut.html) 或 [`FnOnce`](trait.FnOnce.html)。

当您要接受类似函数类型的参数并且需要反复调用且不改变状态 (例如，同时调用它) 时，请使用 `Fn` 作为绑定。 如果不需要严格的要求，请使用 [`FnMut`](trait.FnMut.html) 或 [`FnOnce`](trait.FnOnce.html) 作为界限。

有关此主题的更多信息，请参见 [Rust 编程语言](../../book/ch13-01-closures.html) 中关于闭包的章节。

还要注意的是 `Fn` traits 的特殊语法 (例如 `Fn(usize, bool) -> usize`)。对此技术细节感兴趣的人可以参考 [Rustonomicon 中的相关部分](../../nomicon/hrtb.html)。

### 示例

调用一个闭包：

```rust
let square = |x| x * x;
assert_eq!(square(5), 25);
```

使用 Fn 参数：

```rust
fn call_with_one<F>(func: F) -> usize
    where F: Fn(usize) -> usize {
    func(1)
}

let double = |x| x * 2;
assert_eq!(call_with_one(double), 2);
```



