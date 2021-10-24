---
title: "Cargo Reference笔记: 清单"
linkTitle: "Reference 3.2清单"
weight: 327
date: 2021-10-22
description: >
  Rust Cargo Reference笔记：3.2节清单
---

https://doc.rust-lang.org/cargo/reference/manifest.html

## 3.2 清单格式

每个软件包的Cargo.toml文件被称为其清单。它是以TOML格式编写的。每个清单文件由以下部分组成。

### [package] 部分

`Cargo.toml` 的第一个部分是 `[package]`.

```toml
[package]
name = "hello_world" # the name of the package
version = "0.1.0"    # the current version, obeying semver
authors = ["Alice <a@example.com>", "Bob <b@example.com>"]
```

Cargo要求的唯一字段是 name 和 version。如果发布到注册表，注册表可能需要额外的字段。关于发布到crates.io的要求，见下面的注释和发布章节。

#### name字段

包的 name 是一个用来指代包的标识符。它在被列为另一个包的依赖关系时使用，并作为推断的lib和bin目标的默认名称。

name 必须只使用字母数字字符或 `-` 或 `_`，而且不能为空。请注意，`cargo new` 和 `cargo init` 对包名施加了一些额外的限制，比如强制要求它是一个有效的Rust标识符，而不是一个关键字。crates.io 甚至施加了更多的限制，比如强制要求只能使用ASCII字符，不能使用保留名，不能使用 "nul" 这样的特殊Windows名称，不能太长，等等。

#### version字段

Cargo采用了语义版本控制（Semantic Versioning）的概念，因此请确保遵循一些基本规则。

- 在你达到1.0.0之前，什么都可以做，但如果你做了破坏性的修改，就要递增次要版本。在Rust中，破坏性改动包括向结构体添加字段或向枚举添加变体。
- 在1.0.0之后，只有在增加主版本的时候才可以进行破坏性修改。不要破坏构建。
- 1.0.0之后，不要在补丁级版本中添加任何新的公共API（没有新的pub东西）。如果你添加任何新的pub结构、特征、字段、类型、函数、方法或其他东西，一定要增加次要版本。
- 使用有三个数字部分的版本号，如1.0.0而不是1.0。

#### authors字段

可选的 authors 字段列出了被认为是包的 "作者" 的人或组织。确切的含义是可以解释的--它可以列出包的原始或主要作者、当前的维护者或所有者。一个可选的电子邮件地址可以包含在每个作者条目末尾的斜方括号内。

这个字段只在软件包元数据和 build.rs 中的 `CARGO_PKG_AUTHORS` 环境变量中出现。它不显示在crates.io的用户界面上。

#### edition字段

`edition` 是一个可选的键，它影响你的包是用哪个Rust版本编译的。在 `[package]` 中设置 edition key 会影响到包中的所有 target/crates，包括测试套件、基准、二进制文件、例子等等。

```toml
[package]
# ...
edition = '2021'
```

大多数清单的版本字段都由 cargo new 自动填入最新的稳定版本。默认情况下，cargo new 创建的清单目前使用的是 2021 版。

如果 `Cargo.toml` 中没有 edition 字段，那么为了向后兼容，会假定为2015版。请注意，用 `cargo new` 创建的所有清单都不会使用这种历史回退，因为它们会明确指定版本为较新的值。

#### rust-version字段

rust-version字段是一个可选的键，它告诉cargo你的包可以用哪个版本的Rust语言和编译器进行编译。如果当前选择的Rust编译器的版本比声明的版本早，cargo会退出，并告诉用户需要什么版本。

第一个支持这个字段的Cargo版本是随着Rust 1.56.0发布的。在旧版本中，这个字段将被忽略，Cargo会显示警告

```toml
[package]
# ...
rust-version = "1.56"
```

