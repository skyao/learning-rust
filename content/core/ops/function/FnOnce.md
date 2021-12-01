---
title: "trait core::ops::FnOnce"
linkTitle: "FnOnce"
weight: 10110
date: 2021-11-29
description: >
 Fn 接受类似函数类型的参数并且只需要调用一次
---



## 源码

Trait `core::ops::FnOnce` 的定义如下：

```rust
pub trait FnOnce<Args> {
    /// The returned type after the call operator is used.
    #[lang = "fn_once_output"]
    #[stable(feature = "fn_once_output", since = "1.12.0")]
    type Output;

    /// Performs the call operation.
    #[unstable(feature = "fn_traits", issue = "29625")]
    extern "rust-call" fn call_once(self, args: Args) -> Self::Output;
}
```



## 官方文档

https://doc.rust-lang.org/core/ops/trait.FnOnce.html

具有按值接收者的调用运算符的版本。

可以调用 `FnOnce` 的实例，但可能无法多次调用。因此，如果唯一知道类型的是它实现 `FnOnce`，则只能调用一次。

`FnOnce` 由可能消耗捕获变量的闭包以及实现 [`FnMut`](trait.FnMut.html) 的所有类型 (例如 (safe) [函数指针](https://doc.rust-lang.org/1.56.1/std/primitive.fn.html) (因为 `FnOnce` 是 [`FnMut`](trait.FnMut.html) 的特征) ) 自动实现。

由于 [`Fn`](trait.Fn.html) 和 [`FnMut`](trait.FnMut.html) 都是 `FnOnce` 的子特性，因此可以在期望使用 `FnOnce` 的情况下使用 [`Fn`](trait.Fn.html) 或 [`FnMut`](trait.FnMut.html) 的任何实例。

当您想接受类似函数类型的参数并且只需要调用一次时，可以使用 `FnOnce` 作为绑定。 如果需要重复调用该参数，请使用 [`FnMut`](trait.FnMut.html) 作为界限; 如果还需要它不改变状态，请使用 [`Fn`](trait.Fn.html)。

有关此主题的更多信息，请参见 [Rust 编程语言](../../book/ch13-01-closures.html) 中关于闭包的章节。

还要注意的是 `Fn` traits 的特殊语法 (例如 `Fn(usize, bool) -> usize`)。对此技术细节感兴趣的人可以参考 [Rustonomicon 中的相关部分](../../nomicon/hrtb.html)。

### 示例

使用 FnOnce 参数:

```rust
fn consume_with_relish<F>(func: F)
    where F: FnOnce() -> String
{
    // `func` 使用其捕获的变量，因此不能多次运行。
    println!("Consumed: {}", func());

    println!("Delicious!");

    // 再次尝试调用 `func()` 将为 `func` 引发 `use of moved value` 错误。
}

let x = String::from("x");
let consume_and_return_x = move || x;
consume_with_relish(consume_and_return_x);

// `consume_and_return_x` 现在不能再被调用
```

