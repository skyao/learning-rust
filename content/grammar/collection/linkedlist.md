---
date: 2019-03-26T07:00:00+08:00
title: 链表(LinkedList)
menu:
  main:
    parent: "grammar-collection"
weight: 353
description : "Rust中的双端队列"
---

Rust 提供的链表是双向链表。

最好是使用 Vec 或者 VecDeque 类型，比链表更快。

```rust
use std::collections::LinkedList;
let mut list1 = LinkedList::new();

list1.push_back('a');

let mut list2 = LinkedList::new();
list2.push_back('b');
list2.push_back('c');

list1.append(&mut list2);
println!("{:?}", list1); // ['a', 'b', 'c']
println!("{:?}", list2); // []

list1.pop_front();
println!("{:?}", list1); // ['b', 'c']

list1.push_front('e');
println!("{:?}", list1); // ['e', 'b', 'c']

list2.push_front('f');
println!("{:?}", list2); // ['f']
```