Rust版本必须是由两到三个部分组成的裸版本号；它不能包括 semver 操作符或预发布标识符。编译器的预发布标识符，如 `-nightly`，在检查Rust版本时将被忽略。`rust-version` 必须等于或高于首次引入配置版本的版本。

`rust-version` 可以使用 `--ignore-rust-version` 选项来忽略。

在 `[package]` 中设置 `rust-version` 键将影响到包中的所有 target/crate，包括测试套件、基准、二进制文件、示例等。

#### description字段

description 是关于软件包的简短介绍。`crates.io` 会在你的软件包中显示这个描述。这应该是纯文本（不是Markdown）。

```toml
[package]
# ...
description = "A short description of my package"
```

#### documentation字段

documentation 字段指定了存放 crate 文档的网站的一个 URL。如果清单文件中没有指定 URL，crates.io 将自动将您的 crate 链接到相应的 docs.rs 页面。

```toml
[package]
# ...
documentation = "https://docs.rs/bitflags"
```

#### readme字段

readme字段应该是包根部的一个文件的路径（相对于这个`Cargo.toml`），其中包含关于包的一般信息。crates.io 会将其解释为 Markdown 并在crate的页面上呈现。

```toml
[package]
# ...
readme = "README.md"
```

如果没有指定这个字段的值，并且在软件包根中存在一个名为 README.md、README.txt 或 README 的文件，那么将使用该文件的名称。你可以通过把这个字段设置为false来抑制这种行为。如果该字段被设置为 "true"，将假定默认值为README.md。

#### homepage字段

homepage字段应该是一个网站的URL，这个网站是你的包的主页:

```toml
[package]
# ...
homepage = "https://serde.rs/"
```

#### repository字段

repository字段应该是软件包的源存储库的URL:

```toml
[package]
# ...
repository = "https://github.com/rust-lang/cargo/"
```

#### license和license-file字段

license字段包含软件包发布时使用的软件许可名称。license-file字段包含了一个包含许可证文本的文件的路径（相对于这个Cargo.toml）。

crates.io 将许可证字段解释为 `SPDX 2.1` 许可证表达式。该名称必须是 `SPDX许可证列表3.11` 中的一个已知许可证。目前不支持括号。更多信息请参见SPDX网站。

SPDX许可证表达式支持AND和OR运算符来组合多个许可证。

```toml
[package]
# ...
license = "MIT OR Apache-2.0"
```

使用 OR 表示用户可以选择任何一个许可证。使用 AND 表示用户必须同时遵守两个许可证。使用 WITH 运算符表示一个有特殊例外的许可证。一些例子:

- MIT OR Apache-2.0
- LGPL-2.1-only AND MIT AND BSD-2-Clause
- GPL-2.0-or-later WITH Bison-exception-2.2

如果一个软件包使用的是非标准的许可证，那么可以指定 license-file 字段来代替 license 字段。

```toml
[package]
# ...
license-file = "LICENSE.txt"
```

{{% alert title="注意" color="primary" %}}
crates.io 需要设置 license 或 license-file。
{{% /alert %}}

#### keywords字段

keywords 字段是一个描述此包的字符串数组。当在注册表上搜索该包时，这可以提供帮助，你可以选择任何可以帮助别人找到这个crate的词语。

```toml
[package]
# ...
keywords = ["gamedev", "graphics"]
```

{{% alert title="注意" color="primary" %}}
crates.io 最多有5个关键词。每个关键词必须是ASCII文本，以字母开头，并且只包含字母、数字、`_`或`-`，并且最多拥有20个字符。
{{% /alert %}}

#### categories字段

categories字段是一个字符串数组，表示该包属于的类别:

```toml
categories = ["command-line-utilities", "development-tools::cargo-plugins"]
```

{{% alert title="注意" color="primary" %}}
crates.io 最多有5个类别。每个类别都应该与 https://crates.io/category_slugs 中的一个匹配，并且必须完全匹配。
{{% /alert %}}

#### workspace字段

