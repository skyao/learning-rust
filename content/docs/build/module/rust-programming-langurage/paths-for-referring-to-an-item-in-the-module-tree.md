---
title: "用于引用模块树中项目的路径"
linkTitle: "用于引用模块树中项目的路径"
weight: 3
date: 2021-11-06
description: >
  用于引用模块树中项目的路径
---

https://doc.rust-lang.org/book/ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html

为了向 rust 展示在模块树中的哪里找到项目，我们使用路径，就像我们在浏览文件系统时使用路径一样。如果我们想调用一个函数，我们需要知道它的路径。

路径可以有两种形式：

- 绝对路径从 crate root 开始，通过使用 crate name 或字面 crate。

- 相对路径从当前模块开始，使用 `self`、`super`或当前模块中的标识符。

绝对路径和相对路径后面都有一个或多个标识符，用双冒号（`::`）分开。

让我们回到清单7-1中的例子。我们如何调用 `add_to_waitlist` 函数？这就等于问，`add_to_waitlist` 函数的路径是什么？在清单7-3中，我们通过删除一些模块和函数来简化我们的代码。我们将展示两种方法，从定义在 crate root 的新函数 `eat_at_restaurant` 中调用 `add_to_waitlist` 函数。`eat_at_restaurant` 函数是我们库中 public API的一部分，所以我们用 `pub` 关键字标记它。在 "用pub关键字暴露路径" 一节中，我们将详细介绍 `pub`。注意，这个例子还不能编译；我们稍后会解释原因。

文件名：`src/lib.rs`

```rust
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```

清单7-3：使用绝对和相对路径调用 `add_to_waitlist` 函数

我们第一次在 `eat_at_restaurant` 中调用 `add_to_waitlist` 函数时，使用了一个绝对路径。`add_to_waitlist` 函数与 `eat_at_restaurant` 定义在同一个 `crate` 中，这意味着我们可以使用 `crate` 关键字来启用绝对路径。

在 `crate` 之后，我们包括每一个连续的模块，直到我们到达 `add_to_waitlist`。你可以想象一个具有相同结构的文件系统，我们会指定路径 `/front_of_house/hosting/add_to_waitlist` 来运行 `add_to_waitlist` 程序；使用 `crate` 名称从 `crate root` 开始，就像在 shell 中使用 `/` 从文件系统根开始。

第二次我们在 `eat_at_restaurant` 中调用 `add_to_waitlist`，我们使用了一个相对路径。路径以 `front_of_house` 开始，它是定义在与 `eat_at_restaurant` 相同级别的模块树上的模块名称。在这里，文件系统的对应路径是 `front_of_house/hosting/add_to_waitlist`。以一个名字开始意味着路径是相对的。

选择使用相对路径还是绝对路径是你根据你的项目做出的决定。这个决定应该取决于你是更倾向于将项目定义代码与使用该项目的代码分开移动，还是一起移动。例如，如果我们将 `front_of_house` 模块和 `eat_at_restaurant` 函数移到一个名为 `customer_experience` 的模块中，我们需要更新 `add_to_waitlist` 的绝对路径，但相对路径仍然有效。然而，如果我们将 `eat_at_restaurant` 函数单独移到名为 `dining` 的模块中，那么调用 `add_to_waitlist` 的绝对路径将保持不变，但相对路径将需要更新。我们更倾向于指定绝对路径，因为它更有可能使代码定义和项目调用相互独立地移动。

让我们试着编译清单7-3，看看为什么它还不能编译! 我们得到的错误显示在清单7-4中:

```bash
$ cargo build
   Compiling restaurant v0.1.0 (file:///projects/restaurant)
error[E0603]: module `hosting` is private
 --> src/lib.rs:9:28
  |
9 |     crate::front_of_house::hosting::add_to_waitlist();
  |                            ^^^^^^^ private module
  |
note: the module `hosting` is defined here
 --> src/lib.rs:2:5
  |
2 |     mod hosting {
  |     ^^^^^^^^^^^

error[E0603]: module `hosting` is private
  --> src/lib.rs:12:21
   |
12 |     front_of_house::hosting::add_to_waitlist();
   |                     ^^^^^^^ private module
   |
note: the module `hosting` is defined here
  --> src/lib.rs:2:5
   |
2  |     mod hosting {
   |     ^^^^^^^^^^^

error: aborting due to 2 previous errors

For more information about this error, try `rustc --explain E0603`.
error: could not compile `restaurant`

To learn more, run the command again with --verbose.
```

清单7-4：构建清单7-3中代码的编译器错误

这些错误信息说，模块托管是 private的。换句话说，我们有托管模块和 `add_to_waitlist` 函数的正确路径，但Rust不会让我们使用它们，因为它不能访问私有部分。

