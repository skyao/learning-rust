---
date: 2019-03-05T07:00:00+08:00
title: 数组
menu:
  main:
    parent: "grammar-type"
weight: 331
description : "Rust中的数组"
---

数组（array）与元组不同，数组中的每个元素的类型必须相同。数组的特点是：

- 数组大小固定
- 元素均为相同类型
- 默认不可变

可以通过 `let mut` 关键字定义可变绑定的 mut_arr，但是也只能通过下标修改数组元素的值。

数组的类型签名为 [T; N]:

- T 是泛型标记，代表数组中元素的具体类型
- N 是数组长度，是一个 **编译时常量**，必须在编译时确认值，而且不可改变。

Rust 中数组的定义和使用方式：

```rust
// 声明数组，默认不可变
let arr: [i32; 3] = [1, 2, 3];
// 声明可变数组
let mut mut_arr = [1, 2, 3];
assert_eq!(1, mut_arr[0]);
// 通过下标修改可变数组元素的值
mut_arr[0] = 3;
assert_eq!(3, mut_arr[0]);
// 创建初始值为0大小为10的数组
let init_arr = [0; 10];
assert_eq!(0, init_arr[5]);
assert_eq!(10, init_arr.len());
// 下标越界
// error: index out of bounds: the len is 3 but the index is 5
println!("{:?}", arr[5]);
```

如果下标越界，rust会以 panic 的方式报错。

### 数组内存分配

数组是在栈（stack）而不是在堆（heap）上为数据分配内存空间。

对于原始固定长度数组，只有实现了 Copy trait 的类型才能作为其元素，也就是说，只有可以在栈上存放的元素才可以存放在该类型的数组中。

未来，rust将支持VLA（variable-length array) 数组，即可变长度数组。



