---
title: " Linux&Mac安装"
linkTitle: " Linux&Mac安装"
date: 2021-03-29
weight: 201
description: >
  在Linux和Mac上安装Rust
---

### 安装

执行命令：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

然后依照屏幕提示：

```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
info: downloading installer

Welcome to Rust!

This will download and install the official compiler for the Rust
programming language, and its package manager, Cargo.

Rustup metadata and toolchains will be installed into the Rustup
home directory, located at:

  /home/sky/.rustup

This can be modified with the RUSTUP_HOME environment variable.

The Cargo home directory located at:

  /home/sky/.cargo

This can be modified with the CARGO_HOME environment variable.

The cargo, rustc, rustup and other commands will be added to
Cargo's bin directory, located at:

  /home/sky/.cargo/bin

This path will then be added to your PATH environment variable by
modifying the profile files located at:

  /home/sky/.profile
  /home/sky/.bashrc
  /home/sky/.zshenv

You can uninstall at any time with rustup self uninstall and
these changes will be reverted.

Current installation options:


   default host triple: x86_64-unknown-linux-gnu
     default toolchain: stable (default)
               profile: default
  modify PATH variable: yes

1) Proceed with installation (default)
2) Customize installation
3) Cancel installation
>1
```

这里选择1默认模式，继续：

```bash
info: profile set to 'default'
info: default host triple is x86_64-unknown-linux-gnu
info: syncing channel updates for 'stable-x86_64-unknown-linux-gnu'
info: latest update on 2021-07-29, rust version 1.54.0 (a178d0322 2021-07-26)
info: downloading component 'cargo'
info: downloading component 'clippy'
info: downloading component 'rust-docs'
 16.7 MiB /  16.7 MiB (100 %)   4.5 MiB/s in  3s ETA:  0s
info: downloading component 'rust-std'
 21.9 MiB /  21.9 MiB (100 %)   6.0 MiB/s in  4s ETA:  0s
info: downloading component 'rustc'
 50.1 MiB /  50.1 MiB (100 %)   8.7 MiB/s in  6s ETA:  0s
info: downloading component 'rustfmt'
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
 16.7 MiB /  16.7 MiB (100 %)  12.6 MiB/s in  1s ETA:  0s
info: installing component 'rust-std'
 21.9 MiB /  21.9 MiB (100 %)  16.0 MiB/s in  1s ETA:  0s
info: installing component 'rustc'
 50.1 MiB /  50.1 MiB (100 %)  17.8 MiB/s in  2s ETA:  0s
info: installing component 'rustfmt'
info: default toolchain set to 'stable-x86_64-unknown-linux-gnu'

  stable-x86_64-unknown-linux-gnu installed - rustc 1.54.0 (a178d0322 2021-07-26)


Rust is installed now. Great!

To get started you may need to restart your current shell.
This would reload your PATH environment variable to include
Cargo's bin directory ($HOME/.cargo/bin).

To configure your current shell, run:
source $HOME/.cargo/env
```


如果不想重新登录而立即生效，只需要在终端执行命令 `source $HOME/.cargo/env` 即可。

验证安装：

```bash
rustc --version
rustc 1.54.0 (a178d0322 2021-07-26)
```

### 配置cargo

打开（或创建）文件  `~/.cargo/config`，加入以下内容：

```properties
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
```

参考：

- [rust - How do I debug `cargo build` hanging at "Updating crates.io index"? - Stack Overflow](https://stackoverflow.com/questions/53361052/how-do-i-debug-cargo-build-hanging-at-updating-crates-io-index)