---
date: 2019-03-26T07:00:00+08:00
title: String字符串
menu:
  main:
    parent: "grammar-string"
weight: 342
description : "Rust中的String字符串"
---

### 字符串编码

```rust
// 将UTF-8序列转为字符串
let tao = std::str::from_utf8(&[0xE9u8, 0x81u8, 0x93u8]).unwrap();
assert_eq!("道", tao);

// 将16进制Unicode码位转为字符串
assert_eq!("道", String::from("\u{9053}")); 

let unicode_x = 0x9053;
let utf_x_hex = 0xe98193;
let utf_x_bin  = 0b111010011000000110010011;
println!("unicode_x: {:b}", unicode_x);
println!("utf_x_hex: {:b}", utf_x_hex);
println!("utf_x_bin: 0x{:x}", utf_x_bin);
```




