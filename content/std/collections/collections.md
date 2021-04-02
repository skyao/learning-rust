---
type: docs
title: "Rust标准库中的集合介绍"
linkTitle: "介绍"
weight: 201
date: 2021-04-02
description: Rust标准库中的集合介绍
---

https://doc.rust-lang.org/std/collections/index.html

Rust的标准集合库提供了最常见的通用编程数据结构的高效实现。通过使用标准的实现，两个库之间的通信应该可以不需要进行大量的数据转换。

说白了：你可能只需要使用Vec或HashMap就可以了。这两个集合涵盖了大多数通用数据存储和处理的用例。它们在做它们所做的事情上表现得异常出色。标准库中的所有其他集合都有特定的用例，在这些用例中，它们是最佳的选择，但相比之下，这些用例都是小众的。即使Vec和HashMap在技术上是次优的时候，它们也可能是一个足够好的选择，可以入手。

Rust的集合可以分为四大类。

- Sequences: Vec, VecDeque, LinkedList
- Maps: HashMap, BTreeMap
- Sets: HashSet, BTreeSet
- Misc: BinaryHeap

## 什么时候应该使用哪个系列？

这些都是相当高层次的快速分解，说明了什么时候应该考虑每个集合。关于每个系列的优点和缺点的详细讨论可以在它们自己的文档页面上找到。

###  在以下情况下使用 Vec

- 想收集项目，以便以后处理或发送到其他地方，而不关心实际存储的值的任何属性。
- 想要一个特定顺序的元素序列，并且只附加到（或接近）末尾
- 想要一个堆栈
- 想要一个可调整的数组
- 想要一个堆分配的数组

### 在以下情况下使用 VecDeque

- 想要一个支持在序列两端有效插入的Vec
- 想要一个队列
- 想要一个双端队列（deque）

### 在以下情况下使用 LinkedList

- 想要一个未知大小的Vec或VecDeque，并且不能容忍摊派（tolerate amortization）。
- 想有效地分拆和附加列表。
- 绝对确定你真的真的需要一个双链接列表

### 在以下情况下使用 HashMap 

- 想把任意的键与任意的值关联起来。
- 想要一个缓存。
- 想要一个map，没有额外的功能。

### 在以下情况下使用BTreeMap

- 想要一个按键值排序的地图。
- 希望能够按需获得一系列的条目。
- 想知道最小或最大的键值对是什么。
- 想找到最大或最小的键值比什么东西小或大的键。

### 在以下情况下使用这些map中的任何一个的Set变体

- 只想记住看到过哪些键。
- 没有任何有意义的值与您的键相关联。
- 只需要一个集合。

### 在下列情况下使用 BinaryHeap 

- 想存储一堆元素，但在任何时候只想处理 "最大的 "或 "最重要的 "一个元素
- 想要一个优先级队列

## 性能

选择合适的集合，需要了解每个集合擅长什么。这里我们简单地总结了不同集合在某些重要操作中的性能。要了解更多细节，请参阅每种类型的文档，并注意实际方法的名称可能与下面的表格中的某些集合不同。

在整个文档中，我们将遵循一些惯例。对于所有的操作，集合的大小用n表示，如果操作中涉及到另一个集合，则包含m个元素。有摊销成本的操作用*作为后缀。有预期成本的作业用"~"作为后缀。

所有的摊销成本是指当容量用尽时可能需要重新调整大小。如果发生调整大小，需要O(n)时间。我们的集合从来不会自动缩小，所以移除操作不会摊销。在足够大的一系列操作中，每次操作的平均成本将确定地等于给定成本。

只有HashMap有预期成本，这是由于散列的概率性。理论上，HashMap的性能较差是可能的，尽管可能性很小。

### Sequences

