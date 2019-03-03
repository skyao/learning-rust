# 所有权

所有权Rust最独特的功能，使得Rust可以无需垃圾回收就能保障内存安全。

- 内存被一个所有权系统管理，它拥有一系列的规则使编译器在编译时进行检查。
- 任何所有权系统的功能都不会导致运行时开销。

## 所有权规则

1. 每一个值都被它的所有者变量拥有。
1. 值在任意时刻只能被一个所有者拥有。
1. 当所有者离开作用域，这个值将被丢弃。

### 移动

```bash
let s1 = String::from("hello");
let s2 = s1;
```

移动(move)时Rust会使第一个变量无效化。

### 克隆

```bash
let s1 = String::from("hello");
let s2 = s1.clone();
```

克隆(clone)时是深度复制堆上的数据。

### 引用

引用允许使用值但不获取所有权。

```bash
fn main() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);	//获取s1的引用
}

fn calculate_length(s: &String) -> usize { //s借用s1的引用
    s.len()
}
```

默认不允许修改引用的值。

#### 可变引用

```bash
fn main() {
    let mut s = String::from("hello");
    change(&mut s);	//创建一个可变引用
}

fn change(some_string: &mut String) { //接受一个可变引用
    some_string.push_str(", world");
}
```

可变引用的限制：在特定作用域中的特定数据有且只有一个可变引用。这个限制的好处是Rust可以在编译时就避免数据竞争。

- 数据竞争会导致未定义行为，难以在运行时追踪，并且难以诊断和修复；
- Rust 避免了这种情况的发生，因为它直接拒绝编译存在数据竞争的代码！

引用的概括：

1. 在任意给定时间，只能拥有如下中的一个：
	- 一个可变引用。
	- 任意数量的不可变引用
1. 引用必须总是有效的

## Slice

见：

https://kaisery.github.io/trpl-zh-cn/ch04-03-slices.html


