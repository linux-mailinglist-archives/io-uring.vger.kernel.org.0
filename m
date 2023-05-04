Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD946F732E
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEDT3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 15:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjEDT3z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 15:29:55 -0400
X-Greylist: delayed 558 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 May 2023 12:29:53 PDT
Received: from mail.reece.sx (phobos.reece.sx [51.68.206.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908115FF9
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 12:29:53 -0700 (PDT)
Received: from [10.0.2.15] (unknown [192.168.144.2])
        by mail.reece.sx (Postfix) with ESMTPSA id B10F34FA039A;
        Thu,  4 May 2023 19:20:33 +0000 (UTC)
Message-ID: <23940f55-9905-4e4b-48dc-31d309c9e363@reece.sx>
Date:   Thu, 4 May 2023 20:20:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
From:   Reece <me@reece.sx>
To:     io-uring@vger.kernel.org
Subject: io_uring is a regression over 16 year old aio/io_submit, 2+ decades
 of Microsoft NT, and *BSD circa 1997-2001
Cc:     axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED,
        URI_TRY_3LD autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I don't know how you guys have done it, but somehow you've already 
messed up at no greater than 4th operation of io_uring_register, namely 
IORING_REGISTER_EVENTFD.

Let's look at aio subsystem for a moment, the iocb structure has a 
aio_flags and a aio_resfd member. Latterly, this member can be used to 
fire an eventfd/signalfd subsystem file descriptor.

struct iocb
{
     __u64   aio_data;
     [...]
     __u16   aio_lio_opcode;
     [...]
     __u64   aio_buf;
     __u64   aio_nbytes;
     __s64   aio_offset;
     [...]
     __u32   aio_flags;
     __u32   aio_resfd;
};

For fun, let's look at a competing operating system, Windows 2000.

typedef struct _OVERLAPPED {
     ULONG_PTR Internal;
     ULONG_PTR InternalHigh;
     union {
         struct {
             DWORD Offset;
             DWORD OffsetHigh;
         };
         PVOID Pointer;
     };
     HANDLE  hEvent;

} OVERLAPPED, *LPOVERLAPPED;
https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-overlapped

Or what about the BSD family of operating systems?
...Well, they natively support the POSIX AIO apis of aio_readv, 
aio_writev (circa 1997 - POSIX SID, Issue 5), and the synchronization of 
these aio contexts under kevent/kqueues using the EVFILT_AIO event 
filter (FreeBSD: Apr 16, 2000).
https://pubs.opengroup.org/onlinepubs/9693999499/toc.pdf
https://github.com/freebsd/freebsd-src/commit/3ee12e4fe3c884db74bc236f6f76dfb7539eb0d1

An interesting pattern is starting to emerge. For each IO transaction, 
these IO subsystems allows the developer to register an IO event object 
(or equivalent) to become signaled upon the IO transactions completion.

Now let's take look at this super duper "we've finally figured out how 
to do asynchronous IO transactions in Linux" subsystem.

    It’s possible to use eventfd(2) to get notified of completion events
    on an io_uring instance. If this is desired, an eventfd file
    descriptor can be registered through this operation. /arg/ must
    contain a pointer to the eventfd file descriptor, and /nr_args/ must
    be 1. Available since 5.2.

Wa, wa, waaaa. Fail.

We went from being able to signal file descriptors/HANDLEs per IO 
transaction over a decade ago, to now being able to listening to gnats 
fart in a singular IO batching context. It's my understanding that the 
whole purpose of io_uring is to perform IO on a single IO thread or two, 
over the annoying synchronous read/write syscalls Linux has been stuck 
with since the inception of UNIX. The BSD family of operating systems 
had no problem adopting kevent support for POSIX AIO, meanwhile Linux 
[glibc] only ever had a dumb polyfil solution of "lol lets just spam a 
bunch of threads and hope for the best." I digress. The whole point of 
this dumb interface should be to allow for batching of what would 
otherwise be blocking IO operations on a single thread. It therefore 
makes sense to have some way to signal a unique handle that a 
transaction is complete for the sake of synchronizing other threads 
against the IO submitter thread, should a different thread need to poll 
against the result/completion status of the work submitted (AND ONLY THE 
TRANSACTION). Sure, you could use userland semaphores signaled by the IO 
thread with some added latency, but that's not the point; by far the 
easiest way to batch waits of completable objects while yielding the 
current task/thread context is to simply look past user-land scheduling 
and switching, and to look towards kernels native event/io 
synchronization objects. For whatever reason, this functionality does 
not exist in io_uring. What's worse, a less efficient spammier io signal 
trigger exists in its' place.

I'm sure there will be "you're doing it wrong" responses from the Linux 
community, as always; however io_uring was supposed to fix the issues of 
AIO, not regress the existing functionality of Linux into being less 
useful than a two decade old Microsoft operating system and a FreeBSD 
build from Apr 16, 2000.

