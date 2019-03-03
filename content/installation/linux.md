---
date: 2019-03-03T21:00:00+08:00
title: Linux&Mac安装
menu:
  main:
    parent: "installation"
weight: 201
description : "在Linux和Mac上安装Rust"
---

### 安装

执行命令：

```bash
$ curl https://sh.rustup.rs -sSf | sh
```

然后依照屏幕提示：

```bash
$ curl https://sh.rustup.rs -sSf | sh
info: downloading installer

Welcome to Rust!

This will download and install the official compiler for the Rust programming 
language, and its package manager, Cargo.

It will add the cargo, rustc, rustup and other commands to Cargo's bin 
directory, located at:

  /home/sky/.cargo/bin

This path will then be added to your PATH environment variable by modifying the
profile file located at:

  /home/sky/.profile

You can uninstall at any time with rustup self uninstall and these changes will
be reverted.

Current installation options:

   default host triple: x86_64-unknown-linux-gnu
     default toolchain: stable
  modify PATH variable: yes

1) Proceed with installation (default)
2) Customize installation
3) Cancel installation
>1

```

这里选择1默认模式，继续：

```bash
info: syncing channel updates for 'stable-x86_64-unknown-linux-gnu'
320.9 KiB / 320.9 KiB (100 %)  87.5 KiB/s ETA:   0 s                
info: latest update on 2019-02-28, rust version 1.33.0 (2aa4c46cf 2019-02-28)
info: downloading component 'rustc'
 84.7 MiB /  84.7 MiB (100 %)   1.2 MiB/s ETA:   0 s                 [[1;7C
info: downloading component 'rust-std'
 56.8 MiB /  56.8 MiB (100 %)   1.2 MiB/s ETA:   0 s                 
info: downloading component 'cargo'
  4.4 MiB /   4.4 MiB (100 %) 1011.8 KiB/s ETA:   0 s                
info: downloading component 'rust-docs'
  8.5 MiB /   8.5 MiB (100 %)   1.1 MiB/s ETA:   0 s                
info: installing component 'rustc'
info: installing component 'rust-std'
info: installing component 'cargo'
info: installing component 'rust-docs'
info: default toolchain set to 'stable'

  stable installed - rustc 1.33.0 (2aa4c46cf 2019-02-28)


Rust is installed now. Great!

To get started you need Cargo's bin directory ($HOME/.cargo/bin) in your PATH 
environment variable. Next time you log in this will be done automatically.

To configure your current shell run source $HOME/.cargo/env

```

此时安装程序已经修改了 `~/.profile` 文件，加入了下面这行内容：

```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

这个设置会在下次登录之后自动生效，如果不想重新登录而立即生效，只需要在终端执行命令 `source $HOME/.cargo/env` 即可。

验证安装：

```bash
$ rustc --version
rustc 1.33.0 (2aa4c46cf 2019-02-28)
```

### Openssl问题

如果compile时报错，找不到openssl：

```bash
cargo:rerun-if-env-changed=OPENSSL_DIR
run pkg_config fail: "`\"pkg-config\" \"--libs\" \"--cflags\" \"openssl\"` did not exit successfully: exit code: 1\n--- stderr\nPackage openssl was not found in the pkg-config search path.\nPerhaps you should add the directory containing `openssl.pc\'\nto the PKG_CONFIG_PATH environment variable\nNo package \'openssl\' found\n"
```

执行下列命令即可：

```bash
sudo apt-get install pkg-config libssl-dev
```

如果，上述安装命令遇到404错误：

```bash
错误:1 http://security.ubuntu.com/ubuntu xenial-security/main amd64 libssl1.0.0 amd64 1.0.2g-1ubuntu4.14
  404  Not Found
```

需要先执行 `sudo apt update` 命令，具体解释参考：

https://askubuntu.com/questions/903496/error-during-upgrade-on-ubuntu-16-04

## 