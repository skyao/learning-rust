---
title: "[Rust编程之道笔记]泛型"
linkTitle: "[Rust编程之道笔记]"
weight: 410
date: 2021-11-29
description: >
 Rust编程之道一书 3.4 节深入trait
---

> 内容出处: Rust编程之道一书，第3.4节深入trait

## 3.4 深入trait

Trait 是 Rust 的灵魂：

- Rust 中所有的抽象都是基于trait来实现
    - 接口抽象
    - OOP范式抽象
    - 函数式范式抽象
- trait 也保证了这些抽象几乎都是在运行时零开销

Trait 是 Rust 对 Ad-hoc 多态的支持。

从语义上说，trait 是行为上对类型的约束，这种约束让 trait 有如下用法：

- 接口抽象：接口是对类型行为的统一约束
- 泛型约束：泛型的行为被trait限定在更有限的范围内
- 抽象类型：在运行时作为一种间接的抽象类型去使用，动态分发给具体的类型
- 标签trait：对类型的约束，可以直接作为一种“标签”使用

### 3.4.1 接口抽象

trait 最基础的用法就是进行接口抽象：

- 接口中可以定义方法，并支持默认实现
- 接口中不能实现另外一个接口，但是接口之间可以继承
- 同一个接口可以同时被多个类型实现，但不能被同一个类型实现多次
- 使用 impl 关键字为类型实现接口方法
- 使用 trait 关键字定义接口

同一个trait，在不同上下文中实现的行为不同。为不同的类型实现trait，术语一种函数重载。

#### 关联类型

rust中的很多操作符都是基于 trait 来实现的。（参见 `core::ops`）

```rust
// Add<RHS = Self> 为类型参数RHS指定默认值为Self
// Self 是每个trait都带有的隐式类型参数，代表实现当前trait的具体类型
trait Add<RHS = Self> {
    // 用 type 关键字定义参数类型
    // 以这种方式定义的类型叫做关联类型
    type Output;
    // 返回类型可以用 Self::Output 来指定
    fn add(self, rhs: RHS) -> Self::Output;
}

// 标准库中u32类型的实现，类型参数默认是 Self
impl Add for $t {
    type Output = $t;
    fn add(self, other: $t) -> $t {
        self + other
    }
}

// 标准库中 String 类型的实现，类型参数通过 Add<&str> 显示指定为 &str
impl Add<&str> for String {
    // 实现时指定 Output 类型
    type Output = String;
    fn add(mut self, other: &str) -> String {
        self.push_str(other);
        self.push_str("!!!");
        self
    }
}

fn main() {
    let a = "hello";
    let b = " world";
    let c = a.to_string().add( b);
    println!("{:?}", c); // "hello world"
}
```

使用关联类型能够使得代码更加精简，也对方法的输入和输出进行了很好的隔离，增强代码的可读性。

在语义层面，使用关联类型增强了 trait 表示行为的语义，因为它表示和某个行为（trait）相关联的类型。在工程上，也体现了高内聚的特点。

#### trait一致性

孤儿规则（Orphan Rule）：

如果要实现某个trait，那么该trait和要实现该trait的类型至少有一个要在当前crate中定义。

```rust
// 不能使用标准库中的Add，需要在当前crate中定义Add
trait Add<RHS=Self> {
    type Output;
    fn add(self, rhs: RHS) -> Self::Output;
}
impl Add<u64> for u32{
    type Output = u64;
    fn add(self, other: u64) -> Self::Output {
        (self as u64) + other
    }
}
let a = 1u32;
let b = 2u64;
// 要用add方法，而不是+操作符
assert_eq!(a.add(b), 3);
```

#### trait继承

Rust不支持对象继承，但是支持 trait 继承。

子trait可以继承父trait中定义或者实现的方法。

```rust
    trait Page{
        fn set_page(&self, p: i32){
            println!("Page Default: 1");
        }
    }
    trait PerPage{
        fn set_perpage(&self, num: i32){
            println!("Per Page Default: 10");
        }
    }
	// 冒号表示继承，加号表示继承有多个trait
    trait Paginate: Page + PerPage{
        fn set_skip_page(&self, num: i32){
            println!("Skip Page : {:?}", num);
        }
    }
	// 为泛型T实现Paginate
	// 而泛型T定义为实现了Page + PerPage
	// 好处就是可以自动实现各种类型的Impl，而不必如下面显式声明
    impl <T: Page + PerPage>Paginate for T{}

    struct MyPaginate{ page: i32 }
    impl Page for MyPaginate{}
    impl PerPage for MyPaginate{}
	// 可以手工实现对Paginate的impl
	// 也可以通过上面的泛型T自动实现
	//impl Paginate for MyPaginate{}
    let my_paginate = MyPaginate{page: 1};
    my_paginate.set_page(2);
    my_paginate.set_perpage(100);
    my_paginate.set_skip_page(12);
```

### 3.4.2 泛型约束

使用泛型编程时，很多情况下，并不是针对所有的类型。因此需要用trait作为泛型的约束。

#### trait限定

```rust
use std::ops::Add;
// 如果不加类型约束，只有一个泛型T，则不能保证所有类型都实现了+操作
//fn sum<T>(a: T, b: T) -> T {
// 因此需要为泛型增加约束，限制为实现了Add trait的类型
// 可以简写为 Add<Output=T>
//fn sum<T: Add<Output=T>>(a: T, b: T) -> T {
fn sum<T: Add<T, Output=T>>(a: T, b: T) -> T {
    a + b
}
assert_eq!(sum(1u32, 2u32), 3);
assert_eq!(sum(1u64, 2u64), 3);
```

