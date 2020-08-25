---
date: 2019-04-06T16:00:00+08:00
title: cell
menu:
  main:
    parent: "std"
weight: 2054
description : "Rust标准库中的cell"
---

https://doc.rust-lang.org/std/cell/index.html

可共享的可变容器。

Rust的内存安全就是基于这个规则。给定一个对象T，只可能有以下情况之一。

- 有该对象的多个不可变的引用（&T）（也称为别名/**aliasing**）。
- 有该对象的一个可变的引用（&mut T）（也称为可突变性/**mutability**）。

这是由Rust编译器强制执行的。但是，在有些情况下，这个规则不够灵活。有时需要对一个对象有多个引用，但又要对其进行改变。

可共享的可变容器的存在是为了允许以可控的方式进行修改，甚至在存在别名的情况下也是如此。Cell<T>和RefCell<T>都允许以单线程的方式进行改变。但是，Cell<T>和RefCell<T>都不是线程安全的（它们没有实现同步）。如果你需要在多个线程之间进行别名和改变，可以使用Mutex、RwLock或原子类型。

Cell<T>和RefCell<T>类型的值可以通过共享引用（即通用的&T类型）进行改变，而大多数Rust类型只能通过唯一的（&mut T）引用进行突变。我们说Cell<T>和RefCell<T>提供了 "内部可变性"，这与典型的Rust类型表现出 "继承可变性 "的典型Rust类型形成鲜明对比。

Cell类型有两种风格：Cell<T>和RefCell<T>。Cell<T>通过在Cell<T>中移动值来实现内部内部。要使用引用代替值，必须使用RefCell<T>类型，在改变之前获得一个写锁。Cell<T>提供了获取和改变当前内部值的方法。

- 对于实现Copy的类型，get方法可以检索当前的内部值。
- 对于实现Default的类型，take方法用Default::default()替换当前内部值，并返回被替换的值。
- 对于所有类型，replace方法替换了当前的内部值并返回被替换的值，而 into_inner方法则消费 Cell<T> 并返回内部值。此外，set方法替换了内部值，丢弃了被替换的值。

RefCell<T>使用Rust的生命期来实现 "动态借用/dynamic borrowing"，这是一个可以对内部值进行临时的、排他性的、可变的访问的过程。RefCell<T>的借用是 "在运行时 "跟踪的，不像Rust的原生引用类型完全是在编译时静态跟踪的。因为RefCell<T>的借用是动态的，所以有可能试图借用一个已经被可变借用的值；当这种情况发生时，会导致线程恐慌。

### 何时选择内部可变性

比较常见的继承式可突变性，即必须有唯一的访问权限才能改变一个值，这是Rust语言的关键元素之一，它使Rust能够对指针别名进行有力的推理，从静态上防止了崩溃bug。正因为如此，继承式的可变性是首选，而内部可变性是不得已而为之。由于cell类型可以在不允许改变的地方进行改变，因此在某些情况下，内部突变可能是合适的，甚至是必须使用的，例如：

- 在不可变的事物 "内部"引入可变性
- 逻辑上不可变方法的实现细节。
- Clone的可变实现。

### 在不变的事物内部引入可变性

许多共享的智能指针类型，包括Rc<T>和Arc<T>，都提供了可以在多方之间克隆和共享的容器。由于所包含的值可能是多义性的，所以只能用&，而不是&mut来借用。如果没有cell，就根本不可能对这些智能指针里面的数据进行改变。

那么，在共享指针类型里面放一个RefCell<T>来重新引入可变性是很常见的。

```rust
use std::cell::{RefCell, RefMut};
use std::collections::HashMap;
use std::rc::Rc;

fn main() {
    let shared_map: Rc<RefCell<_>> = Rc::new(RefCell::new(HashMap::new()));
    // Create a new block to limit the scope of the dynamic borrow
    {
        let mut map: RefMut<_> = shared_map.borrow_mut();
        map.insert("africa", 92388);
        map.insert("kyoto", 11837);
        map.insert("piccadilly", 11826);
        map.insert("marbles", 38);
    }

    // Note that if we had not let the previous borrow of the cache fall out
    // of scope then the subsequent borrow would cause a dynamic thread panic.
    // This is the major hazard of using `RefCell`.
    let total: i32 = shared_map.borrow().values().sum();
    println!("{}", total);
}
```

注意，这个例子使用的是Rc<T>而不是Arc<T>。RefCell<T>用于单线程场景。如果你需要在多线程场景中使用RwLock<T>或Mutex<T>，可以考虑使用RwLock<T>或Mutex<T>。

### 逻辑上不可更改的方法的实施细节

偶尔，在API中不公开 "在引擎盖下 "发生的修改可能是可取的。这可能是因为在逻辑上，操作是不可更改的，但例如，缓存会迫使实现者执行突变；也可能是因为你必须使用可变来实现一个trait方法，而这个trait方法最初定义为取&self。

```rust
use std::cell::RefCell;

struct Graph {
    edges: Vec<(i32, i32)>,
    span_tree_cache: RefCell<Option<Vec<(i32, i32)>>>
}

impl Graph {
    fn minimum_spanning_tree(&self) -> Vec<(i32, i32)> {
        self.span_tree_cache.borrow_mut()
            .get_or_insert_with(|| self.calc_span_tree())
            .clone()
    }

    fn calc_span_tree(&self) -> Vec<(i32, i32)> {
        // Expensive computation goes here
        vec![]
    }
}
```

### Clone的可变实现

这只是前者的一个特殊但是很常见的案例：隐藏看起来是不可改的操作中的可变性。克隆方法预计不会改变源值，并且声明取&self，而不是&mut self。因此，克隆方法中发生的任何改变都必须使用cell类型。例如，Rc<T>在Cell<T>中维护其引用计数。