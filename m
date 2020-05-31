Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10971E9801
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2020 15:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgEaN6r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 May 2020 09:58:47 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:46622 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbgEaN6r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 May 2020 09:58:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-73FmS_1590933475;
Received: from 30.15.192.46(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-73FmS_1590933475)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 31 May 2020 21:57:56 +0800
Subject: Re: [PATCH v4 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200530143947.21224-1-xiaoguang.wang@linux.alibaba.com>
 <8c361177-c0b0-b08c-e0a5-141f7fd948f0@kernel.dk>
 <e2040210-ab73-e82b-50ea-cdeb88c69157@kernel.dk>
 <27e264ec-2707-495f-3d24-4e9e20b86032@kernel.dk>
 <12819413-f2bf-8156-c0e2-e617ce918e76@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <7734da65-33ad-5472-88f8-bdd84c5d4f41@linux.alibaba.com>
Date:   Sun, 31 May 2020 21:57:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <12819413-f2bf-8156-c0e2-e617ce918e76@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 30/05/2020 20:29, Jens Axboe wrote:
>> On 5/30/20 11:14 AM, Jens Axboe wrote:
>>> On 5/30/20 10:44 AM, Jens Axboe wrote:
>>>> On 5/30/20 8:39 AM, Xiaoguang Wang wrote:
>>>>> If requests can be submitted and completed inline, we don't need to
>>>>> initialize whole io_wq_work in io_init_req(), which is an expensive
>>>>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>>>>> io_wq_work is initialized.
>>>>>
>>>>> I use /dev/nullb0 to evaluate performance improvement in my physical
>>>>> machine:
>>>>>    modprobe null_blk nr_devices=1 completion_nsec=0
>>>>>    sudo taskset -c 60 fio  -name=fiotest -filename=/dev/nullb0 -iodepth=128
>>>>>    -thread -rw=read -ioengine=io_uring -direct=1 -bs=4k -size=100G -numjobs=1
>>>>>    -time_based -runtime=120
>>>>>
>>>>> before this patch:
>>>>> Run status group 0 (all jobs):
>>>>>     READ: bw=724MiB/s (759MB/s), 724MiB/s-724MiB/s (759MB/s-759MB/s),
>>>>>     io=84.8GiB (91.1GB), run=120001-120001msec
>>>>>
>>>>> With this patch:
>>>>> Run status group 0 (all jobs):
>>>>>     READ: bw=761MiB/s (798MB/s), 761MiB/s-761MiB/s (798MB/s-798MB/s),
>>>>>     io=89.2GiB (95.8GB), run=120001-120001msec
>>>>>
>>>>> About 5% improvement.
>>>>
>>>> There's something funky going on here. I ran the liburing test
>>>> suite on this, and get a lot of left behind workers:
>>>>
>>>> Tests _maybe_ failed:  ring-leak open-close open-close file-update file-update accept-reuse accept-reuse poll-v-poll poll-v-poll fadvise fadvise madvise madvise short-read short-read openat2 openat2 probe probe shared-wq shared-wq personality personality eventfd eventfd send_recv send_recv eventfd-ring eventfd-ring across-fork across-fork sq-poll-kthread sq-poll-kthread splice splice lfs-openat lfs-openat lfs-openat-write lfs-openat-write iopoll iopoll d4ae271dfaae-test d4ae271dfaae-test eventfd-disable eventfd-disable write-file write-file buf-rw buf-rw statx statx
>>>>
>>>> and also saw this:
>>>>
>>>> [  168.208940] ==================================================================
>>>> [  168.209311] BUG: KASAN: use-after-free in __lock_acquire+0x8bf/0x3000
>>>> [  168.209626] Read of size 8 at addr ffff88806801c0d8 by task io_wqe_worker-0/41761
>>>> [  168.209987]
>>>> [  168.210069] CPU: 0 PID: 41761 Comm: io_wqe_worker-0 Not tainted 5.7.0-rc7+ #6318
>>>> [  168.210424] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
>>>> [  168.210857] Call Trace:
>>>> [  168.210991]  dump_stack+0x97/0xe0
>>>> [  168.211164]  print_address_description.constprop.0+0x1a/0x210
>>>> [  168.211446]  ? __lock_acquire+0x8bf/0x3000
>>>> [  168.211649]  __kasan_report.cold+0x20/0x39
>>>> [  168.211851]  ? __lock_acquire+0x8bf/0x3000
>>>> [  168.212051]  kasan_report+0x30/0x40
>>>> [  168.212226]  __lock_acquire+0x8bf/0x3000
>>>> [  168.212432]  ? ret_from_fork+0x24/0x30
>>>> [  168.212623]  ? stack_trace_save+0x81/0xa0
>>>> [  168.212821]  ? lockdep_hardirqs_on+0x270/0x270
>>>> [  168.213039]  ? save_stack+0x32/0x40
>>>> [  168.213212]  lock_acquire+0x122/0x570
>>>> [  168.213398]  ? __close_fd_get_file+0x40/0x150
>>>> [  168.213615]  ? lock_release+0x3f0/0x3f0
>>>> [  168.213814]  ? __lock_acquire+0x87e/0x3000
>>>> [  168.214016]  _raw_spin_lock+0x2c/0x40
>>>> [  168.214196]  ? __close_fd_get_file+0x40/0x150
>>>> [  168.214408]  __close_fd_get_file+0x40/0x150
>>>> [  168.214618]  io_issue_sqe+0x57f/0x22f0
>>>> [  168.214803]  ? lockdep_hardirqs_on+0x270/0x270
>>>> [  168.215019]  ? mark_held_locks+0x24/0x90
>>>> [  168.215211]  ? quarantine_put+0x6f/0x190
>>>> [  168.215404]  ? io_assign_current_work+0x59/0x80
>>>> [  168.215623]  ? __ia32_sys_io_uring_setup+0x30/0x30
>>>> [  168.215855]  ? find_held_lock+0xcb/0x100
>>>> [  168.216054]  ? io_worker_handle_work+0x289/0x980
>>>> [  168.216280]  ? lock_downgrade+0x340/0x340
>>>> [  168.216476]  ? io_wq_submit_work+0x5d/0x140
>>>> [  168.216679]  ? _raw_spin_unlock_irq+0x24/0x40
>>>> [  168.216890]  io_wq_submit_work+0x5d/0x140
>>>> [  168.217087]  io_worker_handle_work+0x30a/0x980
>>>> [  168.217305]  ? io_wqe_dec_running.isra.0+0x70/0x70
>>>> [  168.217537]  ? do_raw_spin_lock+0x100/0x180
>>>> [  168.217742]  ? rwlock_bug.part.0+0x60/0x60
>>>> [  168.217943]  io_wqe_worker+0x5fd/0x780
>>>> [  168.218126]  ? lock_downgrade+0x340/0x340
>>>> [  168.218323]  ? io_worker_handle_work+0x980/0x980
>>>> [  168.218546]  ? lockdep_hardirqs_on+0x17d/0x270
>>>> [  168.218765]  ? __kthread_parkme+0xca/0xe0
>>>> [  168.218961]  ? io_worker_handle_work+0x980/0x980
>>>> [  168.219186]  kthread+0x1f0/0x220
>>>> [  168.219346]  ? kthread_create_worker_on_cpu+0xb0/0xb0
>>>> [  168.219590]  ret_from_fork+0x24/0x30
>>>> [  168.219768]
>>>> [  168.219846] Allocated by task 41758:
>>>> [  168.220021]  save_stack+0x1b/0x40
>>>> [  168.220185]  __kasan_kmalloc.constprop.0+0xc2/0xd0
>>>> [  168.220416]  kmem_cache_alloc+0xe0/0x290
>>>> [  168.220607]  dup_fd+0x4e/0x5a0
>>>> [  168.220758]  copy_process+0xe35/0x2bf0
>>>> [  168.220942]  _do_fork+0xd8/0x550
>>>> [  168.221102]  __do_sys_clone+0xb5/0xe0
>>>> [  168.221282]  do_syscall_64+0x5e/0xe0
>>>> [  168.221457]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>>> [  168.221729]
>>>> [  168.221848] Freed by task 41759:
>>>> [  168.222088]  save_stack+0x1b/0x40
>>>> [  168.222336]  __kasan_slab_free+0x12f/0x180
>>>> [  168.222632]  slab_free_freelist_hook+0x4d/0x120
>>>> [  168.222959]  kmem_cache_free+0x90/0x2e0
>>>> [  168.223239]  do_exit+0x5d2/0x12e0
>>>> [  168.223482]  do_group_exit+0x6f/0x130
>>>> [  168.223754]  __x64_sys_exit_group+0x28/0x30
>>>> [  168.224061]  do_syscall_64+0x5e/0xe0
>>>> [  168.224326]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>>> [  168.224686]
>>>>
>>>> which indicates that current->files is no longer valid.
>>>
>>> Narrowed it down to the test/open-close test, and in particular where
>>> it closes the ring itself:
>>>
>>> ret = test_close(&ring, ring.ring_fd, 1);
>>>
>>> This seems to be because you do io_req_init_async() after calling
>>> io_issue_sqe(), and the command handler may have set something
>>> else for ->func at that point. Hence we never call the right
>>> handler if the close needs to be deferred, as it needs to for
>>> the io_uring as it has ->flush() defined.
>>>
>>> Why isn't io_req_init_async() just doing:
>>>
>>> static inline void io_req_init_async(struct io_kiocb *req,
>>>                           void (*func)(struct io_wq_work **))
>>> {
>>>          if (!(req->flags & REQ_F_WORK_INITIALIZED)) {
>>>                  req->work = (struct io_wq_work){ .func = func };
>>>                  req->flags |= REQ_F_WORK_INITIALIZED;
>>>          }
>>> }
>>>
>>> ?
>>
>> I guess that won't always work, if the request has been deferred and
>> we're now setting a new work func. So we really want the 'reset to
>> io_wq_submit_work' to only happen if the opcode hasn't already set
>> a private handler. Can you make that change?
>>
>> Also please fix up missing braces. The cases of:
>>
>> if (something) {
>> 	line 1
>> 	line 2
>> } else
>> 	line 3
>>
>> should always includes braces, if one clause has it.
>>
>> A v5 with those two things would be ready to commit.
>>
> 
> There is another thing:
> 
> io_submit_sqes()
>      -> io_close() (let ->flush == NULL)
>          -> __io_close_finish()
>              -> filp_close(req->close.put_file, *req->work.files*);
> 
> where req->work.files is garbage.
I think this bug is independent of my patch. Without my patches, if close request
will be submitted and completed inline, req->work.files will be NULL, it's still
problematic, should we use current->files here?

Regards,
Xiaoguang Wang
> 