模块不仅对组织你的代码有用。它们还定义了Rust的隐私边界：封装了外部代码不允许知道、调用或依赖的实现细节的那一行。所以，如果你想让一个项目，如函数或结构变得私有，你就把它放在模块里。

Rust中 private 的工作方式是，所有项目（函数、方法、结构体、枚举、模块和常量）默认为私有。父模块中的项不能使用子模块中的私有项，但子模块中的项可以使用其祖先模块中的项。原因是，子模块包裹并隐藏了它们的实现细节，但子模块可以看到它们被定义的上下文。继续用餐厅的比喻，把隐私规则想成是餐厅的后台办公室：里面发生的事情对餐厅的顾客来说是私密的，但是办公室经理可以看到他们经营的餐厅里的一切，并进行操作。

Rust选择让模块系统这样运作，这样隐藏内部的执行细节是默认的。这样，你就知道你可以在不破坏外部代码的情况下改变内部代码的哪些部分。但是你可以通过使用 `pub` 关键字将一个项目公开，从而将子模块的内部代码暴露给外部祖先模块。

## 用pub关键字暴露路径

让我们回到清单 7-4 中的错误，告诉我们 `hosting` 模块是私有的。我们希望父模块中的 `eat_at_restaurant` 函数能够访问子模块中的 `add_to_waitlist` 函数，因此我们用 `pub` 关键字标记 `hosting` 模块，如清单 7-5 所示。

文件名：`src/lib.rs`

```rust
mod front_of_house {
    pub mod hosting {
        fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```

不幸的是，清单7-5中的代码仍然导致了一个错误，如清单7-6所示。

```bash
$ cargo build
   Compiling restaurant v0.1.0 (file:///projects/restaurant)
error[E0603]: function `add_to_waitlist` is private
 --> src/lib.rs:9:37
  |
9 |     crate::front_of_house::hosting::add_to_waitlist();
  |                                     ^^^^^^^^^^^^^^^ private function
  |
note: the function `add_to_waitlist` is defined here
 --> src/lib.rs:3:9
  |
3 |         fn add_to_waitlist() {}
  |         ^^^^^^^^^^^^^^^^^^^^

error[E0603]: function `add_to_waitlist` is private
  --> src/lib.rs:12:30
   |
12 |     front_of_house::hosting::add_to_waitlist();
   |                              ^^^^^^^^^^^^^^^ private function
   |
note: the function `add_to_waitlist` is defined here
  --> src/lib.rs:3:9
   |
3  |         fn add_to_waitlist() {}
   |         ^^^^^^^^^^^^^^^^^^^^

error: aborting due to 2 previous errors

For more information about this error, try `rustc --explain E0603`.
error: could not compile `restaurant`

To learn more, run the command again with --verbose.
```

清单7-6：构建清单7-5中代码的编译器错误

发生了什么？在 mod hosting 前面添加 `pub` 关键字，使该模块成为公共模块。有了这个变化，如果我们可以访问 `front_of_house`，我们就可以访问 hosting。但是 hosting 的内容仍然是私有的；使模块公开并没有使其内容公开。模块上的 `pub` 关键字只能让它的祖先模块的代码引用它。

清单 7-6 中的错误说 `add_to_waitlist` 函数是私有的。隐私规则适用于结构体、枚举、函数和方法以及模块。

让我们也通过在其定义前添加 `pub` 关键字使 `add_to_waitlist` 函数成为 public 函数，如清单7-7所示。

文件名：`src/lib.rs`

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```

清单7-7：在 `mod hosting` 和 `fn add_to_waitlist` 中添加 `pub` 关键字，让我们从 `eat_at_restaurant` 中调用该函数。

现在，代码将被编译! 让我们看看绝对路径和相对路径，并仔细检查一下为什么添加 pub 关键字可以让我们在 `add_to_waitlist` 中使用这些路径，以尊重隐私规则。

在绝对路径中，我们从 crate 开始，它是我们 crate 模块树的根。然后 `front_of_house` 模块被定义在 crate root 中。`front_of_house` 模块不是公开的，但是因为 `eat_at_restaurant` 函数与 `front_of_house` 定义在同一个模块中（也就是说，`eat_at_restaurant` 和 `front_of_house` 是兄弟姐妹），我们可以从 `eat_at_restaurant` 引用 `front_of_house`。接下来是标有 pub 的 hosting 模块。我们可以访问 hosting 的父模块，所以我们可以访问 hosting。最后，`add_to_waitlist` 函数被标记为pub，我们可以访问它的父模块，所以这个函数的调用是有效的!

在相对路径中，除了第一步外，逻辑与绝对路径相同：路径不是从 crate root 开始，而是从 `front_of_house` 开始。`front_of_house` 模块与`eat_at_restaurant` 定义在同一个模块中，所以从定义 `eat_at_restaurant` 的模块开始的相对路径起作用。然后，因为 `hosting` 和 `add_to_waitlist` 都被标记为pub，其余的路径都可以工作，这个函数调用是有效的!

## 用super开始相对路径

我们还可以通过在路径的开头使用 super 来构建从父模块开始的相对路径。这就像用 `..` 语法来启动文件系统路径。为什么我们要这样做呢？

考虑一下清单7-8中的代码，它模拟了厨师修正错误的订单并亲自把它带给顾客的情况。函数 `fix_incorrect_order` 通过指定以 `super` 开头的 `serve_order` 的路径来调用函数 `serve_order`。

文件名： `src/lib.rs`

```rust
fn serve_order() {}

