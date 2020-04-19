---
date: 2019-03-03T21:00:00+08:00
title: 版本升级
menu:
  main:
    parent: "installation"
weight: 203
description : "升级Rust版本"
---

### 曾经遇到的问题

尝试过升级已经安装的rust/cargo，试图从1.22.1升级到1.23，发现重新运行rustup脚本，虽然报告说安装成功，但是实际不会安装新的版本。

暂时没有找到升级的方法，只好用最笨的办法，先删除再全新安装：

```bash
cd
rm -rf .cargo/ .rustup/
```

这个方式理所当然的很不好，原有的所有内容都要重头来一次。

TBD：需要找到升级rust和cargo的正确方式
TBD：不确认新版本是否还有这个问题，下次升级版本时再试。

### 官方方式

通过 `rustup` 安装了 Rust 之后，更新到最新版本只要运行如下更新脚本：

```
$ rustup update
```

尝试在mac下从 1.40 升级到 1.42 成功，输出如下：

```bash
$ rustup update
info: syncing channel updates for 'stable-x86_64-apple-darwin'
463.3 KiB / 463.3 KiB (100 %) 414.2 KiB/s in  1s ETA:  0s
info: latest update on 2020-03-12, rust version 1.42.0 (b8cedc004 2020-03-09)
info: downloading component 'rust-src'
  2.2 MiB /   2.2 MiB (100 %) 313.6 KiB/s in  8s ETA:  0s
info: downloading component 'cargo'
  3.7 MiB /   3.7 MiB (100 %) 321.3 KiB/s in 14s ETA:  0s
info: downloading component 'clippy'
  1.3 MiB /   1.3 MiB (100 %) 327.7 KiB/s in  5s ETA:  0s
info: downloading component 'rust-docs'
 12.1 MiB /  12.1 MiB (100 %) 323.2 KiB/s in 43s ETA:  0s
info: downloading component 'rust-std'
 16.1 MiB /  16.1 MiB (100 %) 345.6 KiB/s in  1m  3s ETA:  0s
info: downloading component 'rustc'
 54.5 MiB /  54.5 MiB (100 %) 342.4 KiB/s in  4m 20s ETA:  0s    
info: downloading component 'rustfmt'
  1.9 MiB /   1.9 MiB (100 %) 288.0 KiB/s in  7s ETA:  0s
info: removing previous version of component 'rust-src'
info: removing previous version of component 'cargo'
info: removing previous version of component 'clippy'
info: removing previous version of component 'rust-docs'
info: removing previous version of component 'rust-std'
info: removing previous version of component 'rustc'
info: removing previous version of component 'rustfmt'
info: installing component 'rust-src'
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
 12.1 MiB /  12.1 MiB (100 %)   8.6 MiB/s in  1s ETA:  0s
info: installing component 'rust-std'
info: installing component 'rustc'
 54.5 MiB /  54.5 MiB (100 %)  18.3 MiB/s in  3s ETA:  0s
info: installing component 'rustfmt'
info: checking for self-updates

  stable-x86_64-apple-darwin updated - rustc 1.42.0 (b8cedc004 2020-03-09) (from rustc 1.40.0 (73528e339 2019-12-16))

info: cleaning up downloads & tmp directories
```



如果要卸载 Rust 和 `rustup`，运行如下卸载脚本:

```
$ rustup self uninstall
```



