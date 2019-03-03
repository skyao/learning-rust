# 链接外部crate

## 从crate创建库

首先创建一个create文件`app.rs`：

```rust
pub fn init() {
    println!("call init");
}
```

先把这个crate文件编译为库，此时rustc命令需要指定`--crate-type=lib`：

```rust
$ rustc --crate-type=lib app.rs
$ ls lib*
libapp.rlib
```

可以看到输入的文件`app.rs`在编译之后会得到一个名为`libapp.rlib`的文件。

编译目标文件的命名规则：

1. 默认为编译文件加上`lib`前缀。

1. 默认在lib后面加上crate文件的名字

1. 可以通过`crate_name`属性来覆盖默认规则

详细内容参考[crate属性](../attribute/crate.md)。

## 链接到当前crate

通过`extern crate`声明来将外部crate链接进当前crate。然后就可以通过crate的名字调用它的public方法：

```rust
extern crate app;

fn main() {
    app::init();
}
```

可以在链接时为crate取一个别名，然后通过别名来调用：

```rust
extern crate app as myapp;

fn main() {
    myapp::init();
}
```

### crate名称中的分隔符

这是新人入门容易遇到的一个小坑。

Cargo.toml文件的内容，这里定义的name是"conduit-proxy"，注意是分隔符是中划线：

```rust
[package]
name = "conduit-proxy"
```

这个name就是`lib.rs`的crate name。在`main.rs`中，需要使用这个name来调用`lib.rs`的内容：

```rust
extern crate conduit_proxy;

fn main() {
	......
    conduit_proxy::Main::new(config).run();
}
```

注意这里的是"conduit_proxy"，分隔符是下划线，和上面的"conduit-proxy"中划线不同。

这里的规则是：

1. 代码中必须使用下划线/"conduit_proxy"

	中划线"conduit-proxy"在代码中直接编译失败，因为"-"/中划线在rust中是特殊字符。

2. `cargo.toml`文件中name推荐使用中划线"conduit-proxy"

	rust会做好名字的对应，中划线"conduit-proxy"的name，在代码中用下划线"conduit_proxy"做调用。

	当然，如果将name设置为下划线"conduit_proxy"，和代码保持一直，也是可以的。

rust官方的参考资料：

- [Disallow hyphens in Rust crate names](https://github.com/rust-lang/rfcs/pull/940)
- [Accept hyphen in crate name in place of underscore](https://github.com/rust-lang/cargo/issues/2775)