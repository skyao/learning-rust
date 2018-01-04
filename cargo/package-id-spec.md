# package id规范

> 参考: http://doc.crates.io/pkgid-spec.html

Cargo的子命令经常需要在依赖关系图中引用特定的包，用于更新，清理，构建等各种操作。为了解决这个问题，Cargo支持packge ID规范。规范是一个字符串，用于唯一地引用包。

## 规范语法

```bash
pkgid := pkgname
       | [ proto "://" ] hostname-and-path [ "#" ( pkgname | semver ) ]
pkgname := name [ ":" semver ]

proto := "http" | "git" | ...
```

中括号表示内容是可选的。

## 示例

| pkgid | name | version | url |
|--------|--------|--------|--------|
|foo	|foo	|*	|*|
|foo:1.2.3	|foo|	1.2.3|	*|
|crates.io/foo	|foo	|*	|*://crates.io/foo|
|crates.io/foo#1.2.3|	foo	|1.2.3|	*://crates.io/foo|
|crates.io/bar#foo:1.2.3	|foo	|1.2.3|	*://crates.io/bar|
|http://crates.io/foo#1.2.3	|foo|	1.2.3|	http://crates.io/foo|

规范比较简洁，目的是为了在引用依赖关系图中的包时，可以有简洁而全面的语法。

不明确的引用可能指向一个或多个包。 当一个规范指向多个包时，大多数命令会报错。