workspace字段可以用来配置这个包的工作空间。如果没有指定，这将被推断为文件系统中第一个带有 `[workspace]` 的 `Cargo.toml` 向上。如果成员不在工作区根目录下，设置这个字段很有用。

```toml
[package]
# ...
workspace = "path/to/workspace/root"
```

如果清单中已经定义了 `[workspace]` 表，则不能指定此字段。也就是说，一个 crate 不能既是一个 workspace 的根板块（包含 `[workspace]`），又是另一个 workspace 的成员 crate（包含 `package.workspace`）。

欲了解更多信息，请参见工作空间一章。

#### build字段

build字段在包根中指定了一个文件，该文件是用于构建本地代码的构建脚本。更多信息可以在构建脚本指南中找到。

```toml
[package]
# ...
build = "build.rs"
```

默认是 "build.rs"，它从软件包根目录下一个名为 `build.rs` 的文件中加载该脚本。使用 `build = "custom_build_name.rs"` 来指定一个不同文件的路径，或者 `build = false` 来禁止自动检测构建脚本。

#### links字段

links字段指定了被链接的本地库的名称。更多信息可以在构建脚本指南的链接部分找到。

```toml
[package]
# ...
links = "foo"
```

#### exclude和include字段

exclude 和 include 字段可以用来明确指定在打包发布项目时包括哪些文件，以及某些类型的变更跟踪（如下所述）。在 exclude 字段中指定的模式确定了一组不包括的文件，而 include 中的模式则指定了明确包括的文件。你可以运行 `cargo package --list` 来验证哪些文件将被包含在软件包中。

```toml
[package]
# ...
exclude = ["/ci", "images/", ".*"]
```

```toml
[package]
# ...
include = ["/src", "COPYRIGHT", "/examples", "!/examples/big_example"]
```

如果这两个字段都没有被指定，默认情况是包括软件包根部的所有文件，除了下面列出的排除项。

如果没有指定 `include`，那么下面的文件将被排除。

- 如果软件包不在git仓库中，所有以点开始的 "隐藏 "文件将被跳过。
- 如果软件包在git仓库中，任何被仓库和全局git配置的gitignore规则所忽略的文件都将被跳过。

不管是指定exclude还是include，以下文件总是被排除在外:

- 任何子包将被跳过（任何包含Cargo.toml文件的子目录）。
- 在包的根目录下名为target的目录将被跳过。

以下文件总是被包括在内:

- 包本身的Cargo.toml文件总是被包含，它不需要被列在include中。
- 如果软件包包含二进制或示例目标，则会自动包含一个最小化的Cargo.lock，更多信息请参见cargo package。
- 如果指定了 license-file，它总是被包括在内。

这些选项是相互排斥的；设置 include 会覆盖 exclude。如果你需要对一组 include 文件进行排除，请使用下面描述的 `！` 操作符。

这些模式应该是 gitignore 风格的模式。简而言之:

TODO: 这里内容太细了，跳过

#### publish字段

publish字段可以用来防止一个包被错误地发布到包注册中心（如crates.io），例如，在一个公司中保持一个包的私有性:

```toml
[package]
# ...
publish = false
```

该值也可以是一个字符串数组，这些字符串是允许被发布到的注册表名称:

```toml
[package]
# ...
publish = ["some-registry-name"]
```

如果publish数组包含单个注册表，当没有指定 `--registry` 标志时，crate 发布命令将使用它。

#### 元数据表

默认情况下，Cargo 会对 Cargo.toml 中未使用的键进行警告，以帮助检测错别字之类的。而 `package.metadata` 表则完全被Cargo忽略，不会被警告。这一部分可以用于那些想在`Cargo.toml` 中存储软件包配置的工具。比如说:

```toml
[package]
name = "..."
# ...

# Metadata used when generating an Android APK, for example.
[package.metadata.android]
package-name = "my-awesome-android-app"
assets = "path/to/static"
```

