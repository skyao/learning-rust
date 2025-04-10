---
title: "用use关键字将路径纳入范围"
linkTitle: "用use关键字将路径纳入范围"
weight: 4
date: 2021-11-06
description: >
  用use关键字将路径纳入范围
---

https://doc.rust-lang.org/book/ch07-04-bringing-paths-into-scope-with-the-use-keyword.html

到目前为止，我们所写的调用函数的路径可能看起来很不方便，而且是重复的。例如，在清单7-7中，无论我们选择绝对路径还是相对路径来调用`add_to_waitlist` 函数，每次我们想调用 `add_to_waitlist` 时都必须指定 `front_of_house` 和 `hosting`。幸运的是，有一种方法可以简化这个过程。我们可以把一个路径带入一个作用域中，然后用 `use` 关键字来调用这个路径中的项目，就像它们是本地项目一样。

在清单 7-11 中，我们将 `crate::front_of_house::hosting` 模块带入 `eat_at_restaurant` 函数的作用域中，因此我们只需要指定 `hosting::add_to_waitlist` 来调用 `eat_at_restaurant` 的 `add_to_waitlist` 函数。

文件名： src/lib.rs

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}

```

清单 7-11: 用 use 将模块带入作用域

在作用域中添加 `use` 和路径类似于在文件系统中创建符号链接。通过在 crate root 中添加 `use crate::front_of_house::hosting`，`hosting` 现在是该作用域中的一个有效名称，就像 `hosting` 模块在 `crate` 根中被定义一样。用 use 带入作用域的路径也检查隐私，就像其他路径一样。

你也可以用 use 和一个相对路径把一个项目带入作用域。清单 7-12 显示了如何指定一个相对路径以获得与清单 7-11 中相同的行为。

文件名： `src/lib.rs`

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use self::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

清单 7-12: 用use和相对路径将模块带入作用域

## 创建习惯性的使用路径

在清单 7-11 中，你可能想知道为什么我们指定了 `use crate::front_of_house::hosting`，然后在 `eat_at_restaurant` 中调用 `hosting::add_to_waitlist`，而不是像清单 7-13 中那样一直指定 `use` 路径到 `add_to_waitlist` 函数以达到相同的结果。

文件名： src/lib.rs

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting::add_to_waitlist;

pub fn eat_at_restaurant() {
    add_to_waitlist();
    add_to_waitlist();
    add_to_waitlist();
}
```

清单 7-13: 用 use 把 `add_to_waitlist` 函数带入作用域，这是不规范的做法

尽管清单 7-11 和 7-13 完成了同样的任务，但清单 7-11 是用 use 将函数带入作用域的习惯性方法。用 use 将函数的父模块带入作用域意味着我们必须在调用函数时指定父模块。在调用函数时指定父模块可以清楚地表明该函数不是本地定义的，同时还可以尽量减少全路径的重复。清单7-13中的代码不清楚`add_to_waitlist` 是在哪里定义的。

另一方面，当引入结构体、枚举和其他使用的项目时，指定完整的路径是一种习惯做法。清单 7-14 显示了将标准库的 HashMap 结构带入二进制 crate 的范围的习惯性方法。

文件名：`src/main.rs`

```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert(1, 2);
}
```

清单7-14：以一种习惯性的方式将HashMap带入范围内

这个习惯性背后没有什么强大的理由：这只是已经出现的惯例，人们已经习惯了这样阅读和编写Rust代码。

这个习惯的例外是，如果我们用use语句将两个同名的项目带入作用域，因为Rust不允许这样做。清单7-15显示了如何将两个名字相同但父模块不同的结果类型带入作用域以及如何引用它们。

文件名：`src/lib.rs`

```rust
use std::fmt;
use std::io;

fn function1() -> fmt::Result {
    // --snip--
    Ok(())
}

fn function2() -> io::Result<()> {
    // --snip--
    Ok(())
}
```

清单 7-15: 将两个同名的类型带入同一个作用域需要使用它们的父模块。

正如你所看到的，使用父模块可以区分这两种结果类型。如果我们指定使用 `std::fmt::Result` 和使用 `std::io::Result`，我们就会有两个Result类型在同一个作用域中，Rust就不知道我们使用Result时指的是哪一个。

## 用 as 关键字提供新的名字

对于用 use 将两个同名的类型带入同一个作用域的问题，还有一个解决办法：在路径之后，我们可以指定 `as` 和一个新的本地名称，或别名，作为该类型的名称。清单 7-16 显示了另一种编写清单 7-15 中代码的方法，即用 `as` 重命名两个 Result 类型中的一个。

文件名：`src/lib.rs`

```rust
use std::fmt::Result;
use std::io::Result as IoResult;

fn function1() -> Result {
    // --snip--
    Ok(())
}

fn function2() -> IoResult<()> {
    // --snip--
    Ok(())
}
```

在第二个使用语句中，我们为 `std::io::Result` 类型选择了新的名字 `IoResult`，这不会与我们也带入范围的 `std::fmt` 的 Result 冲突。清单 7-15 和清单 7-16 被认为是习惯性的，所以选择由你决定

## 用pub的方式重新输出名字

当我们用 `use` 关键字将一个名字带入作用域时，新作用域中的名字是私有的。为了使调用我们代码的代码能够引用该名称，就像它被定义在该代码的作用域中一样，我们可以结合 `pub` 和 `use`。这种技术被称为"再输出"，因为我们把一个项目带入作用域，同时也使这个项目可以被其他人带入他们的作用域。

