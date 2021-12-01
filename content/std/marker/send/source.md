---
title: "Send trait的源码"
linkTitle: "源码"
weight: 1334
date: 2021-12-01
description: >
  Send trait的源码
---

https://github.com/rust-lang/rust/blob/master/library/core/src/marker.rs

```rust
#[stable(feature = "rust1", since = "1.0.0")]
#[cfg_attr(not(test), rustc_diagnostic_item = "send_trait")]
#[rustc_on_unimplemented(
    message = "`{Self}` cannot be sent between threads safely",
    label = "`{Self}` cannot be sent between threads safely"
)]
pub unsafe auto trait Send {
    // empty.
}

#[stable(feature = "rust1", since = "1.0.0")]
impl<T: ?Sized> !Send for *const T {}
#[stable(feature = "rust1", since = "1.0.0")]
impl<T: ?Sized> !Send for *mut T {}
```