`Add<T, Output=T>` 通过类型参数确定了关联类型Output也是T，因此可以省略类型参数T，简写为 `Add<Output=T>`

使用 trait 对泛型进行约束，叫做 trait 限定。

语法上也可以使用 where 关键字做约束：

```rust
fn sum<T>(a: T, b: T) -> T where T: Add<T, Output=T> {
    a + b
}
```

看上去更清晰一些。

#### 理解trait限定

Rust 中的 trait 限定也是 structural typing 的一种实现，可以看做一种静态 Duck Typing。

类型可以看作是具有相同属性值的集合。trait 也是一种类型，是一种行为的集合。

```rust
trait Paginate: Page + Perpage
```

`:`代表"包含于"，`+`代表交集。

### 3.4.3 抽象类型

Trait 可以用作抽象类型(abstract type)。

抽象类型无法直接实例化。对于抽象类型，编译器无法确定其确切的功能和内存大小。

目前Rust中有两种方法来处理抽象类型：trait object 和 impl trait

#### Trait对象

将拥有相同行为的类型抽象为一个类型，这就是 trait 对象。

> 备注：在这个使用方法上，trait 很类似 Java 中的 interface。

trait本身也是一种类型，但它的类型大小在编译期是无法确定的，所以trait对象必须使用指针。可以利用引用操作符 `&` 或者 `Box<T>` 来制造一个 trait 对象。

trait对象等价于如下所示的结构体：

```rust
pub struct TraitObject {
    pub data: *mut (),
    pub vtable: *mut (),
}
```

TraitObject 包含两个指针：

- data指针：指向 trait 对象保存的类型数据T
- vtable指针：指向包含为 T 实现的对象的 Vtable（虚表）

在运行时，当有 trait_object.method() 被调用时，Trait Object 会根据虚表指针从虚表中查出正确的指针，然后再进行动态调用。这也是将 trait 对象称为动态分发的原因。

**对象安全**

当 trait 对象在运行期进行动态分发时，必须确定大小。因此必须满足以下两条规则的 trait 才可以作为 trait 对象使用：

- trait 的 Self 类型参数不能被限定为 **Sized**
- trait 中所有的方法都必须是对象安全的

当不希望trait 作为 trait 对象时，可以使用 `Self:Sized` 进行限定。

而对象安全的方法必须满足以下三点：

1. 方法受 `Self:Sized` 约束

2. 方法签名同时满足以下三点

    - 必须不包含任何泛型参数。如果包含泛型，trait对象在虚表中查找方法时将不能确定该调用哪个方法

    - 第一个参数必须是 Self 类型或者可以解引用为 Self 的类型。也就是说，必须有接受者，如 self, &self, `&mut self` 和 `self: Box<Self>`

    - Self 不能出现在除第一个参数之外的地方，包括返回值中。

        总结：没有额外 Self 类型参数的非泛型成员方法

3. trait中不能包含关联常量（Associated Constant）

> 备注：书上写的很晦涩，看不太懂，稍后找点其他文章看看。

#### Impl Trait

在 Rust 2018 版本中，引入了可以静态分发的抽象类型 impl Trait。

如果说 trait object 是装箱抽象类型（boxed abstract type），那么 impl trait 就是拆箱抽象类型（unboxed abstract type）。"装箱" 代表把值托管到堆内存，而“拆箱”则是在栈内存中生成新的值。总之：装箱抽象类型代表动态分发，拆箱抽象类型代表静态分发。

目前 impl trait 只可以在输入的参数和返回值这两个位置使用。

> TBD：确认一下最新edition 2021中是否有改变。



```rust
// 参数使用 impl Fly + Debug 抽象类型
fn fly_static(s: impl Fly + Debug) -> bool {
    f.fly()
}

// 返回值指定 impl Fly 抽象类型
fn can_fly(s: impl Fly + Debug) -> impl Fly {
    if s.fly() {
        println!("{:?} can fly", s);
    } else {
        println!("{:?} can;t fly", s);
    }
    s
}
```

注意： impl trait 只能用于为单个参数指定抽象类型，如果对多个参数使用 impl trait 语法，编译期会报错。

#### Dynamic trait

在 rust 2018 版本中，为了在语义上和 impl trait 语法相对应，专门为动态分发的 trait 对象增加了新的语法 `dyn Trait`，其中 dyn 是 dynamic 的缩写。

impl trait 代表静态分发， dyn trait 代表动态分发。

```rust
// 返回值指定 impl Fly 抽象类型
fn dyn_can_fly(s: impl Fly + Debug + 'static) -> Box<dyn Fly> {
    if s.fly() {
        println!("{:?} can fly", s);
    } else {
        println!("{:?} can;t fly", s);
    }
    Box::new(s)
}
```

### 3.4.4 标签trait

trait 对行为约束的特性非常适合作为类型的标签。

rust 一共提供了5个重要的标签 trait，都被定义在标准库 std::marker 模块：

- Sided trait: 用来表示编译期可确认大小的类型
- Unsize trait：用来标识动态大小类型（DST），目前该trait为实验特性（TBD：待验证是否有更新）
- Copy trait：用来标识可以按位复制其值的类型
- Send trait：用来标识可以跨线程安全通讯的类型
- Sync trait：用来标识可以在线程间安全共享引用的类型

