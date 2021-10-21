---
title: "Rustup Book学习笔记"
linkTitle: "Rustup Book"
weight: 392
date: 2021-10-21
description: >
  Rustup Book学习笔记
---

https://rust-lang.github.io/rustup/index.html



## 1. 安装

遵循rust安装指导

https://www.rust-lang.org/tools/install

> rustup 将 rustc, cargo, rustup 和其他标准工具安装到 Cargo 的 bin 目录中。在Unix系统中，它位于 `$HOME/.cargo/bin`，在Windows系统中位于 `%USERPROFILE%\.cargo/bin`。这个目录也是 `cargo install` 安装Rust程序和Cargo插件的目录。

```bash
➜  bin pwd           
/home/sky/.cargo/bin
➜  bin ls
cargo         cargo-fmt   clippy-driver  rustc    rustfmt   rust-lldb
cargo-clippy  cargo-miri  rls            rustdoc  rust-gdb  rustup
```

### 选择安装路径

> rustup 允许在运行 rustup-init 可执行文件之前，通过设置环境变量 CARGO_HOME 和 RUSTUP_HOME 来定制安装。正如在环境变量部分提到的，RUSTUP_HOME 设置了 rustup 的根文件夹，用于存储已安装的工具链和配置选项。CARGO_HOME 包含 cargo 使用的缓存文件。
>
> 注意，需要确保这些环境变量始终被设置，并且在使用工具链时，`CARGO_HOME/bin` 在 $PATH 环境变量中。

### 安装 nightly

暂时没有这个需求，跳过

### 开启完成功能

为Bash、Fish、Zsh或PowerShell启用tab完成功能

```bash
# Zsh
$ mkdir ~/.zfunc/
$ rustup completions zsh > ~/.zfunc/_rustup
```

加了这个之后 tab 会有自动完成。

## 2. 概念

rustup是一个工具链复用器(*toolchain multiplexer*)。它安装和管理许多Rust工具链，并通过一套安装在 `~/.cargo/bin` 的工具来展示它们。安装在 `~/.cargo/bin` 中的 rustc 和 cargo 可执行文件是委托给真正的工具链的代理。

因此，当 rustup 第一次安装时，运行 rustc 会运行 $HOME/.cargo/bin/rustc 中的代理，而它又会运行稳定的编译器。如果你后来用 rustup default nightly 把默认的工具链改成了nightly，那么同样的代理将运行nightly编译器。

这与Ruby的rbenv、Python的yenv或Node的nvm类似。

### 术语

- channel - Rust被发布到三个不同的 "频道" ： stable, beta, 和 nightly。

- toolchain - "工具链" 是Rust编译器（rustc）和相关工具（如cargo）的完整安装。一个工具链的规范包括发布渠道或版本，以及工具链运行的主机平台。

- target - rustc能够为许多平台生成代码。"target" 指定了代码将被生成的平台。默认情况下，cargo 和 rustc 使用主机工具链的平台作为目标。要为不同的目标平台进行编译，通常需要先通过 `rustup target` 命令安装目标平台的标准库。

- component - 每个Rust版本都包括几个"组件"，其中一些是必须的（比如rustc），一些是可选的（比如clippy）。

- profile - 为了使组件的工作更容易，"profile"定义了组件的分组。

### 2.1 Channels

Rust被发布到三个不同的"频道"：stable, beta 和 nightly。稳定版每6周发布一次（偶尔会有点状发布）。测试版是将出现在下一个稳定版中的版本。nightly 发布是每晚进行的。rustup 协助安装不同的通道，保持它们的最新状态，并在它们之间轻松切换。

在安装了一个发布通道后，可以用 rustup 将安装的版本更新到该通道的最新版本。

rustup 也可以安装特定版本的Rust，比如 1.45.2 或 nightly-2020-07-27。

### 2.2 Toolchains

