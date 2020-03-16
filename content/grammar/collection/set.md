---
date: 2019-03-26T07:00:00+08:00
title: 集合(Set)
menu:
  main:
    parent: "grammar-collection"
weight: 356
description : "Rust中的集合"
---

Rust 提供了两个哈希集合：

- `HashSet<K>`：无序，等同于 HashMap<K, ()>，值为空元组的特定类型
- `BTreeSet<K>`：有序，等同于 BTreeMap<K, ()>，值为空元组的特定类型

特性如下：

- 集合中的元素是唯一的
- 集合中的元素是可哈希的类型

```rust
use std::collections::HashSet;
use std::collections::BTreeSet;
let mut hbooks = HashSet::new();
let mut bbooks = BTreeSet::new();
// 插入数据
hbooks.insert(2);
hbooks.insert(1);
hbooks.insert(2);
// 判断元素是否存在，contains方法和HashMap中的一样
if !hbooks.contains(&1) {
}
println!("{:?}", hbooks);
bbooks.insert(1);

bbooks.insert(2);
bbooks.insert(3);
println!("{:?}", bbooks); // 输出固定为 {1, 2, 3} ，因为是有序
```
