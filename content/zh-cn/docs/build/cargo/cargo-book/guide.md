---
title: "Rust Cargo Book之指南"
linkTitle: "Cargo 指南"
weight: 325
date: 2021-10-21
description: >
  Rust Cargo Book之指南
---

https://doc.rust-lang.org/cargo/guide/index.html

## 2.1 为什么cargo会存在

### 前言

在Rust中，你可能知道，一个库或可执行程序被称为 crate。Crate 是用Rust编译器rustc来编译的。当开始使用Rust时，大多数人遇到的第一个源代码是古老的 "hello world" 程序，他们通过直接调用rustc来编译它。

```bash
$ rustc hello.rs
$ ./hello
Hello, world!
```

注意，上面的命令要求我们明确指定文件名。如果我们要直接使用 rustc 来编译一个不同的程序，就需要用不同的命令行来调用。如果我们需要指定任何特定的编译器标志或包括外部依赖，那么需要的命令将更加具体（和详细）。

此外，大多数非微不足道的程序可能会有对外部库的依赖性，因此也会对其依赖性进行转接。获得所有必要的依赖的正确版本，并保持它们的更新，如果用手工完成，将是费力和容易出错的。

我们可以通过引入更高级别的 "package/包" 抽象和使用包管理器来避免执行上述任务所涉及的手工繁琐工作，而不是仅仅使用 crates 和 rustc。

### 进入:Cargo

Cargo是Rust的包管理器。它是一个允许Rust包声明其各种依赖关系的工具，并确保你总是得到一个可重复的构建。

为了实现这个目标，Cargo做了四件事:

- 引入两个元数据文件，包含各种包的信息。
- 获取并构建软件包的依赖项。
- 调用 rustc 或其他具有正确参数的构建工具来构建你的软件包。
- 引入惯例，使Rust包的工作更容易。

在很大程度上，Cargo将构建一个特定程序或库所需的命令规范化；这是上述约定的一个方面。正如我们在后面所展示的，同一个命令可以用来构建不同的工件，不管它们的名字是什么。与其直接调用rustc，我们不如调用一些通用的东西，比如 cargo build，让cargo来考虑构建正确的rustc调用。此外，Cargo会自动从注册表中获取我们为工件定义的任何依赖关系，并根据需要安排将其纳入我们的构建中。

可以说，一旦你知道如何构建一个基于Cargo的项目，你就知道如何构建所有的项目，这只是一个小小的夸张。

## 2.2 创建一个新包


要用Cargo启动一个新的软件包，请使用cargo new:

```bash
$ cargo new hello_world --bin
```

我们传递 `--bin` 是因为我们在制作二进制程序：如果我们在制作库，我们会传递 `--lib`。这也会默认初始化一个新的 git 仓库。如果你不希望它这么做，可以传递 `--vcs none`。

让我们看看Cargo为我们生成了什么:

```bash
$ cd hello_world
$ tree .
.
├── Cargo.toml
└── src
    └── main.rs

1 directory, 2 files
```

让我们仔细看看Cargo.toml。


```properties
[package]
name = "hello_world"
version = "0.1.0"
edition = "2018"

[dependencies]
```

这被称为 manifest / 清单，它包含了Cargo编译你的包时需要的所有元数据。这个文件是以TOML格式（发音为/tɑməl/）编写的。

下面是 src/main.rs 中的内容:

```rust
fn main() {
    println! ("Hello, world!");
}
```

Cargo为我们生成了一个 "hello world " 程序，也就是所谓的二进制crate。让我们来编译它。

```bash
$ cargo build
   Compiling hello_world v0.1.0 (file:///path/to/package/hello_world)
```

然后运行它：

```bash
$ ./target/debug/hello_world
Hello, world!
```

我们也可以用cargo run来编译，然后运行，一步到位（如果你在上次编译后没有做任何改动，你就不会看到编译这一行）:

```bash
$ cargo run
   Compiling hello_world v0.1.0 (file:///path/to/package/hello_world)
     Running `target/debug/hello_world`
Hello, world!
```

现在你会注意到一个新文件，Cargo.lock。它包含了关于我们的依赖关系的信息。因为我们还没有任何依赖，所以它不是很有趣。

一旦你准备好发布，你可以使用cargo build --release来编译你的文件，并打开优化功能。

