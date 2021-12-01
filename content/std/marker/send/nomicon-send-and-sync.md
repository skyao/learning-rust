---
title: "send和sync"
linkTitle: "send和sync"
weight: 1345
date: 2021-12-01
description: >
  The Rustonomicon文档中的 send and sync 一节
---

https://doc.rust-lang.org/nomicon/send-and-sync.html

不过，并不是所有的东西都服从于继承的可变性。有些类型允许你在内存中对一个位置有多个别名，同时对其进行突变。除非这些类型使用同步化来管理这种访问，否则它们绝对不是线程安全的。Rust通过Send和Sync特性捕捉到这一点。

- 如果将一个类型发送到另一个线程是安全的，那么它就是Send。
- 如果一个类型可以安全地在线程间共享，那么它就是 Sync（当且仅当 `&T` 是 Send 时，T 是 Sync）。

Send 和 Sync 是Rust的并发故事的基础。因此，存在大量的特殊工具来使它们正常工作。首先，它们是不安全的特性。这意味着它们的实现是不安全的，而其他不安全的代码可以认为它们是正确实现的。由于它们是标记性的特征（它们没有像方法那样的关联项），正确实现仅仅意味着它们具有实现者应该具有的内在属性。不正确地实现 Send 或 Sync 会导致未定义行为。

Send 和 Sync 也是自动派生的特性。这意味着，与其它特质不同，如果一个类型完全由 Send 或 Sync 类型组成，那么它就是 Send 或 Sync。几乎所有的基元都是 Send 和 Sync，因此，几乎所有你将与之交互的类型都是 Send 和 Sync。

主要的例外情况包括:

- 原始指针既不是 Send 也不是 Sync（因为它们没有安全防护）。
- UnsafeCell 不是Sync（因此Cell和RefCell也不是）。
- Rc不是Send或Sync（因为refcount是共享的，而且是不同步的）。

Rc 和 UnsafeCell 从根本上说不是线程安全的：它们启用了非同步的共享可变体状态。然而，严格来说，原始指针被标记为线程不安全，更像是一种提示。对原始指针做任何有用的事情都需要对其进行解引用，这已经是不安全的了。从这个意义上说，人们可以争辩说，将它们标记为线程安全是 "好的"。

然而，重要的是，它们不是线程安全的，以防止包含它们的类型被自动标记为线程安全的。这些类型有非实质性的未跟踪的所有权，它们的作者不可能认真考虑线程安全问题。在Rc的例子中，我们有一个包含 `*mut` 的类型的好例子，它绝对不是线程安全的。

如果需要的话，那些没有自动派生的类型可以简单地实现它们。

```rust
struct MyBox(*mut u8);

unsafe impl Send for MyBox {}
unsafe impl Sync for MyBox {}
```

在极其罕见的情况下，一个类型被不适当地自动派生为Send或Sync，那么我们也可以不实现Send和Sync。

```rust
#![feature(negative_impls)]

// I have some magic semantics for some synchronization primitive!
struct SpecialThreadToken(u8);

impl !Send for SpecialThreadToken {}
impl !Sync for SpecialThreadToken {}
```

注意，就其本身而言，不可能错误地派生出 Send 和 Sync。只有那些被其他不安全代码赋予特殊含义的类型才有可能通过错误的 Send 或 Sync 引起麻烦。

大多数对原始指针的使用应该被封装在一个足够的抽象后面，以便 Send 和 Sync 可以被派生。例如，所有Rust的标准集合都是 Send 和 Sync（当它们包含Send和Sync类型时），尽管它们普遍使用原始指针来管理分配和复杂的所有权。同样地，大多数进入这些集合的迭代器都是Send和Sync的，因为它们在很大程度上表现为进入集合的 `&` 或 `&mut`。

### 例子

由于各种原因，Box被编译器实现为它自己的特殊内在类型，但是我们可以自己实现一些具有类似行为的东西，看看什么时候实现 Send 和 Sync 是合理的。让我们把它叫做 "Carton"。

我们先写代码，把一个分配在栈上的值，转移到堆上。

```rust

#![allow(unused)]
fn main() {
pub mod libc {
   pub use ::std::os::raw::{c_int, c_void};
   #[allow(non_camel_case_types)]
   pub type size_t = usize;
   extern "C" { pub fn posix_memalign(memptr: *mut *mut c_void, align: size_t, size: size_t) -> c_int; }
}
use std::{
    mem::{align_of, size_of},
    ptr,
};

struct Carton<T>(ptr::NonNull<T>);

impl<T> Carton<T> {
    pub fn new(value: T) -> Self {
        // Allocate enough memory on the heap to store one T.
        assert_ne!(size_of::<T>(), 0, "Zero-sized types are out of the scope of this example");
        let mut memptr = ptr::null_mut() as *mut T;
        unsafe {
            let ret = libc::posix_memalign(
                (&mut memptr).cast(),
                align_of::<T>(),
                size_of::<T>()
            );
            assert_eq!(ret, 0, "Failed to allocate or invalid alignment");
        };

        // NonNull is just a wrapper that enforces that the pointer isn't null.
        let mut ptr = unsafe {
            // Safety: memptr is dereferenceable because we created it from a
            // reference and have exclusive access.
            ptr::NonNull::new(memptr.cast::<T>())
                .expect("Guaranteed non-null if posix_memalign returns 0")
        };

        // Move value from the stack to the location we allocated on the heap.
        unsafe {
            // Safety: If non-null, posix_memalign gives us a ptr that is valid
            // for writes and properly aligned.
            ptr.as_ptr().write(value);
        }

        Self(ptr)
    }
}
}
```

这不是很有用，因为一旦我们的用户给了我们一个值，他们就没有办法访问它。Box实现了 `Deref` 和 `DerefMut`，这样你就可以访问内部的值。让我们来做这件事。

```rust

#![allow(unused)]
fn main() {
use std::ops::{Deref, DerefMut};

struct Carton<T>(std::ptr::NonNull<T>);

impl<T> Deref for Carton<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        unsafe {
            // Safety: The pointer is aligned, initialized, and dereferenceable
            //   by the logic in [`Self::new`]. We require writers to borrow the
            //   Carton, and the lifetime of the return value is elided to the
            //   lifetime of the input. This means the borrow checker will
            //   enforce that no one can mutate the contents of the Carton until
            //   the reference returned is dropped.
            self.0.as_ref()
        }
    }
}

impl<T> DerefMut for Carton<T> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        unsafe {
            // Safety: The pointer is aligned, initialized, and dereferenceable
            //   by the logic in [`Self::new`]. We require writers to mutably
            //   borrow the Carton, and the lifetime of the return value is
            //   elided to the lifetime of the input. This means the borrow
            //   checker will enforce that no one else can access the contents
            //   of the Carton until the mutable reference returned is dropped.
            self.0.as_mut()
        }
    }
}
}
```

最后，让我们考虑一下我们的Carton是否是Send和Sync。有些东西可以安全地成为 "Send"，除非它与其他东西共享可变的状态而不对其进行排他性访问。每个Carton都有一个唯一的指针，所以我们很好。

