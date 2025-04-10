---
title: "Learn Rust中的Module"
linkTitle: "Learn Rust"
weight: 331
date: 2021-11-06
description: >
  Rust Module
---

https://doc.rust-lang.org/rust-by-example/mod.html

Rust提供了强大的模块系统，可以用来在逻辑单元（模块）中分层分割代码，并管理它们之间的可见性（public/private）。

模块是项目的集合：函数、结构体、特征、`impl`块，甚至是其他模块。

## 可见性

默认情况下，模块中的项目具有私有可见性，但这可以用 `pub` 修改器来覆盖。只有模块中的 public 项目可以从模块范围之外被访问。

```rust
// 名为 `my_mod` 的 module
mod my_mod {
    // 模块中的项目默认为 private 可见性。
    fn private_function() {
        println!("called `my_mod::private_function()`");
    }

    // 使用`pub`修改器来覆盖默认的可见性。
    pub fn function() {
        println!("called `my_mod::function()`");
    }

    // 项目可以访问同一模块中的其他项目，
    // 即使是私有的
    pub fn indirect_access() {
        print!("called `my_mod::indirect_access()`, that\n> ");
        private_function();
    }

    // 模块也可以嵌套
    pub mod nested {
        pub fn function() {
            println!("called `my_mod::nested::function()`");
        }

        #[allow(dead_code)]
        fn private_function() {
            println!("called `my_mod::nested::private_function()`");
        }

        // 使用 `pub(in path)` 语法声明的函数只在给定的路径中可见。
        // `path`必须是一个父级或祖级的模块
        pub(in crate::my_mod) fn public_function_in_my_mod() {
            print!("called `my_mod::nested::public_function_in_my_mod()`, that\n> ");
            public_function_in_nested();
        }

        // 使用 `pub(self)` 语法声明的函数只在当前模块内可见
        // 这相当于是 private。
        pub(self) fn public_function_in_nested() {
            println!("called `my_mod::nested::public_function_in_nested()`");
        }

        // 使用 `pub(super)` 语法声明的函数只在父模块内可见。
        pub(super) fn public_function_in_super_mod() {
            println!("called `my_mod::nested::public_function_in_super_mod()`");
        }
    }

    pub fn call_public_function_in_my_mod() {
        print!("called `my_mod::call_public_function_in_my_mod()`, that\n> ");
        nested::public_function_in_my_mod();
        print!("> ");
        nested::public_function_in_super_mod();
    }

    // pub(crate)使函数只在当前的crate内可见。
    pub(crate) fn public_function_in_crate() {
        println!("called `my_mod::public_function_in_crate()`");
    }

    // 嵌套模块遵循同样的可见性规则
    mod private_nested {
        #[allow(dead_code)]
        pub fn function() {
            println!("called `my_mod::private_nested::function()`");
        }

        // Private 的父项仍然会限制子项的可见性，
        // 即使它被声明为在一个更大的范围内可见。
        #[allow(dead_code)]
        pub(crate) fn restricted_function() {
            println!("called `my_mod::private_nested::restricted_function()`");
        }
    }
}

fn function() {
    println!("called `function()`");
}

fn main() {
    // 模块允许在具有相同名称的项目之间进行歧义消除。
    function();
    my_mod::function();

    // public 项目，包括嵌套模块内的项目，都可以从父模块之外访问。
    my_mod::indirect_access();
    my_mod::nested::function();
    my_mod::call_public_function_in_my_mod();

    // pub(crate) 项可以从同一create的任何地方调用。
    my_mod::public_function_in_crate();

    // pub(in path)项只能从指定的模块内调用。
    // Error! function `public_function_in_my_mod` is private
    //my_mod::nested::public_function_in_my_mod();
    // TODO ^ Try uncommenting this line

    // 模块的 private 项目不能被直接访问，即使是嵌套在一个 public 模块中。

    // Error! `private_function` is private
    //my_mod::private_function();
    // TODO ^ Try uncommenting this line

    // Error! `private_function` is private
    //my_mod::nested::private_function();
    // TODO ^ Try uncommenting this line

    // Error! `private_nested` is a private module
    //my_mod::private_nested::function();
    // TODO ^ Try uncommenting this line

    // Error! `private_nested` is a private module
    //my_mod::private_nested::restricted_function();
    // TODO ^ Try uncommenting this line
}
```

## 结构体的可见性

结构体的字段有一个额外的可见性级别。这种可见性默认为 `private` ，可以用 `pub` 修改器来覆盖。这种可见性只在结构体从其定义的模块之外被访问时才有意义，其目的是为了隐藏信息（封装）。