在工作区层面也有一个类似的表，名为 `workspace.metadata`。虽然 crate 没有为这两个表的内容指定格式，但建议外部工具可能希望以一致的方式使用它们，例如，如果 `package.metadata` 中缺少数据，就引用 `workspace.metadata` 中的数据，如果这对有关工具来说是合理的。

#### default-run字段

清单 `[package]` 部分中的 `default-run` 字段可用于指定 crate 运行所选的默认二进制文件。例如，当同时存在 `src/bin/a.rs` 和 `src/bin/b.rs 时`:

```toml
[package]
default-run = "a"
```

## 3.2.1 Cargo Target

Cargo包由 target 组成，这些 target 对应于可以被编译成 crate 的源文件。包可以有库、二进制、example、测试和 benchmark target。target 列表可以在 Cargo.toml 清单中配置，通常由源文件的目录布局自动推断出来。

有关配置目标设置的详情，请参见下面的配置目标。

### Library/库

库目标定义了 "library/库"，可以被其他库和可执行文件使用和链接。文件名默认为 `src/lib.rs` ，库的名称默认为软件包的名称。包只能有一个库。库的设置可以在 Cargo.toml 的 `[lib]` 表中自定义。

```toml
# Example of customizing the library in Cargo.toml.
[lib]
crate-type = ["cdylib"]
bench = false
```

### Binaries/二进制文件

二进制目标是经过编译后可以运行的可执行程序。默认的二进制文件名是 `src/main.rs`，它默认为软件包的名称。其他二进制文件存储在 `src/bin/` 目录中。每个二进制文件的设置可以在 Cargo.toml 中的 `[[bin]]` 表中进行自定义。

二进制文件可以使用包的库的公共API。它们也会与 Cargo.toml 中定义的 `[dependencies]` 链接。

你可以用带有 `--bin <bin-name>` 选项的 `cargo run` 命令来运行单个二进制文件。`cargo install` 可以用来将可执行文件复制到一个公共位置。

```toml
# Example of customizing binaries in Cargo.toml.
[[bin]]
name = "cool-tool"
test = false
bench = false

[[bin]]
name = "frobnicator"
required-features = ["frobnicate"]
```

### 示例

位于 `examples` 目录下的文件是该库所提供的功能的使用示例。当编译时，它们被放置在 `target/debug/examples` 目录下。

示例可以使用包的库的公共API。它们也与 Cargo.toml 中定义的 `[dependencies]` 和 `[dev-dependencies]` 连接。

默认情况下，示例是可执行的二进制文件（有一个 `main()` 函数）。你可以指定 `crate-type` 字段来使示例被编译为库。

```toml
[[example]]
name = "foo"
crate-type = ["staticlib"]
```

可以使用 `cargo run` 命令，并使用 `--example <example-name>` 选项来运行单个可执行的示例。库中的示例可以用带 `--example <example-name>` 选项的 `cargo build` 来构建。带 `--example <example-name>` 选项的 `cargo install` 可以用来将可执行的二进制文件复制到一个共同的位置。默认情况下，示例是由 `cargo test` 编译的，以保护它们不被咬坏。如果你的例子中有 `#[test]` 函数，而你想用 `cargo test` 来运行的话，请把 `test` 字段设置为true。

### 测试

在Cargo项目中，有两种形式的测试:

- 单元测试是位于库或二进制文件（或任何有 `test` 字段的 target）中标有 `#[test]` 属性的函数。这些测试可以访问位于它们所定义的目标中的私有API。
- 集成测试是一个单独的可执行二进制文件，也包含 `#[test]` 函数，它与项目的库相连，可以访问其公共API。

测试是通过 `cargo test` 命令运行的。默认情况下，Cargo 和 rustc 使用 libtest harness，它负责收集带有 `#[test]` 属性注释的函数并并行执行，报告每个测试的成功和失败。

#### 集成测试