rustup的许多命令都涉及到工具链，工具链即Rust编译器的单一安装。最基本的是跟踪官方发布渠道：stable、beta和nightly；但rustup也可以从官方档案中安装工具链，用于替代的主机平台，以及从本地构建中安装。

#### 工具链规范

标准发布通道的工具链名称有以下形式:

```bash
<channel>[-<date>][-<host>]

<channel>       = stable|beta|nightly|<major.minor>|<major.minor.patch>
<date>          = YYYY-MM-DD
<host>          = <target-triple>
```

'channel' 是一个命名的发布通道，一个主要和次要的版本号如1.42，或一个完全指定的版本号如1.42.0。频道名称可以选择附加一个存档日期，如nightly-2014-12-18，在这种情况下，工具链会从该日期的存档中下载。

最后，host可以被指定为目标三元组 (target-triple) 。这对于在64位平台上安装32位编译器或在Windows上安装基于MSVC的工具链最为有用。比如说

```bash
$ rustup toolchain install stable-x86_64-pc-windows-msvc
```

为了方便起见，目标三元组中被省略的元素将被推断出来，所以上面的内容可以写成:

```bash
$ rustup toolchain install stable-msvc
```

### 2.3 Components

每个工具链都有几个"组件"，其中一些是必须的（比如rustc），一些是可选的（比如clippy）。`rustup component` 命令是用来管理已安装的组件的。例如，运行 `rustup component list` 可以看到可用和已安装的组件的列表。

在安装工具链时，可以用 `--component` 标志来添加组件。比如:

```bash
rustup toolchain install nightly --component rust-docs
```

组件可以通过 ·rustup component· 命令被添加到已经安装的工具链中：

```bash
rustup component add rust-docs
```

为了更容易选择安装哪些组件，rustup有 "profile" 的概念，它提供了不同组件的命名分组。

大多数组件都有一个 target-triple 后缀，比如 `rustc-x86_64-apple-darwin`，以表示该组件所适用的平台。

可用的组件集可能随不同的版本和工具链而变化。下面是对不同组件的概述:

- rustc - Rust编译器。
- cargo - Cargo是一个软件包管理器和构建工具。
- rustfmt - Rustfmt是一个用于自动格式化代码的工具。
- rust-std - 这是Rust的标准库。rustc支持的每个目标都有一个单独的rust-std组件，例如rust-std-x86_64-pc-windows-msvc。
- rust-docs - 这是一个Rust文档的本地副本。使用 rustup doc 命令可以在网络浏览器中打开文档。
- rls - RLS是一个语言服务器，提供对编辑器和IDE的支持。
- clippy - Clippy是一个lint工具，为常见的错误和风格选择提供额外的检查。
- miri - Miri是一个实验性的Rust解释器，它可以用来检查未定义行为。
- rust-src - 这是一个Rust标准库源代码的本地拷贝。它可以被一些工具使用，比如RLS，为标准库中的函数提供自动补全；Miri是一个Rust解释器；以及Cargo的实验性build-std功能，它允许你在本地重建标准库。
- rust-analysis - 关于标准库的元数据，由RLS等工具使用。
- rust-mingw - 这包含了一个链接器和平台库，用于在x86_64-pc-windows-gnu平台上构建。
- llvm-tools-preview - 这是一个实验性组件，包含LLVM工具的集合。
- rustc-dev - 这个组件包含作为库的编译器。大多数用户不需要这个；只有在开发链接到编译器的工具时才需要它，例如对Clippy进行修改。

### 2.4 Profiles

rustup 有一个 "配置文件" 的概念。它们是在安装新的Rust工具链时可以选择下载的组件组。目前可用的配置文件有`minimal`, `default` 和 `complete`:

- minimal: 最小的配置文件包括尽可能少的组件，以获得一个可工作的编译器（rustc、rust-std和cargo）。如果你不使用本地文档，建议在Windows系统上使用这个组件（大量的文件可能会对一些反病毒系统造成问题），并在CI中使用。