```bash
$ cargo build --release
   Compiling hello_world v0.1.0 (file:///path/to/package/hello_world)
```

`cargo build --release` 将生成的二进制文件放在 `target/release` 而不是 `target/debug` 中。

在调试模式下编译是默认的开发模式。由于编译器不做优化，所以编译时间更短，但代码的运行速度会更慢。发布模式的编译时间更长，但代码的运行速度会更快。

## 2.3 在现有的Cargo包上工作

如果你下载了一个现有的使用Cargo的包，那就很容易开始工作了。

首先，从某处获取该包。在这个例子中，我们将使用从GitHub上的存储库中克隆的rand:

```bash
$ git clone https://github.com/rust-lang-nursery/rand.git
$ cd rand
```

要构建，请使用 cargo build。

```bash
$ cargo build
   Compiling rand v0.1.0 (file:///path/to/package/rand)
```

这将获取所有的依赖项，然后与软件包一起构建它们。

## 2.4 依赖

crates.io 是Rust社区的中央软件包注册中心，作为发现和下载软件包的地点。Cargo的配置是默认使用它来寻找所需的软件包。

要依赖crates.io上的库，请将其添加到你的Cargo.toml中。

### 添加依赖项

如果你的 `Cargo.toml` 还没有 `[dependencies]` 部分，请添加它，然后列出你想要使用的 crate 名称和版本。这个例子添加了对 `time` crate 的依赖:

```toml
[dependencies]
time = "0.1.12"
```

版本字符串要求是 semver (语义化)版本。在指定依赖关系的文档中，有更多关于你在这里的选项的信息。

如果我们还想添加对 `regex` crate 的依赖，我们就不需要为列出的每个 crate 添加 `[dependencies]`。下面是你的整个 `Cargo.toml` 文件中对 time 和 regex crate 的依赖情况:

```toml
[package]
name = "hello_world"
version = "0.1.0"
edition = "2018"

[dependencies]
time = "0.1.12"
regex = "0.1.41"
```

重新运行 `cargo build` ，Cargo会获取新的依赖项和所有的依赖项，将它们全部编译，并更新 `Cargo.lock`:

```bash
$ cargo build
      Updating crates.io index
   Downloading memchr v0.1.5
   Downloading libc v0.1.10
   Downloading regex-syntax v0.2.1
   Downloading memchr v0.1.5
   Downloading aho-corasick v0.3.0
   Downloading regex v0.1.41
     Compiling memchr v0.1.5
     Compiling libc v0.1.10
     Compiling regex-syntax v0.2.1
     Compiling memchr v0.1.5
     Compiling aho-corasick v0.3.0
     Compiling regex v0.1.41
     Compiling hello_world v0.1.0 (file:///path/to/package/hello_world)
```

我们的 Cargo.lock 包含了所有这些依赖的确切信息，即我们使用了哪个版本。

现在，如果 `regex` 被更新，我们仍然会用相同的版本进行构建，直到我们选择 `cargo update`。

现在你可以在 main.rs 中使用 regex 库了。


使用 regex::Regex。

```rust
use regex::Regex;

fn main() {
    let re = Regex::new(r"^\d{4}-\d{2}-\d{2}$").unwrap();
    println!("Did our date match? {}", re.is_match("2014-01-01"));
}
```

运行它将显示:

```bash
$ cargo run
   Running `target/hello_world`
Did our date match? true
```

## 2.5 包的布局

Cargo使用约定俗成的文件放置方式，使其更容易深入到一个新的Cargo包中:

```bash
.
├── Cargo.lock
├── Cargo.toml
├── src/
│   ├── lib.rs
│   ├── main.rs
│   └── bin/
│       ├── named-executable.rs
│       ├── another-executable.rs
│       └── multi-file-executable/
│           ├── main.rs
│           └── some_module.rs
├── benches/
│   ├── large-input.rs
│   └── multi-file-bench/
│       ├── main.rs
│       └── bench_module.rs
├── examples/
│   ├── simple.rs
│   └── multi-file-example/
│       ├── main.rs
│       └── ex_module.rs
└── tests/
    ├── some-integration-tests.rs
    └── multi-file-test/
        ├── main.rs
        └── test_module.rs
```

