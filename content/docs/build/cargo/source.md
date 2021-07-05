---
title: "Cargo Crates Registry Source设置"
linkTitle: "source设置"
date: 2021-07-05
weight: 321
description: >
  Cargo Source设置
---

### 添加source

为了加快 cargo 的下载速度，避免网速慢或者被墙，添加国内源头 ustc ，需修改 `~/.cargo/config` 加入以下内容： 

```properties
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
#registry = "https://mirrors.ustc.edu.cn/crates.io-index"

[http]
check-revoke = false
```

其中添加 `check-revoke = false` 是为了解决下面的问题：

```
warning: spurious network error (2 tries remaining): [6] Couldn't resolve host name (Could not resolve host: crates-io.proxy.ustclug.org)
warning: spurious network error (1 tries remaining): [6] Couldn't resolve host name (Could not resolve host: crates-io.proxy.ustclug.org)
error: failed to download from `https://crates-io.proxy.ustclug.org/api/v1/crates/serde_test/1.0.126/download`

Caused by:
  [6] Couldn't resolve host name (Could not resolve host: crates-io.proxy.ustclug.org)

```



### 参考资料

- [Rust Crates 源使用帮助 — USTC Mirror Help 文档](http://mirrors.ustc.edu.cn/help/crates.io-index.html)