- default: 默认配置文件包括最小配置文件中的所有组件，并增加了 rust-docs、rustfmt 和 clippy。rustup默认使用这个配置文件，它是推荐用于一般用途的配置文件。

- complete: 完整的配置文件包括所有通过 rustup 可用的组件。千万不要使用这个，因为它包括了元数据中曾经包含的所有组件，因此几乎总是会失败。如果你正在寻找一种方法来安装devtools，如miri或IDE集成工具（rls），你应该使用默认的配置文件，并手动安装所需的额外组件，可以使用 `rustup component add` 或在安装工具链时使用-c。

要改变rustup的配置文件，你可以使用rustup set profile命令。例如，要选择最小的配置文件，你可以使用。

```bash
rustup set profile minimal
```

也可以在第一次安装rustup时选择配置文件，可以通过选择 "Customize installation" 选项进行交互式操作，也可以通过传递 `--profile=<name>` 标志进行编程。配置文件只影响新安装的工具链：像往常一样，以后可以用：`rustup component add` 来安装单个组件。

### 2.5 Proxies

rustup为常见的Rust工具提供了一些包装器。这些被称为代理，代表了由各种组件提供的命令。

代理列表目前在rustup中是静态的，如下所示。

- rustc是Rust编程语言的编译器，由项目本身提供，来自rustc组件。

- rustdoc是发布在rustc组件中的工具，帮助你为Rust项目生成文档。

- cargo是Rust包管理器，它下载Rust包的依赖项，编译你的包，制作可分发的包，并将它们上传到crates.io（Rust社区的包注册中心）。它来自cargo组件。

- rust-lldb 和 rust-gdb 分别是 lldb 和 gdb 调试器的简单包装器。这些包装器可以实现一些Rust值的漂亮打印，并通过其脚本接口为调试器添加一些便利的功能。

- rls是Rust IDE整合工具的一部分。它实现了语言服务器协议，允许IDE和编辑器，如Visual Studio Code、ViM或Emacs，访问你正在编辑的Rust代码的语义。它来自rls组件。

- cargo-clippy和clippy-driver与clippy linting工具有关，它为常见的错误和风格选择提供额外的检查，它来自clippy组件。

- cargo-miri是Rust的中级中间表示法（MIR）的实验性解释器，来自miri组件。

## 3. 基本使用

### 保持Rust的最新状态

Rust在三个不同的发布渠道上发布：stable、beta和nightly。rustup默认使用stable渠道，它代表Rust的最新版本。稳定版每六周发布一次新版本。

当新版本的Rust发布时，只需输入rustup update即可更新。

## 4. 覆盖

rustup 在执行已安装的命令（如rustc）时，会自动决定使用哪个工具链。有几种方法可以控制和覆盖哪个工具链被使用:

1. 在命令行中使用的工具链覆盖简写，如 `cargo +beta`。
2. `RUSTUP_TOOLCHAIN` 环境变量。
3. 目录覆盖，用 `rustup override` 命令设置。
4. rust-toolchain.toml 文件。
5. 默认的工具链。

工具链的选择是按照上面列出的顺序，使用第一个被指定的工具链。不过有一个例外：目录覆盖和rust-toolchain.toml文件也是按照它们与当前目录的接近程度来选择。也就是说，这两种覆盖方法是通过向文件系统根部的目录树上走来发现的，离当前目录较近的rust-toolchain.toml文件将比离当前目录较远的目录覆盖更受欢迎。

要验证哪个工具链是活动的，可以使用 `rustup show`.

这是 `rustup show` 在linux上执行的结果：

```
rustup show                              
Default host: x86_64-unknown-linux-gnu
rustup home:  /home/sky/.rustup

stable-x86_64-unknown-linux-gnu (default)
rustc 1.55.0 (c8dfcfe04 2021-09-06)
```

