---
title: "Cargo设置"
linkTitle: "Cargo设置"
date: 2021-07-05
weight: 322
description: >
  Cargo设置: Cargo Crates Registry Source设置和代理设置
---

## source设置

Cargo Crates Registry Source设置.

### 添加source

为了加快 cargo 的下载速度，避免网速慢或者被墙，添加国内源头 ustc ，需修改 `~/.cargo/config` 加入以下内容： 

```properties
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
#registry = "https://mirrors.ustc.edu.cn/crates.io-index"

[http]
check-revoke = false
```

其中添加 `check-revoke = false` 是为了解决下面的问题：

```
warning: spurious network error (2 tries remaining): [6] Couldn't resolve host name (Could not resolve host: crates-io.proxy.ustclug.org)
warning: spurious network error (1 tries remaining): [6] Couldn't resolve host name (Could not resolve host: crates-io.proxy.ustclug.org)
error: failed to download from `https://crates-io.proxy.ustclug.org/api/v1/crates/serde_test/1.0.126/download`

Caused by:
  [6] Couldn't resolve host name (Could not resolve host: crates-io.proxy.ustclug.org)

```



### 参考资料

- [Rust Crates 源使用帮助 — USTC Mirror Help 文档](http://mirrors.ustc.edu.cn/help/crates.io-index.html)

## 代理设置

### 网络代理问题

执行 make 命令时遇到问题，卡在 git clone 上：

```bash
$ make
cargo fetch --locked
    Updating git repository `https://github.com/linkerd/prost`
    ......(速度太慢，卡住过不去)
```

### git代理设置

我平时一般用 ssh 方式操作git，通过设置 `~/.ssh/config` 文件的方式来设置代理，如:

```bash
# 这里必须是 github.com，因为这个跟我们 clone 代码时的链接有关
Host github.com
# 如果用默认端口，这里是 github.com，如果想用443端口，这里就是 ssh.github.com 详
见 https://help.github.com/articles/using-ssh-over-the-https-port/
#HostName ssh.github.com
HostName github.com
User git
# 如果是 HTTP 代理，把下面这行取消注释，并把 proxyport 改成自己的 http 代理的端>口
#ProxyCommand socat - PROXY:127.0.0.1:%h:%p,proxyport=3333

# 如果是 socks5 代理，则把下面这行取消注释，并把 23456 改成自己 socks5 代理的端口
ProxyCommand nc -v -x 127.0.0.1:23456 %h %p
```

上面信息中时通过 https 来操作git仓库，所以想着设置 git 的 http 代理，常见的方式是通过 `git config --global` 命令，支持 http 代理和 socks5 代理：

```bash
# 使用 http 代理
git config --global http.proxy http://192.168.0.1:3333

# 使用 socks5 代理
git config --global http.proxy socks5://192.168.0.1:23456
```

可以在 `~/.gitconfig` 中看到设置的结果。

- 参考：[Configure Git to use a proxy](https://gist.github.com/evantoli/f8c23a37eb3558ab8765)

### Cargo代理设置

但是，上面的设置只对直接使用 git 命令有效，当使用 cargo 命令时，依然会卡住。

需要为 cargo 单独设置代理，新建或打开文件 `~/.cargo/config` ，使用 http 代理:

```bash
[http]
proxy = "192.168.0.1:3333"
[https]
proxy = "192.168.0.1:3333"
```

使用 socks5代理:

```bash
[http]
proxy = "socks5://192.168.0.1:23456"
[https]
proxy = "socks5://192.168.0.1:23456"
```

