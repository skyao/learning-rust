---
title: "trait core::ops::FnMut"
linkTitle: "FnMut"
weight: 10120
date: 2021-11-29
description: >
 想接受类似函数类型的参数并需要反复调用它，同时允许其改变状态时使用FnMut
---



## 源码

Trait `core::ops::FnMut` 的定义如下：

```rust
pub trait FnMut<Args>: FnOnce<Args> {
    /// Performs the call operation.
    #[unstable(feature = "fn_traits", issue = "29625")]
    extern "rust-call" fn call_mut(&mut self, args: Args) -> Self::Output;
}
```

## 官方文档

https://doc.rust-lang.org/core/ops/trait.Fn.html

采用可变接收者的调用运算符的版本。

`FnMut` 的实例可以重复调用，并且可以改变状态。

`FnMut` 由闭包自动实现，闭包将可变引用引用到捕获的变量，以及实现 [`Fn`](trait.Fn.html) 的所有类型，例如 (safe) [函数指针](https://doc.rust-lang.org/1.56.1/std/primitive.fn.html) (因为 `FnMut` 是 [`Fn`](trait.Fn.html) 的特征)。 另外，对于任何实现 `FnMut` 的 `F` 类型，`&mut F` 也实现 `FnMut`。

由于 [`FnOnce`](trait.FnOnce.html) 是 `FnMut` 的 super trait，因此可以在期望 [`FnOnce`](trait.FnOnce.html) 的地方使用 `FnMut` 的任何实例，并且由于 [`Fn`](trait.Fn.html) 是 `FnMut` 的子特性，因此可以在预期 `FnMut` 的地方使用 [`Fn`](trait.Fn.html) 的任何实例。

当您想接受类似函数类型的参数并需要反复调用它，同时允许其改变状态时，请使用 `FnMut` 作为绑定。 如果您不希望参数改变状态，请使用 [`Fn`](trait.Fn.html) 作为绑定; 如果不需要重复调用，请使用 [`FnOnce`](trait.FnOnce.html)。

有关此主题的更多信息，请参见 [Rust 编程语言](../../book/ch13-01-closures.html) 中关于闭包的章节。

还要注意的是 `Fn` traits 的特殊语法 (例如 `Fn(usize, bool) -> usize`)。对此技术细节感兴趣的人可以参考 [Rustonomicon 中的相关部分](../../nomicon/hrtb.html)。

### 示例

调用可变捕获闭包

```rust
let mut x = 5;
{
    let mut square_x = || x *= x;
    square_x();
}
assert_eq!(x, 25);
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



