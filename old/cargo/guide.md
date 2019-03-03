# 使用指南

Cargo是一个Rust工具，可以在项目中声明各种依赖，并确保可以重复构建。

注： 类比Java中的maven或者gradle？

为此，cargo做了四个事情：

- 引入两个metadata文件，带有各种项目信息
- 获取并构建项目的依赖
- 用正确的参数调用`rustc`或者其他构建工具来构建项目
- 引入约定，简化Rust项目的工作

## 项目布局

cargo使用约定的文件位置来简化项目管理。

```bash
├── Cargo.lock
├── Cargo.toml
├── benches
│   └── large-input.rs
├── examples
│   └── simple.rs
├── src
│   ├── bin
│   │   └── another_executable.rs
│   ├── lib.rs
│   └── main.rs
└── tests
    └── some-integration-tests.rs
```

- `Cargo.toml`和`Cargo.lock`文件存储在项目(或者package)的根目录下
- 源代码在`src`文件夹
- 默认类库文件是`src/lib.rs`
- 默认可执行文件是`src/main.rs`
- 其他可执行文件存放为`src/bin/*.rs`
- 集成测试在`tests`文件夹(单元测试和他们测试的文件在一起)
- 示例在`examples`文件夹
- Benchmarks在`benches`文件夹.

更多信息，请见 [manifest description](http://doc.crates.io/manifest.html#the-project-layout)

## cargo.lock

`cargo.lock`文件包含项目使用的所有依赖的确切信息。

`cargo.lock`和`cargo.toml`用途不同：

- `cargo.toml`： 描述项目的依赖，由开发人员编写
- `cargo.lock`： 包含项目依赖的确切信息。由cargo维护，不应该手工编辑

在版本仓库中保存的策略也不同：

- 如果是类库，给其他项目使用，则将`cargo.lock`加入`.gitignore`，不要提交到仓库
- 如果是可执行文件，如命令行工具或者应用，应该将`cargo.lock`提交到仓库中

### git依赖的版本维护策略

当依赖描述为git仓库时，默认是"master"分支的最新提交：

```bash
[package]
name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
rand = { git = "https://github.com/rust-lang-nursery/rand.git" }
```

cargo将会在cargo.lock中展开为

```bash
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

展开就会固定为这个当前时刻的这个具体commit。可以通过`cargo update`命令进行更新。

```bash
$ cargo update           # 更新所有依赖
$ cargo update -p rand   # 仅仅更新“rand”依赖
```

`cargo update`命令会更新cargo.lock文件。

> 备注： 这就是为什么当项目是类库时，需要将cargo.lock文件提交到仓库。因为其他项目导入这个类库时，会根据cargo.lock文件的内容来获取对应的代码版本。

这里的`-p`参数是package id，"rand"是package id的简短写法，查看[package id规范](package-id-spec.md)的详情。

## 测试

使用`cargo test`命令运行测试。

cargo在两个地方查找测试来运行：

- `src`目录：单元测试
- `tests`目录：集成测试

可以在`cargo test`命令中增加一个filter，通过测试的名字来过滤出要执行的测试：

```bash
$ cargo test foo
```

## 构建缓存

Cargo在单个工作空间的所有包之间共享构建工件。目前，Cargo不会在不同的工作空间之间共享构建结果，但通过第三方工具可以实现类似的结果，[sccache](https://github.com/mozilla/sccache).

```bash
$ cargo install sccache
```

然后增加一个环境变量`RUSTC_WRAPPER=sccache`。例如修改.bashrc文件加入一下内容：

```bash
#cargo
export RUSTC_WRAPPER=sccache
```
