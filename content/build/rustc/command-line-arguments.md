---
date: 2019-03-05T07:00:00+08:00
title: Rustc的命令行参数
menu:
  main:
    parent: "build-rustc"
weight: 261
description : "Rustc的命令行参数"
---

> 英文原文地址： https://doc.rust-lang.org/rustc/command-line-arguments.html

这是 `rustc` 的命令行参数列表和他们的功能介绍：

### `-h`/`--help`： 帮助

该标志将打印出`rustc`的帮助信息。

### `--cfg`：配置编译环境

此标志可以打开或关闭各种`#[cfg]`设置。

该值可以是单个标识符，也可以是由`=`分隔两个标识符。

举例，`--cfg 'verbose'` 或者 `--cfg 'feature="serde"'`。分别对应`#[cfg(verbose)]`和`#[cfg(feature = "serde")]`。

### `-L`：将目录添加到库搜索路径

查找外部crate或库时，将搜索传递到此标志的目录。

搜索路径的类型可以通过 `-L KIND=PATH` 方式制定，这是可选的，其中KIND可以是以下之一：

- `dependency` —仅在此目录中搜索传递依赖项。
- `crate` —仅在此目录中搜索此crate的直接依赖项。
- `native` —仅在此目录中搜索原生类库。
- `framework` —仅在此目录中搜索macOS框架。
- `all`—在此目录中搜索所有库类型。这是KIND未指定时的默认值。

### `-l`：将生成的包链接到一个原生库

使用此标志可以在构建crate时指定链接到特定的原生库。

可以使用以下形式之一指定库的类型，-l KIND=lib 其中KIND可以是：

类库的类型可以通过 `-l KIND=lib` 方式制定，这是可选的，其中KIND可以是以下之一：

- `dylib` — 原生动态库。
- `static`— 原生静态库（例如.a 包）。
- `framework` — macOS框架。

可以在 `#[link]` 属性中指定库的类型。如果未在 link 属性或命令行中指定种类，它将链接动态库（如果可用），否则将使用静态库。如果在命令行上指定了种类，它将覆盖link属性中指定的种类。

在link属性中使用的 name 可以用 "-l ATTR_NAME:LINK_NAME" 的形式来覆盖，其中 `ATTR_NAME` 是在 link属性的 name ，而 `LINK_NAME` 是将被链接的实际库的名称。

### `--crate-type`：编译器生成包的类型列表

指示rustc要构建的crate类型。该标志接受逗号分隔的值列表，并且可以多次指定。有效的crate类型为：

- `lib`—生成编译器首选的库类型，当前默认为 `rlib`。
- `rlib` — Rust静态库。
- `staticlib` —原生静态库。
- `dylib` — Rust动态库。
- `cdylib` —原生动态库。
- `bin` —可运行的可执行程序。
- `proc-macro` —生成适合于程序宏类库的格式，该格式可由编译器加载。

crate类型可以使用 `crate_type` 属性指定。该 `--crate-type` 命令行值将覆盖 `crate_type` 属性。

