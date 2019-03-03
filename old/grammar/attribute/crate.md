# crate属性

- `crate_type`属性指定crate的类型

	可以告知编译器 crate 是一个二进制的可执行文件还是一个库（甚至是哪种类型的库），

- `crate_name`属性设定crate的名称。

	覆盖`rustc`编译命令生成的目标文件的名字。


```rust
#![crate_type = "lib"]
#![crate_name = "rary"]
......
```

当设置了crate的`crate_type`属性时，在编译就不再需要`--crate-type`参数。