# Ubuntu安装

## 安装

安装安装文档，执行`curl https://sh.rustup.rs -sSf | sh`：

```bash
curl https://sh.rustup.rs -sSf | sh

info: downloading installer
# 这里如果网速慢，会等很久，请耐心

Welcome to Rust!

This will download and install the official compiler for the Rust programming language, and its package manager, Cargo.

It will add the cargo, rustc, rustup and other commands to Cargo's bin directory, located at:

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

info: syncing channel updates for 'stable-x86_64-unknown-linux-gnu'
236.7 KiB / 236.7 KiB (100 %)  53.0 KiB/s ETA:   0 s
info: latest update on 2017-11-23, rust version 1.22.1 (05e2e1c41 2017-11-22)
info: downloading component 'rustc'
 38.5 MiB /  38.5 MiB (100 %)  44.8 KiB/s ETA:   0 s
info: downloading component 'rust-std'
 54.2 MiB /  54.2 MiB (100 %)  32.0 KiB/s ETA:   0 s
info: downloading component 'cargo'
  3.8 MiB /   3.8 MiB (100 %)  20.0 KiB/s ETA:   0 s
info: downloading component 'rust-docs'
  4.2 MiB /   4.2 MiB (100 %)  31.3 KiB/s ETA:   0 s
info: installing component 'rustc'
info: installing component 'rust-std'
info: installing component 'cargo'
info: installing component 'rust-docs'
info: default toolchain set to 'stable'

  stable installed - rustc 1.22.1 (05e2e1c41 2017-11-22)

Rust is installed now. Great!

To get started you need Cargo's bin directory ($HOME/.cargo/bin) in your PATH environment variable. Next time you log in this will be done automatically.

To configure your current shell run source $HOME/.cargo/env
```

## 配置

在`~/.bashrc`文件中增加下列内容：

```bash
#rust
export PATH=$HOME/.cargo/bin:$PATH
```

## 验证

执行`rustc --version`：

```bash
$> rustc --version
rustc 1.22.1 (05e2e1c41 2017-11-22)
```

## 安装openssl

如果compile时报错，找不到openssl：

```bash
cargo:rerun-if-env-changed=OPENSSL_DIR
run pkg_config fail: "`\"pkg-config\" \"--libs\" \"--cflags\" \"openssl\"` did not exit successfully: exit code: 1\n--- stderr\nPackage openssl was not found in the pkg-config search path.\nPerhaps you should add the directory containing `openssl.pc\'\nto the PKG_CONFIG_PATH environment variable\nNo package \'openssl\' found\n"
```

执行下列命令即可：

```bash
sudo apt-get install pkg-config libssl-dev
```

