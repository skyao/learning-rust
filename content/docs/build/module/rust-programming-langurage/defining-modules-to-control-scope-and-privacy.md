---
title: "定义模块以控制范围和隐私"
linkTitle: "定义模块以控制范围和隐私"
weight: 3
date: 2021-11-06
description: >
  定义模块以控制范围和隐私
---

https://doc.rust-lang.org/book/ch07-02-defining-modules-to-control-scope-and-privacy.html

在这一节中，我们将讨论模块和模块系统的其他部分，即允许你命名项目的路径；将路径带入范围的 `use` 关键字；以及使项目 public 的 `pub` 关键字。我们还将讨论 `as` 关键字、外部包和 `glob` 操作符。现在，让我们把重点放在模块上吧!

模块让我们把 crate 中的代码组织成一组，以提高可读性并便于重复使用。模块还可以控制项目的私密性，也就是一个项目是可以被外部代码使用（public）还是属于内部实现的细节（private），不能被外部使用。

作为例子，让我们写一个提供餐厅功能的crate。我们将定义函数的签名，但将其主体留空，以集中精力组织代码，而不是在代码中实际实现一个餐厅。

在餐饮业中，餐厅的某些部分被称为前厅，其他部分被称为后厅。前厅是顾客所在的地方；这里是主人为顾客安排座位，服务员接受订单和付款，调酒师调制饮料的地方。后厨是厨师在厨房工作的地方，洗碗工负责清理，经理负责行政工作。

为了按照真正的餐厅的工作方式来组织我们的 crate，我们可以将这些功能组织成嵌套模块。通过运行 `cargo new --lib restaurant` 创建一个名为 `restaurant` 的新库；然后将清单 7-1 中的代码放入 `src/lib.rs`，以定义一些模块和函数签名。

文件名：`src/lib.rs`:

```rust
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}

        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}

        fn serve_order() {}

        fn take_payment() {}
    }
}
```

清单 7-1: 包含其他模块的 `front_of_house` 模块，这些模块又包含函数。

我们以 `mod` 关键字开始定义模块，然后指定模块的名称（本例中为 `front_of_house`），并在模块的主体周围加上大括号。在模块内部，我们可以有其他的模块，如本例中的 `hosting` 和 `serving` 模块。模块还可以容纳其他项目的定义，如结构体、枚举、常量、特征，或如清单7-1中的函数。

通过使用模块，我们可以将相关的定义组合在一起，并说明它们为什么相关。使用这段代码的程序员会更容易找到他们想要使用的定义，因为他们可以根据分组来浏览代码，而不必阅读所有的定义。为这段代码添加新功能的程序员会知道该把代码放在哪里，以保持程序的条理性。

早些时候，我们提到 `src/main.rs` 和 `src/lib.rs` 被称为 `crate roots`。之所以叫这个名字，是因为这两个文件中的任何一个文件的内容都构成了一个名为 `crate` 的模块，位于 `crate` 模块结构的根部，也就是所谓的模块树(*module tree*)。

清单 7-2 显示了清单 7-1 中结构的模块树:

```bash
crate
 └── front_of_house
     ├── hosting
     │   ├── add_to_waitlist
     │   └── seat_at_table
     └── serving
         ├── take_order
         ├── serve_order
         └── take_payment
```

清单7-2：清单7-1中代码的模块树

这棵树显示了一些模块是如何相互嵌套的（例如，`hosting` 嵌套在 `front_of_house` 里面）。这棵树还显示一些模块是彼此的兄弟姐妹，这意味着它们被定义在同一个模块中（`hosting` 和 `serving` 被定义在 `front_of_house` 中）。为了继续这个家庭隐喻，如果模块A包含在模块B里面，我们就说模块A是模块B的孩子，模块B是模块A的父母。请注意，整个模块树的根在名为crate的隐式模块下。

模块树可能会让你想起你电脑上的文件系统的目录树；这是一个非常恰当的比较！就像文件系统的目录一样。就像文件系统中的目录，你用模块来组织你的代码。就像目录中的文件一样，我们需要一种方法来找到我们的模块。