mod back_of_house {
    fn fix_incorrect_order() {
        cook_order();
        super::serve_order();
    }

    fn cook_order() {}
}
```

清单 7-8: 使用以super开头的相对路径调用函数

`fix_incorrect_order` 函数在 `back_of_house` 模块中，所以我们可以使用 `super` 转到 `back_of_house` 的父模块，在本例中是 crate，即根。从那里，我们寻找 `serve_order` 并找到它。成功了! 我们认为 `back_of_house` 模块和 `serve_order` 函数可能会保持相同的关系，如果我们决定重新组织crate的模块树，它们会被一起移动。因此，我们使用了super，这样，如果这段代码被移到不同的模块中，我们将有更少的地方需要更新代码。

## 将结构体和枚举公开

我们也可以使用 pub 来指定结构体和枚举为公共的，但有一些额外的细节。如果我们在结构体定义前使用pub，我们会使结构体成为公共的，但结构体的字段仍然是私有的。我们可以根据具体情况使每个字段公开或不公开。在清单 7-9 中，我们定义了一个 public 的 `back_of_house::Breakfast` 结构体，其中有一个 public 的烤面包字段，但有一个私有的 `seasonal_fruit` 字段。这模拟了餐厅的情况，即顾客可以选择随餐的面包类型，但是厨师会根据当季的水果和库存来决定随餐的水果。可用的水果变化很快，所以顾客无法选择水果，甚至无法看到他们会得到哪些水果。

文件名： `src/lib.rs`

```rust
mod back_of_house {
    pub struct Breakfast {
        pub toast: String,
        seasonal_fruit: String,
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }
}

pub fn eat_at_restaurant() {
    // Order a breakfast in the summer with Rye toast
    let mut meal = back_of_house::Breakfast::summer("Rye");
    // Change our mind about what bread we'd like
    meal.toast = String::from("Wheat");
    println!("I'd like {} toast please", meal.toast);

    // The next line won't compile if we uncomment it; we're not allowed
    // to see or modify the seasonal fruit that comes with the meal
    // meal.seasonal_fruit = String::from("blueberries");
}
```

清单7-9：一个有一些公共字段和一些私有字段的结构体

因为 `back_of_house::Breakfast` 结构体中的 `toast` 字段是公共的，在 `eat_at_restaurant` 中，我们可以使用点符号对 `toast` 字段进行写入和读取。注意我们不能在 `eat_at_restaurant` 中使用 `seasonal_fruit` 字段，因为 `seasonal_fruit` 是私有的。试着取消修改 `seasonal_fruit` 字段值的那一行，看看你会得到什么错误。

另外，请注意，因为 `back_of_house::Breakfast` 有一个私有字段，该结构体需要提供一个公共关联函数来构造一个 Breakfast 的实例（我们在这里将其命名为`summer`）。如果 Breakfast 没有这样的函数，我们就不能在 `eat_at_restaurant` 中创建一个 `Breakfast` 的实例，因为我们不能在`eat_at_restaurant` 中设置私有的季节性水果字段的值。

相反，如果我们把一个枚举变成公共的，那么它的所有变体都是公共的。我们只需要在 `enum` 关键字前加上pub，如清单7-10所示。

文件名： src/lib.rs

```rust
mod back_of_house {
    pub enum Appetizer {
        Soup,
        Salad,
    }
}

pub fn eat_at_restaurant() {
    let order1 = back_of_house::Appetizer::Soup;
    let order2 = back_of_house::Appetizer::Salad;
}
```

清单7-10: 将一个枚举指定为公共的，使其所有的变体都是公共的

因为我们把 `Appetizer` 枚举公开了，所以我们可以在 `eat_at_restaurant` 中使用 `Soup` 和 `Salad` 的变体。除非它们的变体是公共的，否则枚举不是很有用；如果在每种情况下都要用 pub 来注释所有的枚举变体，那会很烦人，所以枚举变体的默认值是公共的。结构体通常在其字段不公开的情况下也很有用，所以结构体字段遵循默认为私有的一般规则，除非用pub来注释。

还有一种涉及 pub 的情况我们没有涉及，那就是我们最后一个模块系统特性：use 关键字。我们将首先介绍 use 本身，然后展示如何结合 pub 和 use。

