---
title: "Unsize trait的源码"
linkTitle: "源码"
weight: 1323
date: 2021-12-01
description: >
  Unsize trait的源码
---

https://github.com/rust-lang/rust/blob/master/library/core/src/marker.rs

```rust
#[unstable(feature = "unsize", issue = "27732")]
#[lang = "unsize"]
pub trait Unsize<T: ?Sized> {
    // Empty.
}
```

