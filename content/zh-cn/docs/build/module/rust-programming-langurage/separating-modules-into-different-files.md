---
title: "将模块分离到不同的文件中"
linkTitle: "将模块分离到不同的文件中"
weight: 5
date: 2021-11-06
description: >
  将模块分离到不同的文件中
---

https://doc.rust-lang.org/book/ch07-05-separating-modules-into-different-files.html

到目前为止，本章中所有的例子都是在一个文件中定义多个模块。当模块变得很大时，你可能想把它们的定义移到一个单独的文件中，以使代码更容易浏览。

例如，让我们从清单7-17中的代码开始，将 `front_of_house` 模块移到它自己的文件 `src/front_of_house.rs` 中，改变 crate root 文件，使其包含清单7-21中的代码。在这个例子中，crate root 文件是 `src/lib.rs`，但这个过程也适用于 crate root 文件为 `src/main.rs` 的二进制crate。

文件名：src/lib.rs

```rust
mod front_of_house;

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

清单 7-21: 声明 `front_of_house` 模块，其主体将在 `src/front_of_house.rs` 中。

而 `src/front_of_house.rs` 则从 `front_of_house` 模块的主体中获取定义，如清单 7-22 所示。

文件名：`src/front_of_house.rs`

```rust
pub mod hosting {
    pub fn add_to_waitlist() {}
}
```

清单 7-22: `src/front_of_house.rs` 中 `front_of_house` 模块内部的定义

在 `mod front_of_house` 后面使用分号，而不是使用块，是告诉 Rust 从与该模块同名的另一个文件中加载该模块的内容。为了继续我们的例子并将 hosting 模块也提取到自己的文件中，我们将 `src/front_of_house.rs` 改为只包含 hosting 模块的声明。

文件名：`src/front_of_house.rs`

```rust
pub mod hosting;
```

然后我们创建一个 `src/front_of_house` 目录和一个 `src/front_of_house/hosting.rs` 文件，以包含 hosting 模块中的定义。

文件名：`src/front_of_house/hosting.rs`

```rust
pub fn add_to_waitlist() {}
```

模块树保持不变，`eat_at_restaurant` 中的函数调用将不做任何修改，即使定义在不同的文件中。这种技术可以让你在模块体积增大时将其移到新的文件中。

注意 `src/lib.rs` 中的 `pub use crate::front_of_house::hosting` 语句也没有改变，使用也不会对哪些文件作为 `crate` 的一部分被编译产生任何影响。mod 关键字声明了模块，Rust 会在与模块同名的文件中寻找进入该模块的代码。

## 总结

Rust允许你把包分成多个crate，把crate 分成模块，这样你就可以从另一个模块引用一个模块中定义的项目。你可以通过指定绝对或相对路径来做到这一点。这些路径可以被带入使用语句的范围内，这样你就可以在该范围内使用一个较短的路径来多次使用该项目。模块代码默认是私有的，但你可以通过添加pub关键字使定义公开。

