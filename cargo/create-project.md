# 创建新项目

- https://kaisery.github.io/trpl-zh-cn/ch01-02-hello-world.html

```bash
$ cargo new hello_cargo --bin
```

为了生成可执行程序，需要传递`--bin`参数，如果只是一个库就不需要这个参数。

生成的目录结构如下：

```bash
$ tree -a
.
├── Cargo.toml
├── .git
│   ├── config
│   ├── description
......
├── .gitignore
└── src
    └── main.rs
```

### Cargo.toml

```bash
[package]
name = "proxy"
version = "0.1.0"
authors = ["Sky Ao <aoxiaojian@gmail.com>"]

[dependencies]
```