位于 `tests` 目录下的文件是集成测试。当你运行 `cargo test` 时，Cargo会把这些文件中的每一个都编译成一个单独的crate，并执行它们。

集成测试可以使用包的库的公共API。它们也会与 `Cargo.toml` 中定义的 `[dependencies]` 和 `[dev-dependencies]` 相连接。

如果你想在多个集成测试中共享代码，你可以把它放在一个单独的模块中，比如 `test/common/mod.rs`，然后把 `mod common;` 放在每个测试中来导入它。

每个集成测试会生成一个单独的可执行二进制文件，crate 测试将连续运行它们。在某些情况下，这可能是低效的，因为它可能需要更长的时间来编译，而且在运行测试时可能无法充分利用多个CPU。如果你有很多集成测试，你可能要考虑创建一个单一的集成测试，并将测试分成多个模块。libtest 线束会自动找到所有 `#[test]` 注释的函数，并并行运行它们。你可以向 crate 测试传递模块名称，以便只运行该模块内的测试。

如果有集成测试，二进制目标会自动构建。这允许集成测试执行二进制文件以锻炼和测试其行为。`CARGO_BIN_EXE_<name>` 环境变量在集成测试建立时被设置，以便它可以使用 env 宏来定位可执行文件。

### 基准

基准提供了一种使用 `cargo bench` 命令来测试代码性能的方法。它们遵循与测试相同的结构，每个基准函数都用 `#[bench]` 属性来注释。与测试类似:

- 基准被放置在 `benches` 目录下。
- 在库和二进制文件中定义的基准函数可以访问它们所定义的目标中的私有API。benches 目录中的基准可以使用公共API。
- bench 字段可以用来定义哪些目标是默认的基准。
- harness 字段可以用来禁用内置的harness。

{{% alert title="注意" color="primary" %}}
目前 `#[bench]` 属性还不稳定，只在 nightly 频道中可用。`crates.io` 上有一些软件包，可能有助于在稳定频道上运行基准，比如Criterion。
{{% /alert %}}

### 配置目标

Cargo.toml中所有的 `[lib]`、`[[bin]]`、`[[example]]`、`[[test]]` 和 `[[bench]]` 部分都支持类似的配置，以指定目标应该如何构建。像 `[[bin]]` 这样的双括号部分是TOML的数组表，这意味着你可以写一个以上的 `[[bin]]` 部分来在你的 `crate` 中制作多个可执行文件。你只能指定一个库，所以 `[lib]` 是一个普通的TOML表。

下面是每个目标的TOML设置的概述，每个字段在下面有详细描述:

```toml
[lib]
name = "foo"           # The name of the target.
path = "src/lib.rs"    # The source file of the target.
test = true            # Is tested by default.
doctest = true         # Documentation examples are tested by default.
bench = true           # Is benchmarked by default.
doc = true             # Is documented by default.
plugin = false         # Used as a compiler plugin (deprecated).
proc-macro = false     # Set to `true` for a proc-macro library.
harness = true         # Use libtest harness.
edition = "2015"       # The edition of the target.
crate-type = ["lib"]   # The crate types to generate.
required-features = [] # Features required to build this target (N/A for lib).
```

#### name字段

name 字段指定了目标的名称，它对应于将被生成的工件的文件名。对于一个库来说，这是依赖项用来引用它的板条箱名称。

对于 `[lib]` 和默认的二进制文件 (`src/main.rs`)，这默认为包的名称，任何破折号都用下划线代替。对于其他自动发现的目标，它默认为目录或文件名。

除了 `[lib]之外`，所有目标都需要这样做。

#### path字段

路径字段指定了 crate 的源文件的位置，相对于 Cargo.toml 文件。

如果没有指定，将使用基于目标名称的推断路径。

#### test字段

test字段表示目标是否默认由 crate 测试来测试。对于lib、bins和测试，默认为true。