```rust
mod my {
    // 带有泛型类型 `T` 的 public 字段的 public 结构体
    pub struct OpenBox<T> {
        pub contents: T,
    }

    // 带有泛型类型 `T` 的 private 字段的 public 结构体
    #[allow(dead_code)]
    pub struct ClosedBox<T> {
        contents: T,
    }

    impl<T> ClosedBox<T> {
        // A public constructor method
        pub fn new(contents: T) -> ClosedBox<T> {
            ClosedBox {
                contents: contents,
            }
        }
    }
}

fn main() {
    // 带有 public 字段的 public 结构体可以像平常一样构建
    let open_box = my::OpenBox { contents: "public information" };

    // 而它们的字段可以正常访问。
    println!("The open box contains: {}", open_box.contents);

    // 带有 private 字段的 public 结构不能使用字段名构建。
    // Error! `ClosedBox` has private fields
    //let closed_box = my::ClosedBox { contents: "classified information" };
    // TODO ^ Try uncommenting this line

    // 然而，带有 private 字段的结构体可以使用 public 构造函数来创建
    let _closed_box = my::ClosedBox::new("classified information");

    // 而 public 结构体的 private 字段不能被访问。
    // Error! The `contents` field is private
    //println!("The closed box contains: {}", _closed_box.contents);
    // TODO ^ Try uncommenting this line
}
```

## `use` 声明

`use` 声明可以用来将完整的路径绑定到新的名字上，以方便访问。它经常被这样使用:

```rust
use crate::deeply::nested::{
    my_first_function,
    my_second_function,
    AndATraitType
};

fn main() {
    my_first_function();
}
```

可以使用 `as` 关键字将导入的数据绑定到一个不同的名称:

```rust
// 将 `deeply::nested::function` 路径绑定到 `other_function`.
use deeply::nested::function as other_function;

fn function() {
    println!("called `function()`");
}

mod deeply {
    pub mod nested {
        pub fn function() {
            println!("called `deeply::nested::function()`");
        }
    }
}

fn main() {
    // 访问 `deeply::nested::function` 更简单
    other_function();

    println!("Entering block");
    {
        // 这等同于 `use deeply::nested::function as function`.
        // 这个 `function()` 将隐藏外部的同名函数
        use crate::deeply::nested::function;

        // `use` 绑定有本地范围。在这个例子中， `function()` 的隐藏只在当前块中。
        function();

        println!("Leaving block");
    }

    function();
}
```

## super和self

`super` 和 `self` 关键字可以在路径中使用，以消除访问项目时的歧义，并防止不必要的路径硬编码。

```rust
fn function() {
    println!("called `function()`");
}

mod cool {
    pub fn function() {
        println!("called `cool::function()`");
    }
}

mod my {
    fn function() {
        println!("called `my::function()`");
    }
    
    mod cool {
        pub fn function() {
            println!("called `my::cool::function()`");
        }
    }
    
    pub fn indirect_call() {
        // 让我们从这个作用域访问所有名为 `function` 的函数!
        print!("called `my::indirect_call()`, that\n> ");
        
        // `self` 关键字指的是当前的模块范围 -- 在这里是`my`。
        // 调用 `self::function()` 和直接调用 `function()` 都会得到相同的结果，
        // 因为它们引用的是同一个函数。
        self::function();
        function();
        
        // We can also use `self` to access another module inside `my`:
        // 我们也可以使用 `self` 来访问 `my` 中的另一个模块。
        self::cool::function();
        
        // `super`关键字指的是父范围（在`my`模块之外）。
        super::function();
        
        // 这将绑定到 *crate* 范围内的 `cool::function`。
        // 在这种情况下，crate 范围是最外层的范围。
        {
            use crate::cool::function as root_function;
            root_function();
        }
    }
}

fn main() {
    my::indirect_call();
}
```

## 文件层次结构

模块可以被映射到文件/目录的层次结构中。让我们来分解一下文件中的可见性例子:

```bash
$ tree .
.
|-- my
|   |-- inaccessible.rs
|   |-- mod.rs
|   `-- nested.rs
`-- split.rs
```

`split.rs` 的内容：

```rust
// 这个声明将寻找一个名为 `my.rs` 或 `my/mod.rs` 的文件，
// 并将其内容插入这个范围内的名为`my`的模块中。
mod my;

fn function() {
    println!("called `function()`");
}

fn main() {
    my::function();

    function();

    my::indirect_access();

    my::nested::function();
}
```

`my/mod.rs` 的内容:

```rust
// 同样，`mod inaccessible` 和 `mod nested` 将找到 `nested.rs` 和 `inaccessible.rs` 文件，
// 并将它们插入各自的模块下。
mod inaccessible;
pub mod nested;

pub fn function() {
    println!("called `my::function()`");
}

fn private_function() {
    println!("called `my::private_function()`");
}

pub fn indirect_access() {
    print!("called `my::indirect_access()`, that\n> ");

    private_function();
}
```

`my/nested.rs` 的内容:

```rust
pub fn function() {
    println!("called `my::nested::function()`");
}

#[allow(dead_code)]
fn private_function() {
    println!("called `my::nested::private_function()`");
}
```

`my/inaccessible.rs` 的内容:

```rust
#[allow(dead_code)]
pub fn public_function() {
    println!("called `my::inaccessible::public_function()`");
}
```

让我们检查一下事情是否仍然像以前一样工作:

```bash
$ rustc split.rs && ./split
called `my::function()`
called `function()`
called `my::indirect_access()`, that
> called `my::private_function()`
called `my::nested::function()`
```





