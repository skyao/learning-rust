---
date: 2019-03-26T07:00:00+08:00
title: 映射(Map)
menu:
  main:
    parent: "grammar-collection"
weight: 374
description : "Rust中的映射"
---

Rust 提供了两个 Key-Value 哈希映射表：

- HashMap<K, V>：无序
- BTreeMap<K, V>：有序

要求：Key 必须是可哈希的类型，Value 必须满足是在编译期已知大小的类型。

```rust
use std::collections::BTreeMap;
use std::collections::HashMap;
let mut hmap = HashMap::new();
let mut bmap = BTreeMap::new();
hmap.insert(3, "c");
hmap.insert(1, "a");
hmap.insert(2, "b");
hmap.insert(5, "e");
hmap.insert(4, "d");
bmap.insert(3, "c");
bmap.insert(2, "b");
bmap.insert(1, "a");
bmap.insert(5, "e");
bmap.insert(4, "d");
// 输出结果为：{1: "a", 2: "b", 3: "c", 5: "e", 4: "d"}，但key的顺序是随机的，因为HashMap是无序的
println!("{:?}", hmap);
// 输出结果永远都是 {1: "a", 2: "b", 3: "c", 4: "d", 5: "e"}，因为BTreeMap是有序的
println!("{:?}", bmap);
```
