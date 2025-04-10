---
title: "Sized trait的源码"
linkTitle: "源码"
weight: 1313
date: 2021-12-01
description: >
  Sized trait的
---

https://github.com/rust-lang/rust/blob/master/library/core/src/marker.rs

```rust
#[stable(feature = "rust1", since = "1.0.0")]
#[lang = "sized"]
#[rustc_on_unimplemented(
    message = "the size for values of type `{Self}` cannot be known at compilation time",
    label = "doesn't have a size known at compile-time"
)]
#[fundamental] // for Default, for example, which requires that `[T]: !Default` be evaluatable
#[rustc_specialization_trait]
pub trait Sized {
    // Empty.
}
```

