---
title: "Linux 安装"
linkTitle: "Linux"
date: 2025-04-09
weight: 10
description: >
  在 Linux 上安装 Rust
---

### 安装

执行命令：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

然后依照屏幕提示：

```bash
info: downloading installer

Welcome to Rust!

This will download and install the official compiler for the Rust
programming language, and its package manager, Cargo.

Rustup metadata and toolchains will be installed into the Rustup
home directory, located at:

  /home/sky/.rustup

This can be modified with the RUSTUP_HOME environment variable.

The Cargo home directory is located at:

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

1) Proceed with standard installation (default - just press enter)
2) Customize installation
3) Cancel installation
>
```

这里选择1默认模式，继续：

```bash
info: profile set to 'default'
info: default host triple is x86_64-unknown-linux-gnu
info: syncing channel updates for 'stable-x86_64-unknown-linux-gnu'
info: latest update on 2025-10-30, rust version 1.91.0 (f8297e351 2025-10-28)
info: downloading component 'cargo'
info: downloading component 'clippy'
info: downloading component 'rust-docs'
 20.4 MiB /  20.4 MiB (100 %)  12.2 MiB/s in  1s         
info: downloading component 'rust-std'
 27.9 MiB /  27.9 MiB (100 %)  13.8 MiB/s in  2s         
info: downloading component 'rustc'
 74.5 MiB /  74.5 MiB (100 %)  17.2 MiB/s in  4s         
info: downloading component 'rustfmt'
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
info: installing component 'rust-std'
 27.9 MiB /  27.9 MiB (100 %)  24.1 MiB/s in  1s         
info: installing component 'rustc'
 74.5 MiB /  74.5 MiB (100 %)  25.5 MiB/s in  2s         
info: installing component 'rustfmt'
info: default toolchain set to 'stable-x86_64-unknown-linux-gnu'

  stable-x86_64-unknown-linux-gnu installed - rustc 1.91.0 (f8297e351 2025-10-28)


Rust is installed now. Great!

To get started you may need to restart your current shell.
This would reload your PATH environment variable to include
Cargo's bin directory ($HOME/.cargo/bin).

To configure your current shell, you need to source
the corresponding env file under $HOME/.cargo.

This is usually done by running one of the following (note the leading DOT):
. "$HOME/.cargo/env"            # For sh/bash/zsh/ash/dash/pdksh
source "$HOME/.cargo/env.fish"  # For fish
source $"($nu.home-path)/.cargo/env.nu"  # For nushell
```

```bash
vi ~/.zshrc
```

在文件末尾加入：

```bash
# rust
. "$HOME/.cargo/env"
```

保存退出， 重新登录， 或者执行命令：

```bash
source $HOME/.cargo/env
```

验证安装：

```bash
$ rustc --version
rustc 1.91.0 (f8297e351 2025-10-28)
```
