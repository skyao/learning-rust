---
title: "Rust的切片(Slice)类型"
linkTitle: "切片(Slice)"
date: 2021-03-29
weight: 1290
description: >
  Rust的切片(Slice)类型
---


Slice 切片是对一个数组（包括固定大小数组和动态数组）的引用片段，可以安全访问数组的一部分，而不需要拷贝。

在底层，切片表示为一个指向数组起始位置的指针和数组长度。

```rust
// 固定大小数组的切片
let arr: [i32; 5] = [1, 2, 3, 4, 5];
assert_eq!(&arr, &[1,2,3,4,5]);
assert_eq!(&arr[1..], [2,3,4,5]);
assert_eq!((&arr).len(), 5);
assert_eq!((&arr).is_empty(), false);

// 可变数组的切片
let arr = &mut [1, 2, 3];
arr[1] = 7;
assert_eq!(arr, &[1, 7, 3]);

//使用 vec! 宏定义的动态数组的切片
let vec = vec![1, 2, 3];
assert_eq!(&vec[..], [1,2,3]);

// 字符串数组的切片
let str_slice: &[&str] = &["one", "two", "three"];
assert_eq!(str_slice, ["one", "two", "three"]);
```





