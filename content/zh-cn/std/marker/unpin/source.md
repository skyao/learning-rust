---
title: "Unpin trait的源码"
linkTitle: "源码"
weight: 1363
date: 2021-12-01
description: >
  Unpin trait的源码
---

https://github.com/rust-lang/rust/blob/master/library/core/src/marker.rs

```rust
#[stable(feature = "pin", since = "1.33.0")]
#[rustc_on_unimplemented(
    note = "consider using `Box::pin`",
    message = "`{Self}` cannot be unpinned"
)]
#[lang = "unpin"]
pub auto trait Unpin {}


/// A marker type which does not implement `Unpin`.
///
/// If a type contains a `PhantomPinned`, it will not implement `Unpin` by default.
#[stable(feature = "pin", since = "1.33.0")]
#[derive(Debug, Default, Copy, Clone, Eq, PartialEq, Ord, PartialOrd, Hash)]
pub struct PhantomPinned;

#[stable(feature = "pin", since = "1.33.0")]
impl !Unpin for PhantomPinned {}

#[stable(feature = "pin", since = "1.33.0")]
impl<'a, T: ?Sized + 'a> Unpin for &'a T {}

#[stable(feature = "pin", since = "1.33.0")]
impl<'a, T: ?Sized + 'a> Unpin for &'a mut T {}

#[stable(feature = "pin_raw", since = "1.38.0")]
impl<T: ?Sized> Unpin for *const T {}

#[stable(feature = "pin_raw", since = "1.38.0")]
impl<T: ?Sized> Unpin for *mut T {}
```