- `Cargo.toml` 和 `Cargo.lock` 存放在包的根目录下（package root）。
- 源代码放在 `src` 目录中。
- 默认的库文件是 `src/lib.rs`。
- 默认的可执行文件是 `src/main.rs`。
	- 其他可执行文件可以放在 `src/bin/` 目录中。
- 基准文件放在 `benches` 目录下。
- 示例放在 `examples` 目录中。
- 集成测试放在 `tests` 目录中。

如果binary、example、bench或集成测试由多个源文件组成，请将 `main.rs` 文件与额外的模块一起放在 `src/bin`、`examples`、`benches` 或 `tests` 目录的子目录中。可执行文件的名称将是该目录的名称。

你可以在书中了解更多关于Rust的模块系统。

参见配置目标以了解手动配置目标的更多细节。关于控制Cargo如何自动推断目标名称的更多信息，请参见目标自动发现。

## 2.6 Cargo.toml vs Cargo.lock

Cargo.toml 和 Cargo.lock 有两种不同的用途。在我们谈论它们之前，这里有一个总结:

- Cargo.toml 是广义的描述你的依赖关系，由你来写。
- Cargo.lock 包含了关于你的依赖关系的确切信息。它是由 Cargo 维护的，不应该被手动编辑。

如果你正在构建一个非最终产品，比如一个其他 rust 包会依赖的 rust 库，把 Cargo.lock 放在你的 .gitignore 中。如果你正在构建一个终端产品，如可执行的命令行工具或应用程序，或一个系统库，其 crate-type 为 staticlib 或 dylib，请将 Cargo.lock 放入git中。如果你想知道为什么会这样，请看FAQ中的 "为什么二进制文件有Cargo.lock的版本控制，而库没有？"。

让我们再深入了解一下。

`Cargo.toml` 是一个清单文件，我们可以在其中指定关于我们包的一系列不同的元数据。例如，我们可以说我们依赖另一个包:

```toml
[package]
name = "hello_world"
version = "0.1.0"

[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand.git" }
```

这个包只有一个依赖关系，就是对rand库的依赖。在这种情况下，我们已经说明了我们依靠的是住在GitHub上的一个特定的Git仓库。由于我们没有指定任何其他信息，Cargo认为我们打算使用主分支上的最新提交来构建我们的包。

听起来不错吧？有一个问题：如果你今天构建了这个包，然后你把副本发给我，我明天再构建这个包，就会发生一些不好的事情。在这期间，可能会有更多的提交给rand，而我的构建会包括新的提交，而你的则不会。因此，我们会得到不同的版本。这就不好了，因为我们需要可重复的构建。

我们可以在Cargo.toml中加入rev行来解决这个问题:

```toml
[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand.git", rev = "9f35b8e" }
```

现在我们的构建将是一样的。但是有一个很大的缺点：现在我们每次要更新我们的库的时候，都要手动考虑SHA-1的问题。这既乏味又容易出错。

进入Cargo.lock。因为它的存在，我们不需要手动跟踪确切的修订。Cargo会帮我们做到这一点。当我们有一个像这样的清单时:

```toml
[package]
name = "hello_world"
version = "0.1.0"

[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand.git" }
```

当我们第一次构建时，Cargo会将最新的提交信息写入我们的Cargo.lock中。该文件看起来像这样:

```toml
[[package]]
name = "hello_world"
version = "0.1.0"
dependencies = [
 "rand 0.1.0 (git+https://github.com/rust-lang-nursery/rand.git#9f35b8e439eeedd60b9414c58f389bdc6a3284f9)",
]

[[package]]
name = "rand"
version = "0.1.0"
source = "git+https://github.com/rust-lang-nursery/rand.git#9f35b8e439eeedd60b9414c58f389bdc6a3284f9"
```

你可以看到这里有更多的信息，包括我们用来构建的确切版本。现在当你把你的包给别人时，他们会使用完全相同的SHA，尽管我们没有在Cargo.toml中指定它。

当我们准备选择使用新版本的库时，Cargo可以重新计算依赖关系并为我们更新:

```bash
$ cargo update # 更新所有的依赖项
$ cargo update -p rand # 只更新 "rand"。
```

这将写出一个新的 `Cargo.lock`，其中包含新的版本信息。请注意，`cargo update` 的参数实际上是一个软件包ID规范，而 `rand` 只是一个简短的规范。

