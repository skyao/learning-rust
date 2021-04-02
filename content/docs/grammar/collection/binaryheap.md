---
title: "Rust集合中的优先队列(BinaryHeap)"
linkTitle: "优先队列(BinaryHeap)"
date: 2021-03-29
weight: 1460
description: Rust集合中的优先队列(BinaryHeap)
---

Rust 提供的优先队列是基于二叉最大堆(Binary Heap)实现的。

```rust
use std::collections::BinaryHeap;
let mut heap = BinaryHeap::new();
assert_eq!(heap.peek(), None);
heap.push(93);
heap.push(80);
heap.push(48);
heap.push(53);
heap.push(72);
heap.push(30);
heap.push(18);
heap.push(36);
heap.push(15);
heap.push(35);
heap.push(45);
assert_eq!(heap.peek(), Some(&93));
println!("{:?}", heap);  // [93, 80, 48, 53, 72, 30, 18, 36, 15, 35, 45]
```