可以在参考文档的 [linkage 章节](https://doc.rust-lang.org/reference/linkage.html) 中找到更多详细信息。

### `--crate-name`：指定构建的crate的名称

告诉`rustc` crate的名称。

### `--edition`：指定要使用的版本

此标志的值为 2015 或 2018。默认值为2015。有关版本的更多信息，请参见 [版本指南](https://doc.rust-lang.org/edition-guide/introduction.html)。

### `--emit`：指定要生成的输出文件的类型

该标志控制编译器生成的输出文件的类型。接受逗号分隔的值列表，并且可以多次指定。有效的生成种类有：

- `asm`—生成带有crate的汇编代码的文件。默认输出文件名是`CRATE_NAME.s`。
- `dep-info`—生成具有Makefile语法的文件，该文件指示已经加载用来生成crate的所有源文件。默认输出文件名是`CRATE_NAME.d`。
- `link`—生成由`--crate-type`指定的crate。默认输出文件名取决于crate类型和平台。这是 `--emit`未指定时的默认值。
- `llvm-bc`—生成包含LLVM 字节码的二进制文件。默认输出文件名是`CRATE_NAME.bc`。
- `llvm-ir`—生成包含LLVM IR的文件。默认输出文件名是`CRATE_NAME.ll`。
- `metadata`—生成包含有关crate元数据的文件。默认输出文件名是`CRATE_NAME.rmeta`。
- `mir`—生成包含rustc的中等中间表示形式(mid-level intermediate representation)的文件。默认输出文件名是`CRATE_NAME.mir`。
- `obj`—生成原生目标文件。默认输出文件名是 `CRATE_NAME.o`。

可以使用 `-o` 标志设置输出的文件名。可以使用 `-C extra-filename` 标志添加后缀到文件名中。除非使用该 `--out-dir` 标志，否则文件将被写入当前目录。每种生成类型还可以使用`KIND=PATH`形式来指定输出的文件名，该文件名优先于`-o`标志。

### `--print`：打印编译器信息

该标志输出有关编译器的各种信息。可以多次指定此标志，并按照指定标志的顺序打印信息。指定`--print`标志通常将禁用 `--emit`步骤，并且只会打印所请求的信息。有效的打印值类型为：

- `crate-name` — crate的名称。
- `file-names`—由`link` 生成种类创建的文件的名称。
- `sysroot` — sysroot的路径。
- `cfg`— CFG值列表。有关cfg值的更多信息，请参见[条件编译](./conditional-compilation.md)。
- `target-list`—已知目标列表。可以使用`--target`标志选择目标 。
- `target-cpus`—当前目标的可用CPU值列表。可以使用该`-C target-cpu=val`标志选择目标CPU 。
- `target-features`—当前目标的可用目标功能列表。可以使用该`-C target-feature=val` 标志启用目标功能。该标志是不安全的。有关更多详细信息，请参见[已知问题](https://doc.rust-lang.org/rustc/targets/known-issues.html)。
- `relocation-models`—重定位模型列表。可以使用`-C relocation-model=val`标志选择重定位模型。
- `code-models`—代码模型列表。可以使用`-C code-model=val`标志选择代码模型 。
- `tls-models`—支持的线程本地存储(Thread Local Storage)模型列表。可以通过`-Z tls-model=val`标志选择模型。
- `native-static-libs`—在创建`staticlib` crate类型时可以使用它。如果这是唯一标志，它将执行完整编译并包含诊断说明，该诊断说明指示在链接生成的静态库时要使用的链接器标志。该注释以文本开头， `native-static-libs:`以使其更容易获取输出。

### `-g`：包括调试信息

`-C debuginfo=2`的同义词，更多信息请参见[这里](https://doc.rust-lang.org/rustc/codegen-options/index.html#debuginfo)。

### `-O`：优化代码

`-C opt-level=2`的同义词，更多信息请参见[这里](https://doc.rust-lang.org/rustc/codegen-options/index.html#opt-level)。

### `-o`：输出的文件名

该标志控制输出文件名。

### `--out-dir`：写入输出的目录

输出的crate将被写入此目录。如果`-o`标志被使用，则忽略此标志。

### `--explain`：提供错误消息的详细说明

`rustc`的每个错误都带有错误代码；这将打印出给定错误的详细说明。

### `--test`：建立测试工具

编译此crate时，`rustc`将忽略`main`函数，而是产生一个测试工具。

### `--target`：选择要构建的目标三元组

这可以控制要生产的[目标](https://doc.rust-lang.org/rustc/targets/index.html)。

### `-W`：设置lint warnings

此标志将设置应将哪些lint设置为 warn 级别 。

### `-A`：设置lint allowed

此标志将设置应将哪些lint设置为 allow 级别 。

### `-D`：设置lint denied

此标志将设置应将哪些lint设置为 deny 级别 。

### `-F`：设置lint forbidden

此标志将设置应将哪些lint设置为 forbid 级别 。

### `-Z`：设置不稳定的选项

此标志将允许您设置rustc的不稳定选项。为了设置多个选项，`-Z`标志可以多次使用。例如：`rustc -Z verbose -Z time`。使用`-Z`指定选项仅在nightly中可用。要查看所有可用选项，请运行：`rustc -Z help`。

### `--cap-lints`：设置最严格的lint等级

此标志使您可以“限制”lint，有关更多信息，[请参见此处](https://doc.rust-lang.org/rustc/lints/levels.html#capping-lints)。

### `-C`/ `--codegen`：代码生成选项

此标志将允许您设置[代码生成选项](https://doc.rust-lang.org/rustc/codegen-options/index.html)。

### `-V`/ `--version`：打印版本

此标志将打印出`rustc`的版本。

### `-v`/ `--verbose`：使用详细输出

与其他标志结合使用时，该标志将产生额外的输出。

### `--extern`：指定外部库的位置

此标志允许您传递将链接到要构建的crate的外部crate的名称和位置。可以多次指定此标志。值的格式应为`CRATENAME=PATH`。

### `--sysroot`：覆盖系统根目录

“ sysroot”是`rustc`寻找Rust发行版附带的crate的地方。该标志允许它被覆盖。

### `--error-format`：控制错误的产生方式

该标志使您可以控制消息的格式。消息将打印到stderr。有效选项是：

- `human`—可读的输出。这是默认值。
- `json`—结构化JSON输出。有关更多详细信息，请参见[JSON章节](https://doc.rust-lang.org/rustc/json.html)。
- `short` —短的单行消息。

### `--color`：配置输出的颜色

此标志使您可以控制输出的颜色设置。有效选项是：

- `auto`—如果输出发送到tty，则使用颜色。这是默认值。
- `always` —始终使用颜色。
- `never` —切勿使输出着色。

### `--remap-path-prefix`：在输出中重新映射源名称

在所有输出中重新映射源路径前缀，包括编译器诊断，调试信息，宏扩展等。它从`FROM=TO`形式中获取值， 其中路径前缀等于`FROM`的 value 被重写为 `TO`的 value。在`FROM`自身也可以包含一个`=`符号，但`TO`价值不得。可以多次指定此标志。

这对于标准化生成产品很有用，例如通过从发出到目标文件中的路径名中删除当前目录。替换纯文本形式，不考虑当前系统的路径名语法。例如`--remap-path-prefix foo=bar`将匹配`foo/lib.rs`但不匹配 `./foo/lib.rs`。

### `--json`：配置编译器打印的json消息

当`--error-format=json`选项传递给rustc时，所有编译器的诊断输出将以JSON blob的形式发出。该 `--json`参数可与一起使用，`--error-format=json`以配置JSON Blob包含的内容以及发出的JSON Blob。

使用`--error-format=json`编译器时，始终会以JSON blob的形式发出任何编译器错误，但是该`--json`标志还可以使用以下选项来自定义输出：

- `diagnostic-short`-诊断消息的json blob应该使用“简短”呈现，而不是常规的“人为”呈现。这意味着的输出 `--error-format=short`将嵌入到JSON诊断程序中，而不是默认的`--error-format=human`。
- `diagnostic-rendered-ansi`-默认情况下，其`rendered`字段中的JSON Blob 将包含诊断的纯文本呈现。该选项改为指示诊断程序应具有嵌入的ANSI颜色代码，该颜色代码打算用于rustc通常已经用于终端输出的方式来对消息进行着色。请注意，此选项可与板条箱有效地结合使用，例如 `fwdansi`将Windows上的这些ANSI代码转换为控制台命令，或者 `strip-ansi-escapes`如果您以后希望有选择地去除ansi颜色的话。
- `artifacts`-这指示rustc为每个发出的工件发出JSON Blob。工件与`--emit`CLI参数中的请求相对应，并且该工件在文件系统上可用时，将立即发出通知。

请注意，它是无效的结合`--json`论点与`--color` 论据，并且需要结合起来`--json`使用`--error-format=json`。

有关更多详细信息，请参见[JSON章节](https://doc.rust-lang.org/rustc/json.html)。

### `@path`：从路径加载命令行标志

如果`@path`在命令行上指定，则它将打开`path`并从中读取命令行选项。这些选项是每行一个。空行表示空选项。该文件可以使用Unix或Windows样式的行尾，并且必须编码为UTF-8。