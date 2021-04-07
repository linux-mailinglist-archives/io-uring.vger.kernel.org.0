Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02977356E4B
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243578AbhDGORA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 10:17:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15949 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhDGORA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 10:17:00 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FFmcD75PdzrdJT;
        Wed,  7 Apr 2021 22:14:36 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 22:16:43 +0800
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
To:     Pavel Begunkov <asml.silence@gmail.com>, <viro@zeniv.linux.org.uk>,
        <axboe@kernel.dk>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <3bd14a60-b259-377b-38d5-907780bc2416@huawei.com>
 <a0bcd483-180d-7c8b-b0bf-a419606a6c7e@gmail.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <67a90ee7-e5ce-fdda-626d-12b5dc70e4a7@huawei.com>
Date:   Wed, 7 Apr 2021 22:16:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a0bcd483-180d-7c8b-b0bf-a419606a6c7e@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



在 2021/4/6 19:04, Pavel Begunkov 写道:
> On 06/04/2021 02:28, yangerkun wrote:
>> Ping...
> 
> It wasn't forgotten, but wouln't have worked because of
> other reasons. With these two already queued, that's a
> different story.
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.12&id=07204f21577a1d882f0259590c3553fe6a476381
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.12&id=230d50d448acb6639991440913299e50cacf1daf
> 
> Can you re-confirm, that the bug is still there (should be)
> and your patch fixes it?

Hi,

This problem still exists in mainline (2d743660786e Merge branch 'fixes' 
of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs), and this 
patch will fix it.

The io_read for loop will return -EAGAIN. This will lead a 
iov_iter_revert in io_read. Once we truncate iov_iter in 
blkdev_read_iter, we will see this bug...


[  181.204371][ T4241] loop0: detected capacity change from 0 to 232 

[  181.253683][ T4241] 
==================================================================
[  181.255313][ T4241] BUG: KASAN: slab-out-of-bounds in 
iov_iter_revert+0xd0/0x3e0
[  181.256723][ T4241] Read of size 8 at addr ffff0000cfbc8ff8 by task 
a.out/4241
[  181.257776][ T4241] 

[  181.258749][ T4241] CPU: 5 PID: 4241 Comm: a.out Not tainted 
5.12.0-rc6-00006-g2d743660786e
#1 

[  181.260149][ T4241] Hardware name: linux,dummy-virt (DT) 

[  181.261468][ T4241] Call trace: 

[  181.262052][ T4241]  dump_backtrace+0x0/0x348 

[  181.263139][ T4241]  show_stack+0x28/0x38 

[  181.264234][ T4241]  dump_stack+0x134/0x1a4 

[  181.265175][ T4241]  print_address_description.constprop.0+0x68/0x304 

[  181.266430][ T4241]  kasan_report+0x1d0/0x238 

[  181.267308][ T4241]  __asan_load8+0x88/0xc0 

[  181.268317][ T4241]  iov_iter_revert+0xd0/0x3e0 

[  181.269251][ T4241]  io_read+0x310/0x5c0 

[  181.270208][ T4241]  io_issue_sqe+0x3fc/0x25d8 

[  181.271134][ T4241]  __io_queue_sqe+0xf8/0x480 

[  181.272142][ T4241]  io_queue_sqe+0x3a4/0x4c8 

[  181.273053][ T4241]  io_submit_sqes+0xd9c/0x22d0 

[  181.274375][ T4241]  __arm64_sys_io_uring_enter+0x3d0/0xce0 

[  181.275554][ T4241]  do_el0_svc+0xc4/0x228 

[  181.276411][ T4241]  el0_svc+0x24/0x30 

[  181.277323][ T4241]  el0_sync_handler+0x158/0x160 

[  181.278241][ T4241]  el0_sync+0x13c/0x140 

[  181.279287][ T4241] 

[  181.279820][ T4241] Allocated by task 4241: 

[  181.280699][ T4241]  kasan_save_stack+0x24/0x50 

[  181.281626][ T4241]  __kasan_kmalloc+0x84/0xa8 

[  181.282578][ T4241]  io_wq_create+0x94/0x668 

[  181.283469][ T4241]  io_uring_alloc_task_context+0x164/0x368 

[  181.284748][ T4241]  io_uring_add_task_file+0x1b0/0x208 

[  181.285865][ T4241]  io_uring_setup+0xaac/0x12a0 

