---
title: "Cargo Reference笔记: 工作区"
linkTitle: "Reference 3.3工作区"
weight: 328
date: 2021-10-22
description: >
  Rust Cargo Reference笔记：3.3节工作区
---

https://doc.rust-lang.org/cargo/reference/workspaces.html

## 3.3 工作区

工作空间是一个或多个软件包的集合，它们共享共同的依赖性解析（有一个共享的Cargo.lock）、输出目录和各种设置，如配置文件。作为工作区一部分的包被称为工作区成员。有两种类型的工作空间：根包(Root package)或虚拟清单(Virtual manifest)。

### 根包(Root Package)

通过在 `Cargo.toml` 中添加 `[workspace]` 部分可以创建一个工作区。这可以添加到已经定义了 `[package]` 的 `Cargo.toml` 中，在这种情况下，该包是工作区的根包(Root package)。工作区根(workspace root)是工作区的 `Cargo.toml` 所在的目录。

### 虚拟清单(Virtual Manifest)

另外，在创建 Cargo.toml 文件时，也可以在其中加入 `[workspace]` 部分，但不加入 `[package]` 部分。这被称为虚拟清单。这通常适用于没有 "主要 " 软件包的情况，或者您希望将所有软件包放在不同的目录中。

### 关键特征

工作区的关键点是:

- 所有软件包共享一个共同的 `Cargo.lock` 文件，该文件驻留在工作区根部。

- 所有软件包共享一个共同的输出目录，该目录默认为工作区根目录下的target。

- `Cargo.toml` 中的 `[patch]`、`[replace]` 和 `[profile.*]` 部分只在根清单中被识别，而在 crate 的清单中被忽略。

### [workspace]部分

`Cargo.toml` 中的 `[workspace]` 表定义了哪些软件包是工作区的成员。

```toml
[workspace]
members = ["member1", "path/to/member2", "crates/*"]
exclude = ["crates/foo", "path/to/other"]
```

驻留在工作区目录中的所有路径依赖自动成为成员。其他成员可以用 members 键列出，members 键应该是一个包含 `Cargo.toml` 文件的目录的字符串数组。

成员列表还支持使用典型的文件名glob模式，如 `*` 和 `？`

exclude key 可以用来防止路径被包含在一个工作区中。如果某些路径的依赖关系根本不希望出现在工作区中，或者使用 glob 模式而你想删除一个目录，这就很有用。

空的 `[workspace]` 表可以和 `[package]` 一起使用，以方便地创建一个包含该包和其所有路径依赖的工作区。

### 工作区选择

当在工作区的子目录内时，`Cargo` 会自动在父目录中搜索带有 `[workspace]` 定义的 `Cargo.toml` 文件，以确定使用哪个工作区。`package.workspace` 清单键可以在 crate 中用来指向工作空间的根，以覆盖这种自动搜索。如果成员不在工作区根的子目录内，手动设置会很有用。

### 包的选择

在工作区中，与包相关的 `cargo` 命令，如 `cargo build`，可以使用 `-p / --package` 或 `--workspace` 命令行标志来决定对哪些包进行操作。如果没有指定这两个标志，Cargo将使用当前工作目录下的软件包。如果当前目录是一个虚拟工作区，它将适用于所有成员（就像在命令行中指定 `--workspace` 一样）。

可以指定可选的 `default-members` 键，以设置在工作区根部和不使用包选择标志时要操作的成员。

```toml
[workspace]
members = ["path/to/member1", "path/to/member2", "path/to/member3/*"]
default-members = ["path/to/member2", "path/to/member3/foo"]
```

当指定时，`default-members` 必须扩展到一个成员的子集。

### Workspace.metadata表

`Workspace.metadata` 表会被 `Cargo` 忽略，不会被警告。这一部分可以用于那些想在 `Cargo.toml` 中存储工作空间配置的工具。比如说。

```toml
[workspace]
members = ["member1", "member2"]

[workspace.metadata.webcontents]
root = "path/to/webproject"
tool = ["npm", "run", "build"]
# ...
```

在 `package.metadata` 中也有一组类似的表格。虽然 cargo 没有为这两个表的内容指定格式，但建议外部工具可能希望以一致的方式使用它们，例如，如果 `package.metadata` 中缺少数据，可以参考 `workspace.metadata` 中的数据，如果这对相关工具来说是有意义的。



