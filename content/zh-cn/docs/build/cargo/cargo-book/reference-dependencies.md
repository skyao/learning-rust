---
title: "Cargo Reference笔记: 依赖"
linkTitle: "Reference 3.1依赖"
weight: 326
date: 2021-10-22
description: >
  Rust Cargo Reference笔记：3.1节依赖
---

https://doc.rust-lang.org/cargo/reference/index.html

## 3.1 指定依赖关系

crates 可以依赖 crates.io 或其他注册表、git 存储库或本地文件系统中的子目录中的其他库。你也可以暂时覆盖一个依赖的位置--例如，能够测试出你正在本地工作的依赖中的错误修复。你可以为不同的平台设置不同的依赖关系，以及只在开发期间使用的依赖关系。让我们来看看如何做到这些。

### 从crates.io中指定依赖项

Cargo的配置是默认在 crates.io 上寻找依赖项。在这种情况下，只需要名称和一个版本字符串。在 crate 指南中，我们指定了对 time create 的依赖:

```toml
[dependencies]
time = "0.1.12"
```

字符串 "0.1.12" 是 semver (语义化）版本要求。由于这个字符串中没有任何运算符，它被解释为与我们指定 "^0.1.12" 的方式相同，这被称为关照需求（caret requirement）。

### Caret Requirement

关照需求（caret requirement）允许 SemVer 兼容更新到一个指定的版本。如果新的版本号没有修改主要、次要、补丁分组中最左边的非零数字，则允许更新。在这种情况下，如果我们运行 `cargo update -p time`，如果是最新的 `0.1.z` 版本，cargo应该将我们更新到 `0.1.13` 版本，但不会将我们更新到 `0.2.0` 。如果我们将版本字符串指定为 `^1.0` ，如果是最新的 `1.y` 版本，cargo应该更新到 `1.1`，但不是 `2.0`。`0.0.x` 版本不被认为与其他任何版本兼容。

下面是一些更多的关照需求的例子，以及允许使用这些要求的版本:

```bash
^1.2.3  :=  >=1.2.3, <2.0.0
^1.2    :=  >=1.2.0, <2.0.0
^1      :=  >=1.0.0, <2.0.0
^0.2.3  :=  >=0.2.3, <0.3.0
^0.2    :=  >=0.2.0, <0.3.0
^0.0.3  :=  >=0.0.3, <0.0.4
^0.0    :=  >=0.0.0, <0.1.0
^0      :=  >=0.0.0, <1.0.0
```

这个兼容性约定与 SemVer 在对待1.0.0之前的版本的方式不同。SemVer 说 1.0.0 之前没有兼容性，而 Cargo 认为 `0.x.y` 与 `0.x.z` 兼容，其中 `y≥z` 且 `x>0`。

### Tilde Requirement

Tilde Requirement指定了最小版本并具有一定的更新能力。如果你指定一个主要的、次要的和补丁的版本，或者只指定一个主要的和次要的版本，那么只允许补丁级别的改变。如果你只指定一个主要的版本，那么次要的和补丁级的改变是允许的。

`~1.2.3` 是Tilde Requirement的例子:

```bash
~1.2.3  := >=1.2.3, <1.3.0
~1.2    := >=1.2.0, <1.3.0
~1      := >=1.0.0, <2.0.0
```

### 通配符要求

通配符要求允许通配符定位的任何版本。

`*`、`1.*`和`1.2.*`是通配符要求的例子。

```bash
*     := >=0.0.0
1.*   := >=1.0.0, <2.0.0
1.2.* := >=1.2.0, <1.3.0
```

{{% alert title="注意" color="primary" %}}
crates.io不允许有裸*版本。
{{% /alert %}}

### 比较要求

比较要求允许手动指定一个版本范围或一个确切的版本来依赖。

下面是一些比较要求的例子:

```bash
>= 1.2.0
> 1
< 2
= 1.2.3
```

### 多重要求

如上面的例子所示，多个版本的要求可以用逗号分开，例如，`>=1.2`，`<1.5`。

### 指定来自其他注册表的依赖关系

要从 crates.io 以外的注册中心指定一个依赖关系，首先必须在 `.cargo/config.toml` 文件中配置该注册中心。更多信息请参见注册表文档。在依赖关系中，将 `registry` 的键值设置为要使用的注册表的名称。

```toml
[dependencies]
some-crate = { version = "1.0", registry = "my-registry" }
```

{{% alert title="注意" color="primary" %}}
crates.io不允许发布依赖其他注册机构的软件包。
{{% /alert %}}

### 指定来自 git 仓库的依赖关系

要依赖位于git仓库中的库，你需要指定的最小信息是带有git钥匙的仓库的位置:

```toml
[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand" }
```

Cargo会在这个位置获取git仓库，然后在git仓库的任何地方寻找所要求的 crate 的 Cargo.toml（不一定在根部--例如，指定一个工作区的成员crate名称，并设置git为包含该工作区的仓库）。

由于我们没有指定任何其他信息，Cargo假定我们打算使用主分支上的最新提交来构建我们的包。你可以将 `git` key 与 `rev`、`tag` 或 `branch` 键结合起来，指定其他内容。下面是一个指定要使用 `next` 分支上的最新提交的例子:

```toml
[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand", branch = "next" }
```

一旦添加了git依赖，Cargo会将该依赖锁定在当时的最新提交。一旦锁定，新的提交将不会被自动拉下。不过，它们可以通过 `cargo update` 手动拉下。

请参阅Git认证，以获得关于私有仓库的Git认证的帮助。

{{% alert title="注意" color="primary" %}}
crates.io 不允许发布带有git依赖的软件包（git dev-dependencies 被忽略）。请参阅 "多个位置"一节，以获得后备选择。
{{% /alert %}}

### 指定路径依赖

随着时间的推移，我们在指南中的 ·hello_world· 包的体积已经大大增加了。我们可能想把它拆成一个单独的 crate 供别人使用。为了做到这一点，Cargo支持路径依赖，通常是在一个仓库中的子程序。让我们先在 `hello_world` 包中建立一个新的crate:


```toml
# 在hello_world/的内部
$ cargo new hello_utils
```

这将创建一个新的文件夹 `hello_utils`，其中的 `Cargo.toml` 和 `src` 文件夹已经准备好被配置。为了告诉 Cargo 这一点，打开 `hello_world/Cargo.toml`，将 `hello_utils` 添加到你的依赖项中。

```toml
[dependencies]
hello_utils = { path = "hello_utils" }
```

这就告诉Cargo，我们依赖一个叫 `hello_utils` 的crate，这个crate在 `hello_utils` 文件夹中（相对于它所写的 `Cargo.toml`）。

就这样了! 下一次 crate 构建将自动构建 `hello_utils` 和它自己的所有依赖项，其他人也可以开始使用这个crate。然而，crates.io 上不允许使用只指定路径的依赖项。如果我们想发布我们的 `hello_world` crate，我们需要将 `hello_utils` 的一个版本发布到crates.io，并在依赖项中指定其版本。

```toml
[dependencies]
hello_utils = { path = "hello_utils", version = "0.1.0" }
```

{{% alert title="注意" color="primary" %}}
crates.io 不允许发布带有路径依赖的包（路径 dev-dependencies 被忽略）。请参阅 "多个位置" 一节，以获得后备选择。
{{% /alert %}}

### 多个位置

可以同时指定注册表版本和 `git` 或 `path` 位置。`git` 或 `path` 依赖将在本地使用（在这种情况下，`version` 会与本地副本进行核对），而当发布到 crates.io 这样的注册表时，它将使用注册表的版本。其他组合是不允许的。例子:

```
[dependencies]
# 在本地使用时使用`my-bitflags`，发布时使用 crates.io 的 1.0 版本。
bitflags = { path = "my-bitflags", version = "1.0" }

# 在本地使用时使用给定的git repo，发布时使用crates.io的1.0版本。
smallvec = { git = "https://github.com/servo/rust-smallvec", version = "1.0" }

# 注意：如果版本不匹配，Cargo将无法编译!
```

一个有用的例子是，当你把一个库拆成多个包放在同一个工作区时。你可以使用路径依赖来指向工作区中的本地包，以便在开发过程中使用本地版本，然后在发布后使用 crates.io 版本。这类似于指定一个覆盖，但只适用于这一个依赖声明。

### 特定平台的依赖性

特定平台的依赖关系采用相同的格式，但被列在 `target` 部分。通常情况下，类似Rust的 `#[cfg]语法` 将被用来定义这些部分:

```toml
[target.'cfg(windows)'.dependencies]
winhttp = "0.4.0"

[target.'cfg(unix)'.dependencies]
openssl = "1.0.1"

[target.'cfg(target_arch = "x86")'.dependencies]
native = { path = "native/i686" }

[target.'cfg(target_arch = "x86_64")'.dependencies]
native = { path = "native/x86_64" }
```

和Rust一样，这里的语法支持 `not`、`any` 和 `all` 操作符，以组合各种 cfg name/value 对。

如果你想知道哪些 cfg 目标在你的平台上可用，在命令行中运行 `rustc --print=cfg`。如果你想知道哪些cfg目标在其他平台上可用，比如64位Windows，可以运行 `rustc --print=cfg --target=x86_64-pc-windows-msvc`。

{{% alert title="linux平台的执行结果:" color="info" %}}

```
$ rustc --print=cfg
debug_assertions
target_arch="x86_64"
target_endian="little"
target_env="gnu"
target_family="unix"
target_feature="fxsr"
target_feature="sse"
target_feature="sse2"
target_os="linux"
target_pointer_width="64"
target_vendor="unknown"
unix
```
{{% /alert %}}

与你的 Rust 源代码不同，你不能使用 `[target.'cfg(feature = "fancy-feature")'.dependencies]` 来添加基于可选特性的依赖关系。请使用 `[features]` 部分来代替。

```toml
[dependencies]
foo = { version = "1.0", optional = true }
bar = { version = "1.0", optional = true }

[features]
fancy-feature = ["foo", "bar"]
```

这同样适用于 `cfg(debug_assertions)`、`cfg(test)` 和 `cfg(proc_macro)`。这些值不会像预期的那样工作，而总是有 `rustc --print=cfg` 所返回的默认值。目前还没有办法根据这些配置值来添加依赖关系。

除了 `#[cfg]` 语法外，Cargo还支持列出依赖关系所适用的完整目标:

```toml
[target.x86_64-pc-windows-gnu.dependencies]
winhttp = "0.4.0"

[target.i686-unknown-linux-gnu.dependencies]
openssl = "1.0.1"
```

### 开发依赖

你可以在你的 Cargo.toml 中添加一个 `[dev-dependencies]` 部分，其格式相当于`[dependencies]`。

```toml
[dev-dependencies]
tempdir = "0.3"
```

Dev-dependencies 在编译软件包时不使用，但用于编译 tests、 examples 和 benchmarks。

这些依赖关系不会传播到其他依赖该软件包的软件包上。

你也可以通过在目标部分的标题中使用 `dev-dependencies` 而不是 `dependencies` 来获得特定目标的开发依赖。比如说:

```toml
[target.'cfg(unix)'.dev-dependencies]
mio = "0.0.1"
```

{{% alert title="注意" color="primary" %}}
注意：当一个软件包被发布时，只有指定 `version` 的 `dev-dependencies` 才会被包含在发布的crate中。对于大多数使用情况，发布时不需要 `dev-dependencies`，尽管有些用户（如操作系统打包者）可能想在crate中运行测试，所以如果可能的话，提供 `version` 仍然是有益的。
{{% /alert %}}

### 构建依赖性

您可以在您的构建脚本中依赖其他基于Cargo的 crate 来使用。依赖关系通过清单中的 `build-dependencies` 部分来声明。

```toml
[build-dependencies]
cc = "1.0.3"
```

你也可以通过在目标部分标题中使用 `build-dependencies` 而不是 `dependencies` 来获得特定目标的构建依赖。比如说:

```toml
[target.'cfg(unix)'.build-dependencies]
cc = "1.0.3"
```

在这种情况下，只有当主机平台与指定的目标相匹配时，才会构建该依赖关系。

构建脚本不能访问在 `dependencies` 或 `dev-dependencies` 部分列出的依赖项。除非在依赖关系部分列出，否则构建依赖关系对软件包本身也同样不可用。软件包本身和它的构建脚本是分开构建的，所以它们的依赖关系不需要重合。通过为独立的目的使用独立的依赖关系，Cargo可以保持更简单、更干净。

### 选择特性

如果你依赖的软件包提供了有条件的特性，你可以指定使用哪些特性:

```toml
[dependencies.awesome]
version = "1.3.5"
default-features = false # 不包括默认功能，并可选择挑选个别功能
features = ["secure-password", "civet"]
```

### 重命名Cargo.toml中的依赖项

在 Cargo.toml 中编写 `[dependencies]` 部分时，你为依赖关系编写的键通常与你在代码中导入的crate的名称一致。但对于某些项目，你可能希望在代码中用不同的名字来引用crate，而不管它在 crates.io 上是如何发布的。例如，你可能希望:

- 避免在Rust源代码中需要 `use foo as bar` 。
- 依赖于一个 crate 的多个版本。
- 依赖于不同注册中心的同名crate。

为了支持这一点，Cargo在 `[dependencies]` 部分支持包的 key，即应该依赖哪个包:

```toml
[package]
name = "mypackage"
version = "0.0.1"

[dependencies]
foo = "0.1"
bar = { git = "https://github.com/example/project", package = "foo" }
baz = { version = "0.1", registry = "custom", package = "foo" }
```

在这个例子中，你的Rust代码中现在有三个crate可用:

```rust
extern crate foo; // crates.io
extern crate bar; // git repository
extern crate baz; // registry `custom`
```

这三个crate在它们自己的 Cargo.toml 中都有 `foo` 的包名，所以我们明确地使用 package key 来通知Cargo我们想要foo的包，尽管我们在本地调用了其他东西。如果没有指定 package 的 key，则默认为被请求的依赖关系的名称。

注意，如果你有一个可选的依赖关系，比如:

```toml
[dependencies]
bar = { version = "0.1", package = 'foo', optional = true }
```

你依赖于 crates.io 的 crate foo，但你的 crate 有一个 bar 特性而不是 foo 特性。也就是说，当重命名时，特性的名称会跟随依赖关系的名称，而不是软件包的名称。

启用反式依赖的工作原理与此类似，例如我们可以在上述清单中添加以下内容:

```toml
[features]
log-debug = ['bar/log-debug'] # using 'foo/log-debug' would be an error!
```

## 3.1.1 覆盖依赖

### 覆盖依赖关系

覆盖依赖关系的愿望可以通过多种情况产生。然而，大多数情况下，都可以归结为在 crates.io 上发布之前就能使用一个crate。比如说：

- 你正在开发的一个 crate 也被用于你正在开发的一个更大的应用程序中，你想在这个更大的应用程序中测试一个库的错误修复。
- 一个你不负责的上游代码库在其 git 仓库的主分支上有一个新的功能或错误修复，你想测试一下。
- 你即将发布一个新的主要版本，但你想在整个软件包中进行集成测试，以确保新的主要版本能够正常运行。
- 你已经为你发现的一个bug向上游 crate 提交了一个修复，但你想立即让你的应用程序开始依赖于 crate 的固定版本，以避免bug修复被合并时的阻塞。

这些情况可以通过 `[patch] 清单部分` 来解决。

本章将介绍几种不同的使用情况，并详细介绍覆盖依赖关系的不同方法。

### 测试错误修复

假设你正在使用 uuid crate，但当你在工作中发现了一个错误。不过，你很有进取心，所以你决定也尝试修复这个错误。最初，你的清单是这样的：

```toml
[package]
name = "my-library"
version = "0.1.0"

[dependencies]
uuid = "1.0"
```

我们要做的第一件事是通过以下方式在本地克隆 uuid 仓库:

```bash
$ git clone https://github.com/uuid-rs/uuid
```

接下来我们将编辑my-library的清单，使其包含:

```toml
[patch.crates-io]
uuid = { path = "../path/to/uuid" }
```

这里我们声明，我们正在给源代码 `crates-io` 打上一个新的依赖关系。这将有效地把本地签出的 `uuid` 版本添加到我们本地软件包的 crates.io 注册表中。

接下来我们需要确保我们的锁文件被更新以使用这个新版本的 `uuid`，这样我们的包就会使用本地签出的副本而不是来自 `crates.io` 的。`[patch]` 的工作方式是，它将在 `../path/to/uuid` 加载依赖关系，然后当 `crates.io` 被查询 `uuid` 的版本时，它也会返回本地版本。

这意味着本地检出的版本号很重要，会影响到补丁是否被使用。我们的清单声明 `uuid="1.0"`，这意味着我们只解析 `>=1.0.0，<2.0.0`，而且Cargo的贪婪解析算法也意味着我们会解析到该范围内的最大版本。通常情况下，这并不重要，因为 git 仓库的版本已经大于或符合 crates.io 上发布的最大版本，但记住这一点很重要!

在任何情况下，通常你现在需要做的就是:

```bash
$ cargo build
   Compiling uuid v1.0.0 (.../uuid)
   Compiling my-library v0.1.0 (.../my-library)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

就这样了，您现在正在使用本地版本的 uuid 进行构建（注意构建输出中括号中的路径）。如果你没有看到本地路径的版本被构建，那么你可能需要运行 `cargo update -p uuid --precise $version` ，其中 `$version` 是本地检查出的 uuid 副本的版本。

一旦你修复了你最初发现的错误，你要做的下一件事可能是把它作为一个拉动请求提交给 uuid crate 本身。一旦你完成了这项工作，你也可以更新 `[patch]` 部分。`[patch]` 中的列表就像 `[dependencies]` 部分一样，所以一旦你的拉动请求被合并，你可以将你的路径依赖改为。

```toml
[patch.crates-io]
uuid = { git = 'https://github.com/uuid-rs/uuid' }
```

### 使用未发布的次要版本

现在让我们从修复bug到添加功能的过程中转换一下齿轮。当你在 my-library 上工作时，你发现 uuid crate 中需要一个全新的功能。你已经实现了这个功能，用 `[patch]` 在本地进行了测试，并提交了一个拉动请求。让我们来看看在实际发布之前，你如何继续使用和测试它。

我们还假设 crates.io 上 uuid 的当前版本是 1.0.0，但此后 git 仓库的 master 分支已经更新到 1.0.1。这个分支包括你之前提交的新特性。为了使用这个仓库，我们将编辑我们的 Cargo.toml，使其看起来像:

```toml
[package]
name = "my-library"
version = "0.1.0"

[dependencies]
uuid = "1.0.1"

[patch.crates-io]
uuid = { git = 'https://github.com/uuid-rs/uuid' }
```

请注意，我们对 uuid 的本地依赖已经更新到了 1.0.1，因为一旦发布 crate，我们就需要这个版本。不过这个版本在 crates.io 上并不存在，所以我们在清单的 [patch] 部分提供了它。

现在，当我们的库被构建时，它会从 git 仓库中获取 uuid 并解析到仓库中的 1.0.1，而不是试图从 crates.io 上下载一个版本。一旦1.0.1在crates.io上发布，`[patch]` 部分就可以被删除。

值得注意的是，`[patch]` 也是过渡性应用。假设你在一个更大的软件包中使用 my-library，例如:

```toml
[package]
name = "my-binary"
version = "0.1.0"

[dependencies]
my-library = { git = 'https://example.com/git/my-library' }
uuid = "1.0"

[patch.crates-io]
uuid = { git = 'https://github.com/uuid-rs/uuid' }
```

请记住，`[patch]` 是过渡性的，但只能在顶层定义，所以我们 my-library 的消费者必须在必要时重复 `[patch]` 部分。不过在这里，新的 uuid crate 同时适用于我们对 uuid 的依赖和 my-library -> uuid 的依赖。uuid crate 将被解析为整个 crate 图的一个版本，即 1.0.1，并将从 git 仓库中提取。