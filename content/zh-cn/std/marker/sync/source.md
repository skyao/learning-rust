---
title: "Sync trait的源码"
linkTitle: "源码"
weight: 1354
date: 2021-12-01
description: >
  Sync trait的源码
---

https://github.com/rust-lang/rust/blob/master/library/core/src/marker.rs

```rust
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "sync_trait")]
#[lang = "sync"]
#[rustc_on_unimplemented(
    message = "`{Self}` cannot be shared between threads safely",
    label = "`{Self}` cannot be shared between threads safely"
)]
pub unsafe auto trait Sync {
    // Empty
}

#[stable(feature = "rust1", since = "1.0.0")]
impl<T: ?Sized> !Sync for *const T {}
#[stable(feature = "rust1", since = "1.0.0")]
impl<T: ?Sized> !Sync for *mut T {}
```



