---
type: docs
title: "Rust标准库中的多生产者单消费者队列(mpsc)"
linkTitle: "多生产者单消费者队列(mpsc)"
weight: 350
date: 2021-04-02
description: Rust标准库中的多生产者单消费者队列(mpsc)
---

https://doc.rust-lang.org/std/sync/mpsc/index.html

多生产者、单消费者FIFO队列通信原语。

mpsc = Multiple Producer Single Consumer

该模块提供在通道（channel）上基于消息的通信，具体定义为三种类型。

- Sender
- SyncSender
- Receiver

Sender 或 SyncSender 用于向 Receiver 发送数据。这两个 sender 都是可克隆的（多生产者），这样，许多线程可以同时向一个 Receiver 发送数据（单消费者）。

这些通道（channel）有两种类型。

1. 异步的、无限缓冲的通道（channel）。channel 函数将返回一个(Sender, Receiver)元组，其中所有的发送都是异步的(它们从不阻塞)。该通道在概念上有一个无限缓冲。

2. 同步的、有边界的通道（channel）。sync_channel 函数将返回一个(SyncSender, Receiver) tuple，在这个函数中，等待消息的存储是一个预先分配的固定大小的缓冲区。所有的发送都将通过阻塞来同步，直到有可用的缓冲区空间。请注意，允许边界为0，这将使该通道成为一个 "会合 "通道，每个发送方都会将消息原子化地交给接收方。

### 断连

通道上的发送和接收操作都会返回一个结果，表示操作是否成功。一个不成功的操作通常表示一个通道的另一半通道被丢弃在相应的线程中而 "挂断"。

一旦一个通道的一半被deocallated，大多数操作就不能再继续进行，所以会返回Err。许多应用程序会继续解包这个模块返回的结果，如果其中一个线程意外死亡，就会在线程之间传播失败。