TODO: 有需要时再细看怎么覆盖吧。

## 5. 交叉编译

Rust支持大量的平台。对于其中的许多平台，Rust项目发布了标准库的二进制版本，而对于一些平台则发布了完整的编译器。

当你第一次安装工具链时，rustup只安装你的主机平台的标准库，也就是你目前运行的架构和操作系统。要编译到其他平台，你必须安装其他目标平台。这可以通过 `rustup target add` 命令完成。例如，要添加Android target。

```bash
$ rustup target add arm-linux-androideabi
info: downloading component 'rust-std' for 'arm-linux-androideabi'
info: installing component 'rust-std' for 'arm-linux-androideabi'
```


安装了 `arm-linux-androideabi` 目标后，你就可以通过 `--target` 标志用 Cargo 构建 Android，如 `cargo build --target=arm-linux-androideabi`。

注意，`rustup target add` 只安装指定目标的Rust标准库。通常，交叉编译还需要其他工具，特别是链接器。例如，要交叉编译到Android，必须安装Android NDK。在未来，rustup也会提供安装NDK组件的帮助。

要为一个不是默认工具链的工具链安装一个目标，可以使用 `rustup target add` 的 `--toolchain` 参数，像这样:

```bash
$ rustup target add --toolchain <toolchain> <target>...
```

要查看可用目标的列表，可以使用 `rustup target list`。要删除以前添加的目标，请使用 `rustup target remove`。

感受一下可用目标的数量：

```bash
$ rustup target list

aarch64-apple-darwin
aarch64-apple-ios
aarch64-fuchsia
aarch64-linux-android
aarch64-pc-windows-msvc
aarch64-unknown-linux-gnu
aarch64-unknown-linux-musl
aarch64-unknown-none
aarch64-unknown-none-softfloat
arm-linux-androideabi
arm-unknown-linux-gnueabi
arm-unknown-linux-gnueabihf
arm-unknown-linux-musleabi
arm-unknown-linux-musleabihf
armebv7r-none-eabi
armebv7r-none-eabihf
armv5te-unknown-linux-gnueabi
armv5te-unknown-linux-musleabi
armv7-linux-androideabi
armv7-unknown-linux-gnueabi
armv7-unknown-linux-gnueabihf
armv7-unknown-linux-musleabi
armv7-unknown-linux-musleabihf
armv7a-none-eabi
armv7r-none-eabi
armv7r-none-eabihf
asmjs-unknown-emscripten
i586-pc-windows-msvc
i586-unknown-linux-gnu
i586-unknown-linux-musl
i686-linux-android
i686-pc-windows-gnu
i686-pc-windows-msvc
i686-unknown-freebsd
i686-unknown-linux-gnu
i686-unknown-linux-musl
mips-unknown-linux-gnu
mips-unknown-linux-musl
mips64-unknown-linux-gnuabi64
mips64-unknown-linux-muslabi64
mips64el-unknown-linux-gnuabi64
mips64el-unknown-linux-muslabi64
mipsel-unknown-linux-gnu
mipsel-unknown-linux-musl
nvptx64-nvidia-cuda
powerpc-unknown-linux-gnu
powerpc64-unknown-linux-gnu
powerpc64le-unknown-linux-gnu
riscv32i-unknown-none-elf
riscv32imac-unknown-none-elf
riscv32imc-unknown-none-elf
riscv64gc-unknown-linux-gnu
riscv64gc-unknown-none-elf
riscv64imac-unknown-none-elf
s390x-unknown-linux-gnu
sparc64-unknown-linux-gnu
sparcv9-sun-solaris
thumbv6m-none-eabi
thumbv7em-none-eabi
thumbv7em-none-eabihf
thumbv7m-none-eabi
thumbv7neon-linux-androideabi
thumbv7neon-unknown-linux-gnueabihf
thumbv8m.base-none-eabi
thumbv8m.main-none-eabi
thumbv8m.main-none-eabihf
wasm32-unknown-emscripten
wasm32-unknown-unknown
wasm32-wasi
x86_64-apple-darwin
x86_64-apple-ios
x86_64-fortanix-unknown-sgx
x86_64-fuchsia
x86_64-linux-android
x86_64-pc-solaris
x86_64-pc-windows-gnu
x86_64-pc-windows-msvc
x86_64-sun-solaris
x86_64-unknown-freebsd
x86_64-unknown-illumos
x86_64-unknown-linux-gnu (installed)
x86_64-unknown-linux-gnux32
x86_64-unknown-linux-musl
x86_64-unknown-netbsd
x86_64-unknown-redox
```

