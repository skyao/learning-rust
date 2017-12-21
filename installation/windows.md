# windows安装

## 安装

操作系统为windows 10 64位。

下载rustup.init.exe，然后安装，按照指示操作，中间要下载rustc等安装文件。

```bash
Rust Visual C++ prerequisites

Rust requires the Microsoft C++ build tools for Visual Studio 2013 or later,
but they don't seem to be installed.

The easiest way to acquire the build tools is by installing Microsoft Visual
C++ Build Tools 2015 which provides just the Visual C++ build tools:

  http://landinghub.visualstudio.com/visual-cpp-build-tools

Alternately, you can install Visual Studio 2015 or Visual Studio 2013 and
during install select the "C++ tools":

  https://www.visualstudio.com/downloads/

Install the C++ build tools before proceeding.

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

## 配置

将 `%USERPROFILE%\.cargo\bin` 加入到PATH环境变量中。

## 验证

执行`rustc --version`：

```bash
$> rustc --version
rustc 1.22.1 (05e2e1c41 2017-11-22)
```
