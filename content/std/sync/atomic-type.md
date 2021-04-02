---
type: docs
title: "Rust标准库中的原子类型"
linkTitle: "原子类型"
weight: 310
date: 2021-04-02
description: Rust标准库中的原子类型
---

https://doc.rust-lang.org/std/sync/atomic/index.html

### 原子类型

原子类型提供了线程之间的原始共享内存通信，也是其他并发类型的构件。

这个模块定义了一些精选的原始类型的原子版本，包括AtomicBool、AtomicIsize、AtomicUsize、AtomicI8、AtomicU16等。Atomic类型呈现的操作，正确使用时，可以在线程之间同步更新。

每个方法都取 [`Ordering`](https://doc.rust-lang.org/std/sync/atomic/enum.Ordering.html) ，它代表该操作的内存屏障强度。这些顺序与C++20的原子顺序相同。更多信息，请参见[nomicon](https://doc.rust-lang.org/nomicon/atomics.html)。

原子变量在线程之间共享是安全的（它们实现了Sync），但它们本身并没有提供共享的机制，遵循Rust的线程模型。共享原子变量最常见的方式是将其放入Arc（原子引用计数的共享指针）。

原子类型可以存储在静态变量中，使用像 AtomicBool:::new 这样的常量初始化器进行初始化。原子静态常量经常被用于延迟的全局初始化。

### 可移植性

这个模块中的所有原子类型都保证是无锁的，只要可用。这意味着它们不会在内部使用全局mutex。原子类型和操作不保证是无等待的。这意味着像 fetch_or 这样的操作可以通过比较和交换循环（compare-and-swap）来实现。

原子操作可以在指令层用较大尺寸的原子类型来实现。例如有些平台使用4字节的原子指令来实现AtomicI8。注意，这种模拟应该不会对代码的正确性产生影响，只是需要注意的地方。

这个模块中的原子类型可能并不是所有平台都能使用。但是，这里的原子类型都是广泛可用的，一般来说，可以依赖现有的原子类型。一些值得注意的例外是。

- 具有32位指针的PowerPC和MIPS平台没有AtomicU64或AtomicI64类型。

- 非Linux的ARM平台，如armv5te，根本就没有AtomicU64或AtomicI64类型。

- 采用thumbv6m的ARM目标完全没有原子操作。

需要注意的是，未来可能会加入同样不支持某些原子操作的平台。最大限度的可移植代码要注意使用哪些原子类型。一般来说，AtomicUsize和AtomicIsize是最可移植的，但即便如此，也不是到处都有。作为参考，std库需要指针大小的原子类型，虽然core不需要。

目前你需要使用#[[cfg(target_arch)]]主要是为了有条件地在代码中编译原子体。还有一个不稳定的#[cfg(target_has_atomic)]也是不稳定的，将来可能会稳定下来。

### 例子

一个简单的自旋锁:

```rust
use std::sync::Arc;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::thread;

fn main() {
    let spinlock = Arc::new(AtomicUsize::new(1));

    let spinlock_clone = spinlock.clone();
    let thread = thread::spawn(move|| {
        spinlock_clone.store(0, Ordering::SeqCst);
    });

    // Wait for the other thread to release the lock
    while spinlock.load(Ordering::SeqCst) != 0 {}

    if let Err(panic) = thread.join() {
        println!("Thread had an error: {:?}", panic);
    }
}
```

保持全局的活跃线程数:

```rust
use std::sync::atomic::{AtomicUsize, Ordering};

static GLOBAL_THREAD_COUNT: AtomicUsize = AtomicUsize::new(0);

let old_thread_count = GLOBAL_THREAD_COUNT.fetch_add(1, Ordering::SeqCst);
println!("live threads: {}", old_thread_count + 1);
```

### Ordering枚举

https://doc.rust-lang.org/std/sync/atomic/enum.Ordering.html

```rust
pub enum Ordering {
    Relaxed,
    Release,
    Acquire,
    AcqRel,
    SeqCst,
}
```

内存顺序指定了原子操作同步内存的方式。在其最弱的Relaxed中，只有操作直接接触到的内存才会被同步。另一方面，SeqCst操作的存储-加载对在同步其他内存的同时，还额外保留了所有线程中此类操作的总顺序。

Rust的内存顺序与C++20的内存顺序相同。

更多的信息请参见nomicon。

- Relaxed

  没有排序约束，只有原子操作。

  对应于C++20中的 memory_order_relaxed。

- Release

  当与存储结合在一起时，所有之前的操作都会在加载该值的任何 Acquire（或更强的）排序之前变得有序。特别是，所有之前的所有写操作都会对执行该值的Acquire（或更强）加载的线程可见。

  请注意，对结合了加载和存储的操作使用此命令会导致 Relaxed 加载操作!

  这个命令只适用于可以执行存储的操作。

  对应于C++20中的 memory_order_release。

- Acquire

  当与加载结合在一起时，如果加载的值是由具有Release（或更强的）排序的存储操作写入的，那么后续的所有操作都会在该存储之后成为排序。特别是，所有后续的加载操作都会看到在存储操作之前写入的数据。

  请注意，对一个结合了加载和存储的操作使用这种排序会导致一个Relaxed存储操作!

  这个命令只适用于可以执行加载的操作。

  对应于C++20中的memory_order_acquire。

- AcqRel

  同时具有Acquire和Release的效果。对于负载，它使用的是Acquire命令。对于存储，它使用的是Release命令。

  注意，在compare_and_swap的情况下，有可能操作最终没有执行任何存储，因此它只执行Acquire命令。然而，AcqRel永远不会执行Relaxed访问。

  这种命令只适用于同时执行加载和存储的操作。

  对应于C++20中的memory_order_acq_rel。

- SeqCst

  类似于Acquire/Release/AcqRel（分别用于加载、存储和加载与存储操作），额外保证了所有线程以相同的顺序查看所有顺序一致的操作。

  对应于C++20中的memory_order_seq_cst。

### compiler_fence函数

```rust
pub fn compiler_fence(order: Ordering)
```

编译器的内存围栏。

compiler_fence不发出任何机器代码，但限制了编译器允许做的内存重排序的种类。具体来说，根据给定的 Ordering 语义，编译器可能会被禁止从调用 compiler_fence 之前或之后的读或写移动到调用 compiler_fence 的另一端。注意，这并不妨碍硬件进行这种重新排序。这在单线程、执行上下文中不是问题，但当其他线程可能同时修改内存时，需要更强的同步基元（如fence）。

不同的排序语义所阻止的重排序是。

- 用SeqCst，不允许跨这个点的读和写的重新排序。
- 使用Release，前面的读和写不能越过后续的写。
- 使用Acquire，后续的读和写不能在前面的读之前移动。
- 使用AcqRel，以上两条规则都会被执行。

compiler_fence通常只对防止线程与自己赛跑有用。也就是说，如果一个给定的线程正在执行一段代码，然后被中断，并开始执行其他地方的代码（同时仍然在同一个线程中，并且在概念上仍然在同一个内核上）。在传统程序中，这种情况只有在注册了信号处理程序后才会出现。在更多的底层代码中，在处理中断时、实现绿色线程预置时等也会出现这种情况。鼓励好奇的读者阅读Linux内核中关于内存障碍的讨论。

例子：

如果没有 compiler_fence，下面的代码中的assert_eq!中的assert_eq!不能保证成功，尽管一切都发生在一个线程中。要了解原因，请记住，编译器可以自由地将存储空间调换成import_variable和is_read，因为它们都是Ording:::Relaxed。如果它这样做了，并且信号处理程序在IS_READY被更新后立即被调用，那么信号处理程序将看到IS_READY=1，但IMPORTANT_VARIABLE=0。 使用compiler_fence可以纠正这种情况。

```rust
use std::sync::atomic::{AtomicBool, AtomicUsize};
use std::sync::atomic::Ordering;
use std::sync::atomic::compiler_fence;

static IMPORTANT_VARIABLE: AtomicUsize = AtomicUsize::new(0);
static IS_READY: AtomicBool = AtomicBool::new(false);

fn main() {
    IMPORTANT_VARIABLE.store(42, Ordering::Relaxed);
    // prevent earlier writes from being moved beyond this point
    compiler_fence(Ordering::Release);
    IS_READY.store(true, Ordering::Relaxed);
}

fn signal_handler() {
    if IS_READY.load(Ordering::Relaxed) {
        assert_eq!(IMPORTANT_VARIABLE.load(Ordering::Relaxed), 42);
    }
}
```

### fence函数

https://doc.rust-lang.org/std/sync/atomic/fn.fence.html

```
pub fn fence(order: Ordering)
```

一个原子栅栏。

根据指定的顺序，栅栏可以防止编译器和CPU围绕着它重新排序某些类型的内存操作。这就在它和其他线程中的原子操作或栅栏之间建立了同步关系。

一个具有（至少）释放排序语义的栅栏'A'与具有（至少）获得语义的栅栏'B'同步，如果且仅当存在操作X和Y，都在某些原子对象'M'上操作，那么A在X之前被排序，Y在B之前被同步，而Y观察到M的变化。

```text
    Thread 1                                          Thread 2

fence(Release);      A --------------
x.store(3, Relaxed); X ---------    |
                               |    |
                               |    |
                               -------------> Y  if x.load(Relaxed) == 3 {
                                    |-------> B      fence(Acquire);
                                                     ...
                                                 }
```

具有Release或Acquire语义的原子操作也可以与栅栏同步。

一个具有SeqCst排序的栅栏，除了具有Acquire和Release语义外，还可以参与其他SeqCst操作和/或栅栏的全局程序排序。

接受Acquire、Release、AcqRel和SeqCst命令。

例子：

```rust
use std::sync::atomic::AtomicBool;
use std::sync::atomic::fence;
use std::sync::atomic::Ordering;

// 基于自旋锁的互斥基元。
pub struct Mutex {
    flag: AtomicBool,
}

impl Mutex {
    pub fn new() -> Mutex {
        Mutex {
            flag: AtomicBool::new(false),
        }
    }

    pub fn lock(&self) {
        while !self.flag.compare_and_swap(false, true, Ordering::Relaxed) {}
        // This fence synchronizes-with store in `unlock`.
        fence(Ordering::Acquire);
    }

    pub fn unlock(&self) {
        self.flag.store(false, Ordering::Release);
    }
}
```

### spin_loop_hint函数

https://doc.rust-lang.org/std/sync/atomic/fn.spin_loop_hint.html

```
pub fn spin_loop_hint()
```

向处理器发出信号，表示它处于忙等待的自旋循环（"spin lock"）中。

接收到自旋循环信号后，处理器可以通过节省功耗或切换超线程等方式优化自己的行为。

这个函数不同于 std::thread::yield_now，后者直接向系统的调度器输出，而spin_loop_hint不与操作系统交互。

spin_loop_hint的一个常见用例是在同步基元中实现CAS循环中的约束优化旋转。为了避免优先级反转等问题，强烈建议在有限的迭代次数后终止自旋循环，并进行适当的阻塞syscall。

注意：在不支持接收自旋循环提示的平台上，这个函数根本不做任何事情。