## 6. 环境变量

> 备注：临时查吧

## 7. 配置

Rustup有一个TOML设置文件，位于 `${RUSTUP_HOME}/settings.toml` （默认为 `~/.rustup` 或 `%USERPROFILE%/.rustup`）。这个文件的模式不是rustup公共接口的一部分--应该使用rustup CLI来查询和设置设置。

在Unix操作系统上，一些设置会参考一个后备设置文件。这个回退文件位于 `/etc/rustup/settings.toml`，目前只能定义 `default_toolchain`。

## 8. 网络代理

企业网络通常没有直接的外部 HTTP 访问，而是强制使用代理。如果你在这样的网络中，你可以通过在环境中设置 rustup 的URL来要求它使用代理。在大多数情况下，设置 https_proxy 应该就足够了。不同的系统和shell之间的命令可能不同。

- 在一个使用bash或zsh等shell的类Unix系统上

    ```bash
    export https_proxy=socks5://proxy.example.com:1080
    ```

- 在Windows命令提示符（cmd）上

    ```bash
    set https_proxy=socks5://proxy.example.com:1080
    ```

- 在Windows PowerShell（或PowerShell Core）上

    ```bash
    $env:https_proxy="socks5://proxy.example.com:1080"
    ```

- 当使用HTTP代理时，将 `socks5://proxy.example.com:1080` 替换为 `http://proxy.example.com:8080`。



## 9. 案例

| Command                                                    | Description                                                  |
| ---------------------------------------------------------- | ------------------------------------------------------------ |
| `rustup default nightly`                                   | Set the [default toolchain](https://rust-lang.github.io/rustup/overrides.html#default-toolchain) to the latest nightly |
| `rustup set profile minimal`                               | Set the default [profile](https://rust-lang.github.io/rustup/concepts/profiles.html) |
| `rustup target list`                                       | List all available [targets](https://rust-lang.github.io/rustup/cross-compilation.html) for the active toolchain |
| `rustup target add arm-linux-androideabi`                  | Install the Android target                                   |
| `rustup target remove arm-linux-androideabi`               | Remove the Android target                                    |
| `rustup run nightly rustc foo.rs`                          | Run the nightly regardless of the active toolchain           |
| `rustc +nightly foo.rs`                                    | [Shorthand](https://rust-lang.github.io/rustup/overrides.html#toolchain-override-shorthand) way to run a nightly compiler |
| `rustup run nightly bash`                                  | Run a shell configured for the nightly compiler              |
| `rustup default stable-msvc`                               | On Windows, use the MSVC toolchain instead of GNU            |
| `rustup override set nightly-2015-04-01`                   | For the current directory, use a nightly from a specific date |
| `rustup toolchain link my-toolchain "C:\RustInstallation"` | Install a custom toolchain by symlinking an existing installation |
| `rustup show`                                              | Show which toolchain will be used in the current directory   |
| `rustup toolchain uninstall nightly`                       | Uninstall a given toolchain                                  |
| `rustup toolchain help`                                    | Show the `help` page for a subcommand (like `toolchain`)     |
| `rustup man cargo`                                         | (*Unix only*) View the man page for a given command (like `cargo`) |