清单 7-17 显示了清单 7-11 中的代码，根模块中的 `use` 改为 `pub use`。

文件名：`src/lib.rs`

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

清单 7-17: 用pub use使名字可供任何代码从新的作用域中使用

通过使用 `pub use`，外部代码现在可以使用 `hosting::add_to_waitlist` 调用 `add_to_waitlist` 函数。如果我们没有指定 pub 使用，`eat_at_restaurant` 函数可以在它的作用域中调用 `hosting::add_to_waitlist`，但是外部代码不能利用这个新路径。

当你的代码的内部结构与调用你的代码的程序员对该领域的思考方式不同时，重新输出是很有用的。例如，在这个餐厅的比喻中，经营餐厅的人思考的是 "前厅 "和 "后厨"。但是来餐厅的顾客可能不会用这些术语来思考餐厅的各个部分。通过酒馆的使用，我们可以用一种结构来写我们的代码，但暴露出不同的结构。这样做使我们的库对从事库工作的程序员和调用库的程序员都有很好的组织。

## 使用外部包

在第二章中，我们编写了一个猜谜游戏项目，该项目使用了一个名为 `rand` 的外部包来获取随机数。为了在我们的项目中使用 `rand`，我们在 `Cargo.toml` 中添加了这一行。

文件名：`Cargo.toml`

```toml
rand = "0.8.3"
```

在 `Cargo.toml` 中把 `rand` 作为一个依赖项，告诉 `Cargo` 从 `crates.io` 下载 `rand` 包和任何依赖项，使 `rand` 对我们的项目可用。

然后，为了将 `rand` 的定义带入我们包的范围，我们添加了一个以 `crates.io` 的名字为开头的 `use` 行，并列出了我们想带入范围的项目。回想一下，在第2章的"生成随机数"部分，我们将 `Rng` 特性带入范围，并调用了 `rand::thread_rng` 函数。

```rust
use rand::Rng;

fn main() {
    let secret_number = rand::thread_rng().gen_range(1..101);
}
```

Rust社区的成员在 `crates.io` 上提供了许多包，将它们中的任何一个拉到你的包中都包括这些相同的步骤：在你的包的 `Cargo.toml` 文件中列出它们，并使用 `use` 将它们的包中的项目引入范围。

请注意，标准库（std）也是我们包外部的一个crate。因为标准库是和Rust语言一起提供的，所以我们不需要修改 `Cargo.toml` 来包括std。但我们需要用`use` 来引用它，把那里的项目引入我们包的范围。例如，对于 `HashMap`，我们可以使用这一行。

```rust
use std::collections::HashMap;
```

这是一个以 std 开头的绝对路径，是标准库 crate 的名称。

## 使用嵌套路径来清理大型使用列表

如果我们使用定义在同一crate或同一模块中的多个项目，将每个项目列在自己的行中会占用我们文件中大量的垂直空间。例如，我们在清单2-4中的猜谜游戏中的这两条使用语句将std中的项目带入范围。

文件名： `src/main.rs`

```rust
// --snip--
use std::cmp::Ordering;
use std::io;
// --snip--
```

相反，我们可以使用嵌套的路径，在一行中把相同的项目纳入范围。我们通过指定路径的共同部分，后面是两个冒号，然后用大括号列出路径中不同的部分，如清单7-18所示。

文件名： `src/main.rs`

```rust
// --snip--
use std::{cmp::Ordering, io};
// --snip--
```

清单 7-18: 指定嵌套路径，将具有相同前缀的多个项目带入作用域

在更大的程序中，使用嵌套路径将许多项目从同一个crate或模块带入作用域，可以减少很多单独的 `use` 语句的数量。

我们可以在路径中的任何一级使用嵌套路径，这在合并两个共享子路径的使用语句时很有用。例如，清单 7-19 显示了两条使用语句：一条将 `std::io` 带入作用域，另一条将 `std::io::Write` 带入作用域。

文件名：`src/lib.rs`

```rust
use std::io;
use std::io::Write;
```

清单7-19: 两个使用语句，其中一个是另一个的子路径

这两个路径的共同部分是 `std::io`，这就是完整的第一个路径。为了将这两条路径合并为一条使用语句，我们可以在嵌套路径中使用 `self`，如清单7-20所示。

文件名：`src/lib.rs`

```rust
use std::io::{self, Write};
```

清单7-20: 将清单 7-19 中的路径组合成一个 use 语句

这一行将 `std::io` 和 `std::io::Write` 带入范围。

## Glob 操作符

如果我们想把某个路径中定义的所有公共项目都带入作用域，我们可以在该路径后面指定`*`，即glob操作符。

```rust
use std::collections::*;
```

这个 `use` 语句将所有定义在 `std::collection` 中的公共项目带入当前的作用域。在使用 `glob` 操作符的时候要小心! `glob` 会使你更难分辨哪些名字在作用域中，以及你程序中使用的名字是在哪里定义的。

在测试时，`glob` 操作符经常被用来将所有被测试的东西带入测试模块；我们将在第11章的 "如何编写测试" 一节中讨论这个问题。glob 操作符有时也作为 prelude 模式的一部分使用：关于这种模式的更多信息，请参见标准库文档。

