# crate

## 定义

crate是Rust中的编译单元。crate的中文意思是"箱/"包装箱"。

当通过`rustc`命令编译时，比如先后调用

```bash
rustc module1.rs
rustc module2.rs
rustc module3.rs
```

则`module1.rs`/`module2.rs`/`module3.rs`这三个文件都是crate文件。

## 编译

crate可以编译成二进制可执行文件（binary）或库文件（library）。

默认情况下，rustc将从crate产生库文件。这种行为可以通过rustc的选项`--crate-type `覆盖。

以下为执行`rustc --help`命令得到的帮助内容：

```bash
--crate-type [bin|lib|rlib|dylib|cdylib|staticlib|proc-macro]
                Comma separated list of types of crates for the
                compiler to emit
```

### 模块的编译

如果编译的rs文件里面含有`mod`声明，那么对应模块文件的内容将在运行编译器之前与 crate文件合并。也就是说，**模块不会单独编译**，只有在crate文件编译时一起编译。






