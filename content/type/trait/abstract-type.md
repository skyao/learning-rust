---
date: 2019-04-06T16:00:00+08:00
title: 抽象类型
menu:
  main:
    parent: "type-trait"
weight: 443
description : "Rust trait的抽象类型功能"
---

Trait 可以用作抽象类型。

抽象类型无法直接实例化。对于抽象类型，编译器无法确定其确切的功能和内存大小。

### Trait对象

将拥有相同行为的类型抽象为一个类型，这就是 trait 对象。

备注：在这个使用方法上，trait 很类似 Java 中的 interface。

等价于trait对象的结构体：

```rust
pub struct TraitObject {
    pub data: *mut (),
    pub vtable: *mut (),
}
```

TraitObject 包含两个指针：

- data指针：指向 trait 对象保存的类型数据T
- vtable指针：指向包含为 T 实现的对象的 Vtable（虚表）

在运行时，根据虚表指针从虚表中查出正确的指针，然后再进行动态调用。

### 对象安全

当 trait 对象在运行期进行动态分发时，必须确定大小。因此必须满足以下两条规则的 trait 才可以作为 trait 对象使用：

- trait 的 Self 类型参数不能被限定为 **Sized**
- trait 中所有的方法都必须是对象安全的

而对象安全的方法必须满足以下三点：

1. 方法受 Self:Sized 约束
2. 方法签名同时满足以下三点
	- 必须不包含任何泛型参数。如果包含泛型，trait对象在虚表中查找方法时将不能确定该调用哪个方法
	- 第一个参数必须是 Self 类型或者可以解应用为 Self 的类型。也就是说，必须有接受者，如 self, &self, &mut self 和 `self: Box<Self>`
	- Self 不能出现在除第一个参数之外的地方，包括返回值中。
3. trait中不能包含关联常量（Associated Constant）

备注：书上写的很晦涩，看不太懂，稍后找点其他文章看看。

### Impl Trait

在 Rust 2018 版本中，引入了可以静态分发的抽象类型 impl Trait。



### 参考资料

- [Rust, Builder Pattern, Trait Objects, Box<T> and Rc<T>](https://abronan.com/rust-trait-objects-box-and-rc/): 这个文章不错，讲清楚了 `Box<T>` 和 `Rc<T>` 的差别，还有对 Trait Object 的使用 
- [All About Trait Objects](https://brson.github.io/rust-anthology/1/all-about-trait-objects.html#all-about-trait-objects)
- [trait object](https://zhuanlan.zhihu.com/p/23791817)

