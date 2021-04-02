---
title: "  Windows安装"
linkTitle: "  Windows安装"
date: 2021-03-29
weight: 202
description: >
  在Windows上安装Rust
---

### 安装vs2015

TBD: 下次验证，参考 https://rustlang-cn.org/office/rust/book/getting-started/ch01-01-installation.html

在安装rust之前，windows平台上需要先安装 Microsoft C++ build tools，推荐2015版本。如果不安装，后面在编译时，会报错说"link.exe"无法找到。

```bash
note: the msvc targets depend on the msvc linker but `link.exe` was not found

note: please ensure that VS 2013 or VS 2015 was installed with the Visual C++ option

error: aborting due to previous error

error: Could not compile `ws2_32-sys`
```

打开下面的网站：

http://landinghub.visualstudio.com/visual-cpp-build-tools

选择"Download Visual C++ Build Tools 2015"。

下载之后按照提示一路安装即可。

### windows安装rust

操作系统为windows 10 64位。

下载rustup.init.exe，然后安装，按照指示操作，中间要下载rustc等安装文件。

```bash
Rust Visual C++ prerequisites

If you will be targeting the GNU ABI or otherwise know what you are doing then
it is fine to continue installation without the build tools, but otherwise,
install the C++ build tools before proceeding.

Continue? (Y/n) y


Welcome to Rust!

This will download and install the official compiler for the Rust programming
language, and its package manager, Cargo.

It will add the cargo, rustc, rustup and other commands to Cargo's bin
directory, located at:

  C:\Users\aoxia\.cargo\bin

This path will then be added to your PATH environment variable by modifying the
HKEY_CURRENT_USER/Environment/PATH registry key.

You can uninstall at any time with rustup self uninstall and these changes will
be reverted.

Current installation options:

   default host triple: x86_64-pc-windows-msvc
     default toolchain: stable
  modify PATH variable: yes

1) Proceed with installation (default)
2) Customize installation
3) Cancel installation


info: updating existing rustup installation


Rust is installed now. Great!

To get started you need Cargo's bin directory (%USERPROFILE%\.cargo\bin) in
your PATH environment variable. Future applications will automatically have the
correct environment, but you may need to restart your current shell.

Press the Enter key to continue.
```

将 `%USERPROFILE%\.cargo\bin` 加入到PATH环境变量中。

验证安装，执行`rustc --version`：

```bash
$> rustc --version
rustc 1.33.0 (2aa4c46cf 2019-02-28) 
```