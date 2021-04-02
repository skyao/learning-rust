---
title: "Rust集合中的双端队列(VecDeque)"
linkTitle: "双端队列(VecDeque)"
date: 2021-03-29
weight: 1420
description: Rust集合中的双端队列(VecDeque)
---

Rust 中的 VecDeque 是基于可增长的 RingBuffer 算法实现的双端队列。

```rust
use std::collections::VecDeque;
let mut buf = VecDeque::new();

buf.push_front(1);
buf.push_front(2);
assert_eq!(buf.get(0), Some(&2));
assert_eq!(buf.get(1), Some(&1));

buf.push_back(3);
buf.push_back(4);
buf.push_back(5);

assert_eq!(buf.get(2), Some(&3));
assert_eq!(buf.get(3), Some(&4));
assert_eq!(buf.get(4), Some(&5));
```
