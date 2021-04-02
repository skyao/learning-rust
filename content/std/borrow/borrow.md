---
type: docs
title: "Rust标准库中的借用介绍"
linkTitle: "借用介绍"
weight: 901
date: 2021-04-02
description: Rust标准库中的借用介绍
---

https://doc.rust-lang.org/std/borrow/index.html

用于处理借用（borrow）数据的模块。

## Cow 枚举

```rust
pub enum Cow<'a, B> where
    B: 'a + ToOwned + ?Sized,  {
    Borrowed(&'a B),
    Owned(<B as ToOwned>::Owned),
}
```

clone-on-write 智能指针。

cow = Clone On Write

类型Cow是一个智能指针，提供了 clone-on-write 功能：它可以封装并提供对借用数据的不可变访问，当需要可变或所有权时，可以延迟克隆数据。该类型是通过 Borrow trait 来处理一般的借用数据。

Cow 实现了 Deref，这意味着你可以直接在它所封装的数据上调用非可变方法。如果需要改变，to_mut 将获得一个到拥有值的可变引用，必要时进行克隆。

```rust
use std::borrow::Cow;

fn abs_all(input: &mut Cow<[i32]>) {
    for i in 0..input.len() {
        let v = input[i];
        if v < 0 {
            // Clones into a vector if not already owned.
            input.to_mut()[i] = -v;
        }
    }
}

// No clone occurs because `input` doesn't need to be mutated.
let slice = [0, 1, 2];
let mut input = Cow::from(&slice[..]);
abs_all(&mut input);

// Clone occurs because `input` needs to be mutated.
let slice = [-1, 0, 1];
let mut input = Cow::from(&slice[..]);
abs_all(&mut input);

// No clone occurs because `input` is already owned.
let mut input = Cow::from(vec![-1, 0, 1]);
abs_all(&mut input);
```

### Borrow Trait

借用数据的特征。

在Rust中，常见的是为不同的用例提供不同的类型表示。例如，可以通过诸如Box<T>或Rc<T>这样的指针类型来具体选择值的存储位置和管理，以适合特定的使用情况。除了这些可以与任何类型一起使用的通用封装器之外，有些类型还提供了可选的面，提供了潜在的有开销的功能。这类类型的一个例子是String，它为基本的str增加了扩展字符串的能力。这需要为一个简单的、不可更改的字符串保留不必要的附加信息。

这些类型通过对该数据的类型的引用来提供对底层数据的访问。它们被说成是 "borrow/借用 "该类型。例如，Box<T>可以被借用为T，而String可以被借用为str。

类型表示它们可以通过实现Borrow<T>，在trait的borrow方法中提供对T的引用来表示它们可以被借用为某种类型T。一个类型可以自由地借用为多个不同类型。如果它希望可变地借用为类型--允许修改底层数据，可以额外实现BorrowMut<T>。

此外，在为附加的特征提供实现时，需要考虑到它们是否应该与底层类型的行为完全相同，因为它们作为底层类型的表示方式。当依赖这些额外的特征实现的行为相同时，通用代码通常会使用Borrow<T>。这些特征很可能会作为附加的特征边界出现。

特别是Eq、Ord和Hash对于借用值和拥有值必须是等价的：`x.borrow()==y.borrow()` 应该给出与 `x==y` 相同的结果。

如果通用代码仅仅需要对所有能够提供相关类型T的引用的类型进行工作，那么通常最好使用AsRef<T>，因为更多的类型可以安全地实现它。

例子：

作为一个数据集合，HashMap<K, V>同时拥有键和值。如果键的实际数据被封装在某种管理类型中，但是，应该还是可以使用对键的数据引用来搜索值。例如，如果键是一个字符串，那么它很可能是用哈希图作为String存储的，而应该可以用&str来搜索。因此，insert需要对String进行操作，而get需要能够使用&str。

稍微简化一下，HashMap<K, V>的相关部分看起来像这样。

```rust
use std::borrow::Borrow;
use std::hash::Hash;

pub struct HashMap<K, V> {
    // fields omitted
}

impl<K, V> HashMap<K, V> {
    pub fn insert(&self, key: K, value: V) -> Option<V>
    where K: Hash + Eq
    {
        // ...
    }

    pub fn get<Q>(&self, k: &Q) -> Option<&V>
    where
        K: Borrow<Q>,
        Q: Hash + Eq + ?Sized
    {
        // ...
    }
}
```

整个hash map是通用于一个key类型K，由于这些key是和hash map一起存储的，所以这个类型必须拥有该密钥的数据。当插入一个键-值对时，map被赋予了这样一个K，需要找到正确的hash map，并根据这个K来检查这个键是否已经存在。

然而，当在地图中搜索一个值时，必须提供一个K的引用作为要搜索的键，这就需要始终创建这样一个拥有的值。对于字符串键，这就意味着需要创建一个String值来搜索只有str的情况。

相反，get方法是通用于底层键数据的类型，在上面的方法签名中称为Q。它通过要求K:Borrow<Q>来说明K借入为Q。通过额外要求Q：Hash + Eq，它表明要求K和Q都有Hash和Eq特征的实现，产生相同的结果。

get的实现特别依赖于Hash的相同实现，通过在Q值上调用Hash::hash来确定密钥的哈希桶，即使它是根据从K值计算出的哈希值插入了key。

因此，如果一个包裹Q值的K产生的散列值与Q不同，那么hash map就会被破坏。

```rust
pub struct CaseInsensitiveString(String);

impl PartialEq for CaseInsensitiveString {
    fn eq(&self,  : &Self) -> bool {
        self.0.eq_ignore_ascii_case(&other.0)
    }
}

impl Eq for CaseInsensitiveString { }
```

因为两个相等的值需要产生相同的散列值，所以Hash的实现也需要忽略ASCII 大小写：

```rust
impl Hash for CaseInsensitiveString {
    fn hash<H: Hasher>(&self, state: &mut H) {
        for c in self.0.as_bytes() {
            c.to_ascii_lowercase().hash(state)
        }
    }
}
```

CaseInsensitiveString可以实现Borrow<str>吗？当然可以，它当然可以通过它所包含的自有字符串来提供对字符串片的引用。但由于它的Hash实现不同，它的行为方式与str不同，因此事实上不能实现Borrow<str>。如果它想允许别人访问底层的str，可以通过AsRef<str>来实现，而AsRef<str>没有任何额外的要求。

### BorrowMut Trait

用于可变地借用数据的特征。

作为 Borrow<T> 的附属属性，该特征允许一个类型通过提供一个可变的引用来借用作为底层类型。关于作为另一个类型借入的更多信息，请参阅 Borrow<T>。

### ToOwned Trait

用于借用数据的Clone泛化。

一些类型使其可以从借用数据到拥有数据，通常是通过实现Clone特征。但Clone只适用于从&T到T。ToOwned特征将Clone泛化为从给定类型的任何借入数据中构造出拥有的数据。