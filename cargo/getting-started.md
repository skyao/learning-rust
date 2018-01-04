## 快速入门

## 安装

安装cargo最简单的办法是使用`rustup`脚本：

```bash
$ curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

## 创建新项目

开始新项目，`--bin`表示这是一个二进制程序：

```bash
$ cargo new proxy --bin
```

生成的目录结构如下：

```bash
$ tree -a
.
├── Cargo.toml
├── .git
├── .gitignore
└── src
    └── main.rs
```

cargo.toml文件被称为`manifest`，包含所有cargo用于编译项目所需的元数据:

```bash
[package]
name = "proxy"
version = "0.1.0"
authors = ["Sky Ao <aoxiaojian@gmail.com>"]

[dependencies]
```

更多详细信息，请见 [The Manifest Format](http://doc.crates.io/manifest.html#the-project-layout)

## 编译运行

```bash
$ cargo build
```

在项目的根目录下（注意如果是子项目，则需要进入顶层目录），`target/debug`文件夹，能找到buid出来的文件，可以直接运行：

```bash
$ ./target/debug/proxy
```

或者通过`cargo run`命令执行：

```bash
$ cargo run
```