|                                                              | get(i)         | insert(i)       | remove(i)      | append | split_off(i)   |
| :----------------------------------------------------------- | :------------- | :-------------- | :------------- | :----- | :------------- |
| [`Vec`](https://doc.rust-lang.org/std/vec/struct.Vec.html)   | O(1)           | O(n-i)*         | O(n-i)         | O(m)*  | O(n-i)         |
| [`VecDeque`](https://doc.rust-lang.org/std/collections/struct.VecDeque.html) | O(1)           | O(min(i, n-i))* | O(min(i, n-i)) | O(m)*  | O(min(i, n-i)) |
| [`LinkedList`](https://doc.rust-lang.org/std/collections/struct.LinkedList.html) | O(min(i, n-i)) | O(min(i, n-i))  | O(min(i, n-i)) | O(1)   | O(min(i, n-i)) |

需要注意的是，如果出现平局，Vec一般会比VecDeque快，而VecDeque一般会比LinkedList快。

### Map

对于Sets，所有的操作都和等价的Map操作的有相同的开销。

|                                                              | get      | insert   | remove   | predecessor | append |
| :----------------------------------------------------------- | :------- | :------- | :------- | :---------- | :----- |
| [`HashMap`](https://doc.rust-lang.org/std/collections/struct.HashMap.html) | O(1)~    | O(1)~*   | O(1)~    | N/A         | N/A    |
| [`BTreeMap`](https://doc.rust-lang.org/std/collections/struct.BTreeMap.html) | O(log n) | O(log n) | O(log n) | O(log n)    | O(n+m) |

## 正确和有效地使用集合的方法

当然，知道了哪种集合对工作是正确的选择，并不能马上就能正确使用它。以下是一些关于标准集合的高效和正确使用的快速提示。如果你对如何使用特定的集合有兴趣，请参考其文档中的详细讨论和代码示例。

### 容量管理

许多集合提供了多个构造器和方法，这些构造器和方法都是指 "容量"。这些集合一般是建立在一个数组之上。在最理想的情况下，这个数组的大小应该是完全正确的，只容纳存储在集合中的元素，但对于集合来说，这样做的效率会非常低。如果后备数组在任何时候都是完全正确的大小，那么每次插入一个元素时，集合就必须增长数组来容纳它。由于大多数计算机的内存分配和管理方式，这几乎肯定需要分配一个全新的数组，并将旧数组中的每一个元素复制到新数组中。你能看到，这对每一次操作来说都不是很有效。

因此，大多数集合使用的是一种摊销分配策略。它们一般会让自己有相当数量的未被占用的空间，这样它们只需要偶尔增长。当它们增长的时候，它们会分配一个大得多的数组来移动元素，这样就需要一段时间才能再增长一次。虽然这种策略在一般情况下是很好的，但如果集合永远不需要重新调整其支持的数组的大小就更好了。不幸的是，集合本身并没有足够的信息来做这件事。因此，要靠我们这些程序员来给它提示。

任何 with_capacity 构造函数都会指示集合为指定的元素数量分配足够的空间。理想的情况下，这将是为这么多的元素分配足够的空间，但一些实现细节可能会阻止这一点。详情请参阅集合的特定文档。一般来说，当你知道要插入多少个元素时，使用 with_capacity，或者至少对这个数字有一个合理的上限。

当预计会有大量的元素涌入时，可以使用 reserve 系列方法来提示集合应该为即将到来的项目留出多少空间。就像用with_capacity 一样，这些方法的精确行为将取决于所关注的集合。

为了获得最佳性能，集合通常会避免自己缩减。如果你认为一个集合很快就不会再包含任何元素了，或者只是真的需要内存，那么 shrink_to_fit 方法就会提示集合将备份数组缩小到能够容纳元素的最小尺寸。

最后，如果你想知道集合的实际容量是多少，大多数集合提供了 capacity 方法来查询这个信息。这可以用于调试目的，或者与 reserve 方法一起使用。

### 迭代器

迭代器是一个强大而稳健的机制，在整个Rust的标准库中使用。迭代器以一种通用、安全、高效和方便的方式提供了值的序列。迭代器的内容通常是延迟地进行评估，因此只有实际需要的值才会被实际产生，不需要进行分配来临时存储。迭代器主要是使用 for 循环消费，尽管许多函数在需要集合或值序列的时候也会采取迭代器。

所有的标准集合都提供了多个迭代器，用于执行对其内容的批量操作。几乎每个集合都应该提供的三个主要迭代器是 iter、iter_mut 和 into_iter。其中一些在集合中没有提供，如果提供这些迭代器是不健全或不合理的。

iter以最 "自然 "的顺序为集合的所有内容提供了一个不变的引用迭代器。对于像Vec这样的序列集合，这意味着从0开始，项目将按索引的递增顺序产生；对于像BTreeMap这样的有序集合，这意味着项目将按排序顺序产生。对于像HashMap这样的无序集合，项目将以内部表示最方便的顺序产生。这对于游历集合的所有内容是非常好的。

```rust
let vec = vec![1, 2, 3, 4];
for x in vec.iter() {
   println!("vec contained {}", x);
}
```

iter_mut 提供了一个可变引用的迭代器，其顺序与 iter 相同。这对于改变集合中的所有内容是非常好的。

```rust
let mut vec = vec![1, 2, 3, 4];
for x in vec.iter_mut() {
   *x += 1;
}
```

into_iter将实际的集合按值转换为一个迭代器。当集合本身不再需要，而其他地方需要值的时候，这个方法就很好用。配合使用extend和 into_iter是将一个集合的内容转移到另一个集合中的主要方式。extend 自动调用 into_iter，并获取任何 `T: `[`IntoIterator`](https://doc.rust-lang.org/std/iter/trait.IntoIterator.html)。在迭代器本身上调用 collect 也是将一个集合转换为另一个集合的好方法。这两种方法都应该在内部使用上一节中讨论过的容量管理工具来尽可能高效地完成这一任务。

```rust
let mut vec1 = vec![1, 2, 3, 4];
let vec2 = vec![10, 20, 30, 40];
vec1.extend(vec2);
```

```rust
use std::collections::VecDeque;

let vec = vec![1, 2, 3, 4];
let buf: VecDeque<_> = vec.into_iter().collect();
```

迭代器还提供了一系列的 *adapter* 方法，用于为序列执行常见的操作。在这些 adapter 方法中，有很多函数式的喜好，比如map、fold、skip和take。对于集合来说，特别感兴趣的是 rev 适配器，它可以对任何支持这种操作的迭代器进行可逆迭代。大多数集合都提供了可逆迭代器，作为对其进行反向迭代的方式。

```rust
let vec = vec![1, 2, 3, 4];
for x in vec.iter().rev() {
   println!("vec contained {}", x);
}
```

其他一些集合方法也返回迭代器来产生结果序列，但避免分配整个集合来存储结果。这提供了最大的灵活性，因为如果需要的话，可以调用 collect 或 extend 来将序列 "管道 "到任何集合中。否则，这个序列可以用for循环来循环。迭代器也可以在部分使用后丢弃，防止计算未使用的项。

### Entry

Entry API的目的是提供一个高效的机制，以有条件地操作 map 的内容，是否存在密钥为条件。其主要的动机用例是提供有效的累积器map。例如，如果一个人希望统计每个key被看到的次数，他们必须执行一些条件逻辑来判断这个键是否是第一次被看到。通常情况下，这将需要在查找之后再进行插入，有效地重复了每次插入时的搜索工作。

当用户调用map.entry(&key)时，地图将搜索该键，然后产生一个Entry enum的变体。

如果产生了一个Vacant(entry)，则表示没有找到该key。在这种情况下，唯一有效的操作就是在条目中插入一个值。完成后，空缺的条目被消费掉，并转换为插入的值的可变引用。这样可以在搜索本身的生命周期之外对值进行进一步的操作。如果需要对该值进行复杂的逻辑处理，不管该值是否刚刚被插入，这一点是非常有用的。

如果产生了一个Occupied(entry)，那么就表示已经找到了键。在这种情况下，用户有几个选项：他们可以获取、插入或删除被占用的条目的值。此外，他们可以将被占用的条目转换为其值的可变引用，为空缺插入情况提供对称性。

这里主要用两种使用 entry 的方式。首先是一个简单的例子，在这个例子中，对值进行的逻辑是琐碎的。

#### 计算字符串中每个字符出现的次数

```rust
use std::collections::btree_map::BTreeMap;

let mut count = BTreeMap::new();
let message = "she sells sea shells by the sea shore";

for c in message.chars() {
    *count.entry(c).or_insert(0) += 1;
}

assert_eq!(count.get(&'s'), Some(&8));

println!("Number of occurrences of each character");
for (char, count) in &count {
    println!("{}: {}", char, count);
}
```

当值上要执行的逻辑比较复杂时，我们可以简单的使用entry API来保证值的初始化，然后再执行后面的逻辑。

#### 追踪顾客在酒吧的醉酒情况

```rust
use std::collections::btree_map::BTreeMap;

// A client of the bar. They have a blood alcohol level.
struct Person { blood_alcohol: f32 }

// All the orders made to the bar, by client ID.
let orders = vec![1, 2, 1, 2, 3, 4, 1, 2, 2, 3, 4, 1, 1, 1];

// Our clients.
let mut blood_alcohol = BTreeMap::new();

for id in orders {
    // If this is the first time we've seen this customer, initialize them
    // with no blood alcohol. Otherwise, just retrieve them.
    let person = blood_alcohol.entry(id).or_insert(Person { blood_alcohol: 0.0 });

    // Reduce their blood alcohol level. It takes time to order and drink a beer!
    person.blood_alcohol *= 0.9;

    // Check if they're sober enough to have another beer.
    if person.blood_alcohol > 0.3 {
        // Too drunk... for now.
        println!("Sorry {}, I have to cut you off", id);
    } else {
        // Have another!
        person.blood_alcohol += 0.1;
    }
}
```

#### 插入和复合键

如果我们有一个比较复杂的键，调用插入将不会更新该键的值。比如说。

```rust
use std::cmp::Ordering;
use std::collections::BTreeMap;
use std::hash::{Hash, Hasher};

#[derive(Debug)]
struct Foo {
    a: u32,
    b: &'static str,
}

// we will compare `Foo`s by their `a` value only.
impl PartialEq for Foo {
    fn eq(&self, other: &Self) -> bool { self.a == other.a }
}

impl Eq for Foo {}

// we will hash `Foo`s by their `a` value only.
impl Hash for Foo {
    fn hash<H: Hasher>(&self, h: &mut H) { self.a.hash(h); }
}

impl PartialOrd for Foo {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> { self.a.partial_cmp(&other.a) }
}

impl Ord for Foo {
    fn cmp(&self, other: &Self) -> Ordering { self.a.cmp(&other.a) }
}

let mut map = BTreeMap::new();
map.insert(Foo { a: 1, b: "baz" }, 99);

// We already have a Foo with an a of 1, so this will be updating the value.
map.insert(Foo { a: 1, b: "xyz" }, 100);

// The value has been updated...
assert_eq!(map.values().next().unwrap(), &100);

// ...but the key hasn't changed. b is still "baz", not "xyz".
assert_eq!(map.keys().next().unwrap().b, "baz");
```