#### doctest字段

doctest字段表示文档实例是否默认由cargo test来测试。这只与库有关，对其他部分没有影响。对于库来说，默认为真。

#### bench字段

bench字段表示目标是否默认由 cargo bench 进行基准测试。对于lib、bins和benchmark，默认为true。

#### doc字段

doc字段表示目标程序是否默认包含在由 cargo doc 生成的文档中。默认情况下，库和二进制文件为真。

#### plugin字段

这个字段用于rustc插件，这些插件正在被废弃。

#### proc-macro字段

proc-macro 字段表示该库是一个过程性的宏（引用）。这只对 [lib] 目标有效。

#### harness字段

harness 字段表示 `--test` 标志将被传递给 rustc，它将自动包含 libtest 库，它是收集和运行标有 `#[test]` 属性的测试或标有 `#[bench]` 属性的基准的驱动。默认情况下，所有目标都是true。

如果设置为false，那么你要负责定义一个main()函数来运行测试和基准。

无论 harness 是否被启用，测试都有 `cfg(test)` 条件表达式被启用。

#### edition字段

edition字段定义了目标将使用的Rust版本。如果没有指定，它默认为 `[package]` 的版本字段。这个字段通常不应该被设置，它只适用于高级场景，例如将一个大的包逐步过渡到一个新的版本。

#### Crate-type字段

crate-type 字段定义了将由目标生成的 crate 类型。它是一个字符串数组，允许你为一个目标指定多个 crate 类型。这只能被指定给库和例子。二进制文件、测试和基准总是 "bin" crate类型。默认值是:

| Target             | Crate Type     |
| ------------------ | -------------- |
| Normal library     | `"lib"`        |
| Proc-macro library | `"proc-macro"` |
| Example            | `"bin"`        |

可用的选项有 bin、lib、rlib、dylib、cdylib、staticlib 和 proc-macro。你可以在《Rust参考手册》中阅读更多关于不同crate类型的信息。

#### required-features字段

required-features字段指定了目标需要哪些特征才能被构建。如果任何所需的功能没有被启用，目标将被跳过。这只与 `[[bin]]`、`[[bench]]`、`[[test]]` 和 `[[example]]` 部分有关，对 `[lib]` 没有影响。

```toml
[features]
# ...
postgres = []
sqlite = []
tools = []

[[bin]]
name = "my-pg-tool"
required-features = ["postgres", "tools"]
```

### 目标自动发现

默认情况下，Cargo 会根据文件系统中的文件布局自动确定要构建的目标。目标配置表，如 `[lib]`、`[[bin]]`、`[[test]]`、`[[bench]]` 或 `[[example]]`，可以用来添加不遵循标准目录布局的额外目标。

自动发现目标的功能可以被禁用，这样就只有手动配置的目标会被建立。将 `[package]` 部分的key `autobins`、`autoexamples`、`autotests` 或 `autobenches` 设置为false将禁用相应目标类型的自动发现。

```toml
[package]
# ...
autobins = false
autoexamples = false
autotests = false
autobenches = false
```

只有在特殊情况下才需要禁用自动发现功能。例如，如果你有一个库，你想要一个名为 `bin` 的模块，这将会带来一个问题，因为Cargo通常会试图将bin目录下的任何东西编译为可执行文件。下面是这种情况下的一个布局样本:

```bash
├── Cargo.toml
└── src
    ├── lib.rs
    └── bin
        └── mod.rs
```

为了防止 Cargo 将 `src/bin/mod.rs` 推断为可执行文件，请在 `Cargo.toml` 中设置 `autobins = false` 来禁止自动发现。

```toml
[package]
# …
autobins = false
```

{{% alert title="注意" color="primary" %}}
对于2015版的软件包，如果在Cargo.toml中至少有一个目标是手动定义的，那么自动发现的默认值为false。从2018版开始，默认值始终为 "true"。
{{% /alert %}}