## 2.7 测试

Cargo 可以通过 `cargo test` 命令来运行测试。Cargo会在两个地方寻找要运行的测试：每个 `src` 文件中的测试和 `tests/` 中的任何测试。`src` 文件中的测试应该是单元测试，而 `tests/` 中的测试应该是集成测试。因此，你需要将你的 crate 导入到测试的文件中。

下面是一个在我们的软件包中运行cargo test的例子，它目前没有测试:

```bash
$ cargo test
   Compiling rand v0.1.0 (https://github.com/rust-lang-nursery/rand.git#9f35b8e)
   Compiling hello_world v0.1.0 (file:///path/to/package/hello_world)
     Running target/test/hello_world-9c2b65bbb79eabce

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```


如果我们的包有测试，我们会看到更多的输出，有正确的测试数量。

你也可以通过传递一个过滤器来运行一个特定的测试:

```bash
$ cargo test foo
```

这将运行任何名称中含有 foo 的测试。

`cargo test` 还可以运行额外的检查。它将编译你所包含的任何例子，也将测试你文档中的例子。请参阅Rust文档中的测试指南以了解更多细节。

## 2.9 Cargo Home

"Cargo home" 的功能是下载和源码缓存。当构建一个 crate 时，Cargo会将下载的构建依赖项存储在 Cargo home 中。你可以通过设置 CARGO_HOME 环境变量来改变 Cargo 主页的位置。如果你在你的 Rust crate 中需要这个信息，home crate 提供了一个API来获取这个位置。默认情况下，Cargo home 位于 `$HOME/.cargo/`。

请注意，Cargo home的内部结构并不稳定，可能随时会有变化。

Cargo home 由以下部分组成:

### 文件:

- `config.toml` create 的全局配置文件，见参考文献中的config条目。

- `credentials.toml` 来自cargo login的私人登录凭证，以便登录到注册表。

- `.crates.toml` 这个隐藏文件包含了通过cargo install安装的crates的软件包信息。请不要用手去编辑!

> 备注: 新版本下目录不是这个样子的......

### 目录：

- `bin` 目录包含了通过 `cargo install` 或 `rustup` 安装的 crate 的可执行文件。为了能够访问这些二进制文件，请将该目录的路径添加到你的 `$PATH` 环境变量中。

- `git` Git的源代码存放在这里:

    - `git/db` 当 crate 依赖 git 仓库时，Cargo 会将该仓库作为裸仓库克隆到这个目录，并在必要时进行更新。

    - `git/checkouts` 如果使用的是 git source，所需的 repo 提交会从 git/db 中的裸repo中签出到这个目录。这为编译器提供了包含在该依赖提交的 repo 中的实际文件。同一个 repo 的不同提交可以进行多次签出。

- `registry` crate注册表（如crates.io）的包和元数据都在这里。

    - `registry/index` 索引是一个裸露的 git 仓库，包含了注册中心所有可用板条的元数据（版本、依赖关系等）。

    - `registry/cache` 下载的依赖关系被存储在缓存中。crates是压缩的gzip文件，以.crate为扩展名。

    - `registry/src` 如果下载的.crate归档文件是软件包所需要的，它将被解压到registry/src文件夹中，rustc将在那里找到.rs文件。

### 缓存CI中的Cargo home

为了避免在持续集成过程中重新下载所有的 crate 依赖项，你可以缓存 `$CARGO_HOME` 目录。然而，缓存整个目录往往是低效的，因为它将包含两次下载的源代码。如果我们依赖像 `serde 1.0.92` 这样的 crate 并缓存整个 `$CARGO_HOME`，我们实际上会缓存两次源代码，在 `registry/cache` 中的 `serde-1.0.92.crate` 和 `registry/src` 中的 serde 的提取.rs文件。这可能会不必要地减慢构建速度，因为下载、提取、重新压缩和重新上传缓存到CI服务器可能需要一些时间。

在整个构建过程中，只缓存以下目录就足够了:

- `bin/`
- `registry/index/`
- `registry/cache/`
- `git/db/`

### 清除缓存

理论上说，你可以随时删除缓存的任何部分，如果一个crate需要源代码，Cargo会尽力恢复这些源代码，方法是重新解压归档或检查裸露的repo，或者直接从网上重新下载源代码。

