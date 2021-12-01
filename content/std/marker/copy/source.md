---
title: "Copy trait的源码"
linkTitle: "源码"
weight: 1333
date: 2021-12-01
description: >
  Copy trait的源码
---

https://github.com/rust-lang/rust/blob/master/library/core/src/marker.rs

```rust
#[stable(feature = "rust1", since = "1.0.0")]
#[lang = "copy"]
#[rustc_unsafe_specialization_marker]
pub trait Copy: Clone {
    // Empty.
}
```

原始类型的Copy的实现。

无法在Rust中描述的实现是在 rustc_trait_selection 中的 `traits::SelectionContext::copy_clone_conditions()` 中实现。

```rust
mod copy_impls {

    use super::Copy;

    macro_rules! impl_copy {
        ($($t:ty)*) => {
            $(
                #[stable(feature = "rust1", since = "1.0.0")]
                impl Copy for $t {}
            )*
        }
    }

    impl_copy! {
        usize u8 u16 u32 u64 u128
        isize i8 i16 i32 i64 i128
        f32 f64
        bool char
    }

    #[unstable(feature = "never_type", issue = "35121")]
    impl Copy for ! {}

    #[stable(feature = "rust1", since = "1.0.0")]
    impl<T: ?Sized> Copy for *const T {}

    #[stable(feature = "rust1", since = "1.0.0")]
    impl<T: ?Sized> Copy for *mut T {}

    /// Shared references can be copied, but mutable references *cannot*!
    #[stable(feature = "rust1", since = "1.0.0")]
    impl<T: ?Sized> Copy for &T {}
}
```

