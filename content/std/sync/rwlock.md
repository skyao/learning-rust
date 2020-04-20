---
date: 2019-04-06T16:00:00+08:00
title: RwLock/读写锁
menu:
  main:
    parent: "std-sync"
weight: 2037
description : "Rust标准库中的RwLock"
---

https://doc.rust-lang.org/std/sync/struct.RwLock.html

读写锁

这种类型的锁允许在任何时间点上有多个读或最多一个写。这种锁的写部分通常允许修改底层数据（独占访问），而读部分通常允许只读访问（共享访问）。

相比之下，Mutex不区分获取该锁的读写，因此会阻止任何等待该锁可用的线程。RwLock将允许任何数量的读获取该锁，只要一个写不持有该锁。

锁的优先级策略取决于底层操作系统的实现，这种类型并不保证会使用任何特定的策略。

类型参数T代表这个锁所保护的数据。它要求T满足Send满足跨线程共享和满足Sync以便通过reader并发访问。从锁方法中返回的RAII守护实现了Deref（和写方法的DerefMut），允许访问锁的内容。

### 毒化

像Mutex一样，RwLock会在恐慌时中毒。但是，请注意，只有在RwLock被完全锁定时（写模式）发生恐慌时，RwLock才会中毒。如果恐慌发生在任何读卡器中，那么该锁将不会中毒。