[  181.286823][ T4241]  __arm64_sys_io_uring_setup+0x34/0x40 

[  181.287957][ T4241]  do_el0_svc+0xc4/0x228 

[  181.288906][ T4241]  el0_svc+0x24/0x30 

[  181.289816][ T4241]  el0_sync_handler+0x158/0x160 

[  181.290751][ T4241]  el0_sync+0x13c/0x140 

[  181.291697][ T4241] 


> 
>>
>> 在 2021/4/1 15:18, yangerkun 写道:
>>> We get a bug:
>>>
>>> BUG: KASAN: slab-out-of-bounds in iov_iter_revert+0x11c/0x404
>>> lib/iov_iter.c:1139
>>> Read of size 8 at addr ffff0000d3fb11f8 by task
>>>
>>> CPU: 0 PID: 12582 Comm: syz-executor.2 Not tainted
>>> 5.10.0-00843-g352c8610ccd2 #2
>>> Hardware name: linux,dummy-virt (DT)
>>> Call trace:
>>>    dump_backtrace+0x0/0x2d0 arch/arm64/kernel/stacktrace.c:132
>>>    show_stack+0x28/0x34 arch/arm64/kernel/stacktrace.c:196
>>>    __dump_stack lib/dump_stack.c:77 [inline]
>>>    dump_stack+0x110/0x164 lib/dump_stack.c:118
>>>    print_address_description+0x78/0x5c8 mm/kasan/report.c:385
>>>    __kasan_report mm/kasan/report.c:545 [inline]
>>>    kasan_report+0x148/0x1e4 mm/kasan/report.c:562
>>>    check_memory_region_inline mm/kasan/generic.c:183 [inline]
>>>    __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>>>    iov_iter_revert+0x11c/0x404 lib/iov_iter.c:1139
>>>    io_read fs/io_uring.c:3421 [inline]
>>>    io_issue_sqe+0x2344/0x2d64 fs/io_uring.c:5943
>>>    __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>>>    io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>>>    io_submit_sqe fs/io_uring.c:6395 [inline]
>>>    io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
>>>    __do_sys_io_uring_enter fs/io_uring.c:9013 [inline]
>>>    __se_sys_io_uring_enter fs/io_uring.c:8960 [inline]
>>>    __arm64_sys_io_uring_enter+0x190/0x708 fs/io_uring.c:8960
>>>    __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>>>    invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>>>    el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
>>>    do_el0_svc+0x120/0x290 arch/arm64/kernel/syscall.c:227
>>>    el0_svc+0x1c/0x28 arch/arm64/kernel/entry-common.c:367
>>>    el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
>>>    el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670
>>>
>>> Allocated by task 12570:
>>>    stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>>>    kasan_save_stack mm/kasan/common.c:48 [inline]
>>>    kasan_set_track mm/kasan/common.c:56 [inline]
>>>    __kasan_kmalloc+0xdc/0x120 mm/kasan/common.c:461
>>>    kasan_kmalloc+0xc/0x14 mm/kasan/common.c:475
>>>    __kmalloc+0x23c/0x334 mm/slub.c:3970
>>>    kmalloc include/linux/slab.h:557 [inline]
>>>    __io_alloc_async_data+0x68/0x9c fs/io_uring.c:3210
>>>    io_setup_async_rw fs/io_uring.c:3229 [inline]
>>>    io_read fs/io_uring.c:3436 [inline]
>>>    io_issue_sqe+0x2954/0x2d64 fs/io_uring.c:5943
>>>    __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>>>    io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>>>    io_submit_sqe fs/io_uring.c:6395 [inline]
>>>    io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
>>>    __do_sys_io_uring_enter fs/io_uring.c:9013 [inline]
>>>    __se_sys_io_uring_enter fs/io_uring.c:8960 [inline]
>>>    __arm64_sys_io_uring_enter+0x190/0x708 fs/io_uring.c:8960
>>>    __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>>>    invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>>>    el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
>>>    do_el0_svc+0x120/0x290 arch/arm64/kernel/syscall.c:227
>>>    el0_svc+0x1c/0x28 arch/arm64/kernel/entry-common.c:367
>>>    el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
>>>    el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670
>>>
>>> Freed by task 12570:
>>>    stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>>>    kasan_save_stack mm/kasan/common.c:48 [inline]
>>>    kasan_set_track+0x38/0x6c mm/kasan/common.c:56
>>>    kasan_set_free_info+0x20/0x40 mm/kasan/generic.c:355
>>>    __kasan_slab_free+0x124/0x150 mm/kasan/common.c:422
>>>    kasan_slab_free+0x10/0x1c mm/kasan/common.c:431
>>>    slab_free_hook mm/slub.c:1544 [inline]
>>>    slab_free_freelist_hook mm/slub.c:1577 [inline]
>>>    slab_free mm/slub.c:3142 [inline]
>>>    kfree+0x104/0x38c mm/slub.c:4124
>>>    io_dismantle_req fs/io_uring.c:1855 [inline]
>>>    __io_free_req+0x70/0x254 fs/io_uring.c:1867
>>>    io_put_req_find_next fs/io_uring.c:2173 [inline]
>>>    __io_queue_sqe+0x1fc/0x520 fs/io_uring.c:6279
>>>    __io_req_task_submit+0x154/0x21c fs/io_uring.c:2051
>>>    io_req_task_submit+0x2c/0x44 fs/io_uring.c:2063
>>>    task_work_run+0xdc/0x128 kernel/task_work.c:151
>>>    get_signal+0x6f8/0x980 kernel/signal.c:2562
>>>    do_signal+0x108/0x3a4 arch/arm64/kernel/signal.c:658
>>>    do_notify_resume+0xbc/0x25c arch/arm64/kernel/signal.c:722
>>>    work_pending+0xc/0x180
>>>
>>> blkdev_read_iter can truncate iov_iter's count since the count + pos may
>>> exceed the size of the blkdev. This will confuse io_read that we have
>>> consume the iovec. And once we do the iov_iter_revert in io_read, we
>>> will trigger the slab-out-of-bounds. Fix it by reexpand the count with
>>> size has been truncated.
>>>
>>> blkdev_write_iter can trigger the problem too.
>>>
>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>> ---
>>>    fs/block_dev.c | 20 +++++++++++++++++---
>>>    1 file changed, 17 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>> index 92ed7d5df677..788e1014576f 100644
>>> --- a/fs/block_dev.c
>>> +++ b/fs/block_dev.c
>>> @@ -1680,6 +1680,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>        struct inode *bd_inode = bdev_file_inode(file);
>>>        loff_t size = i_size_read(bd_inode);
>>>        struct blk_plug plug;
>>> +    size_t shorted = 0;
>>>        ssize_t ret;
>>>          if (bdev_read_only(I_BDEV(bd_inode)))
>>> @@ -1697,12 +1698,17 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>>        if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
>>>            return -EOPNOTSUPP;
>>>    -    iov_iter_truncate(from, size - iocb->ki_pos);
>>> +    size -= iocb->ki_pos;
>>> +    if (iov_iter_count(from) > size) {
>>> +        shorted = iov_iter_count(from) - size;
>>> +        iov_iter_truncate(from, size);
>>> +    }
>>>          blk_start_plug(&plug);
>>>        ret = __generic_file_write_iter(iocb, from);
>>>        if (ret > 0)
>>>            ret = generic_write_sync(iocb, ret);
>>> +    iov_iter_reexpand(from, iov_iter_count(from) + shorted);
>>>        blk_finish_plug(&plug);
>>>        return ret;
>>>    }
>>> @@ -1714,13 +1720,21 @@ ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>>        struct inode *bd_inode = bdev_file_inode(file);
>>>        loff_t size = i_size_read(bd_inode);
>>>        loff_t pos = iocb->ki_pos;
>>> +    size_t shorted = 0;
>>> +    ssize_t ret;
>>>          if (pos >= size)
>>>            return 0;
>>>          size -= pos;
>>> -    iov_iter_truncate(to, size);
>>> -    return generic_file_read_iter(iocb, to);
>>> +    if (iov_iter_count(to) > size) {
>>> +        shorted = iov_iter_count(to) - size;
>>> +        iov_iter_truncate(to, size);
>>> +    }
>>> +
>>> +    ret = generic_file_read_iter(iocb, to);
>>> +    iov_iter_reexpand(to, iov_iter_count(to) + shorted);
>>> +    return ret;
>>>    }
>>>    EXPORT_SYMBOL_GPL(blkdev_read_iter);
>>>   
> 