另外，`cargo-cache` crate提供了一个简单的CLI工具，可以只清除缓存中选定的部分，或者在命令行中显示其组件的大小。


## 2.10 构建缓存

Cargo 将构建的输出存储在 "target" 目录下。默认情况下，这是位于工作区根部的名为`target` 的目录。要改变这个位置，你可以设置 `CARGO_TARGET_DIR` 环境变量、`build.target-dir` 配置值，或者 `--target-dir` 命令行标志。

目录布局取决于你是否使用 `--target` 标志为特定的平台进行构建。如果没有指定 `--target`，Cargo 会在为主机架构构建的模式下运行。输出会进入目标目录的根部，并根据是否是发布版构建而分开。

| 目录              | 描述                                          |
| ----------------- | --------------------------------------------- |
| `target/debug/`   | 包含调试构建输出。                            |
| `target/release/` | 包含发行版的构建输出（有 `--release` 标志）。 |

当用 `--target` 为另一个目标构建时，输出会被放在一个带有目标名称的目录中：

| 目录                       | 范例                                    |
| -------------------------- | --------------------------------------- |
| `target/<triple>/debug/`   | `target/thumbv7em-none-eabihf/debug/`   |
| `target/<triple>/release/` | `target/thumbv7em-none-eabihf/release/` |

> 注意: 如果不使用 `--target`，这将导致 Cargo 与构建脚本和 proc 宏共享你的依赖项。RUSTFLAGS 将与每个 rustc 调用共享。如果使用 `--target` 标志，构建脚本和进程宏会单独构建（针对主机架构），并且不共享 RUSTFLAGS。

在配置文件目录（`debug`或`release`）中，工件被放置在以下目录中。

| 目录                     | 描述                                                         |
| ------------------------ | ------------------------------------------------------------ |
| `target/debug/`          | 包含正在构建的软件包的输出（`[[bin]]可执行文件和`[lib]'库目标）。 |
| `target/debug/examples/` | 包含实例 (`[[example]]` targets).                            |

Some commands place their output in dedicated directories in the top level of the `target` directory: 有些命令将它们的输出放在 "target" 目录顶层的专用目录中:

| 目录              | 描述                                                         |
| ----------------- | ------------------------------------------------------------ |
| `target/doc/`     | 包含rustdoc文档 ([`cargo doc`](https://doc.rust-lang.org/cargo/commands/cargo-doc.html)). |
| `target/package/` | 包含[`cargo package`](https://doc.rust-lang.org/cargo/commands/cargo-package.html)和[`cargo publish`](https://doc.rust-lang.org/cargo/commands/cargo-publish.html) 命令的输出。 |

Cargo还创建了其他一些构建过程中需要的目录和文件。它们的布局被认为是Cargo内部的，并且会被改变。这些目录中的一些是。

| Directory                   | Description                                                  |
| --------------------------- | ------------------------------------------------------------ |
| `target/debug/deps/`        | Dependencies and other artifacts.                            |
| `target/debug/incremental/` | `rustc` [incremental output](https://doc.rust-lang.org/cargo/reference/profiles.html#incremental), a cache used to speed up subsequent builds. |
| `target/debug/build/`       | Output from [build scripts](https://doc.rust-lang.org/cargo/reference/build-scripts.html). |

### Dep-info文件

在每个编译的工件旁边都有一个后缀为 `.d` 的文件，叫做 "dep info" 文件。这个文件是一个类似于 Makefile 的语法，表明重建工件所需的所有文件依赖关系。这些文件旨在与外部构建系统一起使用，以便它们能够检测到 Cargo 是否需要被重新执行。文件中的路径默认是绝对的。参见 build.dep-info-basedir 配置选项来使用相对路径。

### 共享的缓存

第三方工具 `sccache` 可以用来在不同的工作空间中共享构建的依赖关系。

要设置 `sccache`，请用 `cargo install sccache` 安装它，并在调用Cargo前将 `RUSTC_WRAPPER` 环境变量设为 `ccache`。如果你使用bash，在 `.bashrc` 中添加 `export RUSTC_WRAPPER=sccache` 是很有意义的。另外，你也可以在Cargo配置中设置 `build.rustc-wrapper`。更多细节请参考sccache文档。

