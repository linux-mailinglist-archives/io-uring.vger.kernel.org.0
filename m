Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192441E92EF
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgE3Rhu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 13:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgE3Rht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 13:37:49 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77BBC03E969
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 10:37:48 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d128so7313328wmc.1
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 10:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PFIL2cSic7fR/NmEoXJARjLMwQ0lGmIleZbppVlcCww=;
        b=ZVQHPfW9hwHYiyyxI3KdPBbRgsNyCeZ6ndgTn+79HrIbJnhcP2z2XxyR4DRXitICQA
         5TTB//HTBhcpKqKOQTqAn6abMzFTqJ9RqMzWPqUjVBbCiZz0aUtq7ZoXt6s+Bh8+RJlV
         FurO35BaAhVlJgaKPOuDtRigmvl3sVLY68skiw3NdP4K8oegqmAWV+mlmcfvNvRQGyXf
         aqBdWcI7v5dm0BacnMXLUn7yfZ0+43zafOwAbcnshUBoBV4BcO0SmH/Yeg43Zbsi8adn
         OnmNwxvUPndX291cDp+wBtgP8QVgNTdy6EqyFQX6fJlddXM7MD36NGwePny3Sx3iuLqF
         sf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PFIL2cSic7fR/NmEoXJARjLMwQ0lGmIleZbppVlcCww=;
        b=I0xiz8FZt6MPK5cuTiBJEJ3hMYNe3jT6eRXmhTY/R75bq7+/73c0KJ8ZpiSH4u8sr2
         yR/1TJ3iv8JM+rJJ66ywGGXkcfNbRmTFXJFV56UpKTScPG6f1KlHaO6+MIYyvxb0S5PS
         eQGRmJcQPsuE6A8bCZIJamY/EJtyJSgg3PxYTRmtwjieJGGdgHo+NiQY/F3uatCfM0TJ
         V7FqEetf3ex8NYJtkeVuDS7uHWjHf6Ll5LBV225fZG3yK30GK5+GTCitjrb9pFjlp9Sc
         u77Usf/vo1El/5x3i2fBClnBJEDxGuZBNlf51nPkxi1ANSaqXgBTY08cTaiiU5jwm0m6
         S3TA==
X-Gm-Message-State: AOAM5336uGKgvjVSaW/g3jLpQ012LtCXQ+bnly04SOR7ehPdB8uu0erP
        K1PTfrNKAypGc3IaAZ9ugqkrVU8B
X-Google-Smtp-Source: ABdhPJxvNrSAaap8Bw87hhaXVVv6ZEI9nKsmf2iVeLtIvYz2X5xIe/zPaAWfJFQ5pgtHD1/IsIKbhg==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr9172143wma.83.1590860267187;
        Sat, 30 May 2020 10:37:47 -0700 (PDT)
Received: from [192.168.43.60] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id f11sm8724339wrj.2.2020.05.30.10.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 10:37:46 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200530143947.21224-1-xiaoguang.wang@linux.alibaba.com>
 <8c361177-c0b0-b08c-e0a5-141f7fd948f0@kernel.dk>
 <e2040210-ab73-e82b-50ea-cdeb88c69157@kernel.dk>
 <27e264ec-2707-495f-3d24-4e9e20b86032@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v4 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
Message-ID: <12819413-f2bf-8156-c0e2-e617ce918e76@gmail.com>
Date:   Sat, 30 May 2020 20:36:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <27e264ec-2707-495f-3d24-4e9e20b86032@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/05/2020 20:29, Jens Axboe wrote:
> On 5/30/20 11:14 AM, Jens Axboe wrote:
>> On 5/30/20 10:44 AM, Jens Axboe wrote:
>>> On 5/30/20 8:39 AM, Xiaoguang Wang wrote:
>>>> If requests can be submitted and completed inline, we don't need to
>>>> initialize whole io_wq_work in io_init_req(), which is an expensive
>>>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>>>> io_wq_work is initialized.
>>>>
>>>> I use /dev/nullb0 to evaluate performance improvement in my physical
>>>> machine:
>>>>   modprobe null_blk nr_devices=1 completion_nsec=0
>>>>   sudo taskset -c 60 fio  -name=fiotest -filename=/dev/nullb0 -iodepth=128
>>>>   -thread -rw=read -ioengine=io_uring -direct=1 -bs=4k -size=100G -numjobs=1
>>>>   -time_based -runtime=120
>>>>
>>>> before this patch:
>>>> Run status group 0 (all jobs):
>>>>    READ: bw=724MiB/s (759MB/s), 724MiB/s-724MiB/s (759MB/s-759MB/s),
>>>>    io=84.8GiB (91.1GB), run=120001-120001msec
>>>>
>>>> With this patch:
>>>> Run status group 0 (all jobs):
>>>>    READ: bw=761MiB/s (798MB/s), 761MiB/s-761MiB/s (798MB/s-798MB/s),
>>>>    io=89.2GiB (95.8GB), run=120001-120001msec
>>>>
>>>> About 5% improvement.
>>>
>>> There's something funky going on here. I ran the liburing test
>>> suite on this, and get a lot of left behind workers:
>>>
>>> Tests _maybe_ failed:  ring-leak open-close open-close file-update file-update accept-reuse accept-reuse poll-v-poll poll-v-poll fadvise fadvise madvise madvise short-read short-read openat2 openat2 probe probe shared-wq shared-wq personality personality eventfd eventfd send_recv send_recv eventfd-ring eventfd-ring across-fork across-fork sq-poll-kthread sq-poll-kthread splice splice lfs-openat lfs-openat lfs-openat-write lfs-openat-write iopoll iopoll d4ae271dfaae-test d4ae271dfaae-test eventfd-disable eventfd-disable write-file write-file buf-rw buf-rw statx statx
>>>
>>> and also saw this:
>>>
>>> [  168.208940] ==================================================================
>>> [  168.209311] BUG: KASAN: use-after-free in __lock_acquire+0x8bf/0x3000
>>> [  168.209626] Read of size 8 at addr ffff88806801c0d8 by task io_wqe_worker-0/41761
>>> [  168.209987] 
>>> [  168.210069] CPU: 0 PID: 41761 Comm: io_wqe_worker-0 Not tainted 5.7.0-rc7+ #6318
>>> [  168.210424] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
>>> [  168.210857] Call Trace:
>>> [  168.210991]  dump_stack+0x97/0xe0
>>> [  168.211164]  print_address_description.constprop.0+0x1a/0x210
>>> [  168.211446]  ? __lock_acquire+0x8bf/0x3000
>>> [  168.211649]  __kasan_report.cold+0x20/0x39
>>> [  168.211851]  ? __lock_acquire+0x8bf/0x3000
>>> [  168.212051]  kasan_report+0x30/0x40
>>> [  168.212226]  __lock_acquire+0x8bf/0x3000
>>> [  168.212432]  ? ret_from_fork+0x24/0x30
>>> [  168.212623]  ? stack_trace_save+0x81/0xa0
>>> [  168.212821]  ? lockdep_hardirqs_on+0x270/0x270
>>> [  168.213039]  ? save_stack+0x32/0x40
>>> [  168.213212]  lock_acquire+0x122/0x570
>>> [  168.213398]  ? __close_fd_get_file+0x40/0x150
>>> [  168.213615]  ? lock_release+0x3f0/0x3f0
>>> [  168.213814]  ? __lock_acquire+0x87e/0x3000
>>> [  168.214016]  _raw_spin_lock+0x2c/0x40
>>> [  168.214196]  ? __close_fd_get_file+0x40/0x150
>>> [  168.214408]  __close_fd_get_file+0x40/0x150
>>> [  168.214618]  io_issue_sqe+0x57f/0x22f0
>>> [  168.214803]  ? lockdep_hardirqs_on+0x270/0x270
>>> [  168.215019]  ? mark_held_locks+0x24/0x90
>>> [  168.215211]  ? quarantine_put+0x6f/0x190
>>> [  168.215404]  ? io_assign_current_work+0x59/0x80
>>> [  168.215623]  ? __ia32_sys_io_uring_setup+0x30/0x30
>>> [  168.215855]  ? find_held_lock+0xcb/0x100
>>> [  168.216054]  ? io_worker_handle_work+0x289/0x980
>>> [  168.216280]  ? lock_downgrade+0x340/0x340
>>> [  168.216476]  ? io_wq_submit_work+0x5d/0x140
>>> [  168.216679]  ? _raw_spin_unlock_irq+0x24/0x40
>>> [  168.216890]  io_wq_submit_work+0x5d/0x140
>>> [  168.217087]  io_worker_handle_work+0x30a/0x980
>>> [  168.217305]  ? io_wqe_dec_running.isra.0+0x70/0x70
>>> [  168.217537]  ? do_raw_spin_lock+0x100/0x180
>>> [  168.217742]  ? rwlock_bug.part.0+0x60/0x60
>>> [  168.217943]  io_wqe_worker+0x5fd/0x780
>>> [  168.218126]  ? lock_downgrade+0x340/0x340
>>> [  168.218323]  ? io_worker_handle_work+0x980/0x980
>>> [  168.218546]  ? lockdep_hardirqs_on+0x17d/0x270
>>> [  168.218765]  ? __kthread_parkme+0xca/0xe0
>>> [  168.218961]  ? io_worker_handle_work+0x980/0x980
>>> [  168.219186]  kthread+0x1f0/0x220
>>> [  168.219346]  ? kthread_create_worker_on_cpu+0xb0/0xb0
>>> [  168.219590]  ret_from_fork+0x24/0x30
>>> [  168.219768] 
>>> [  168.219846] Allocated by task 41758:
>>> [  168.220021]  save_stack+0x1b/0x40
>>> [  168.220185]  __kasan_kmalloc.constprop.0+0xc2/0xd0
>>> [  168.220416]  kmem_cache_alloc+0xe0/0x290
>>> [  168.220607]  dup_fd+0x4e/0x5a0
>>> [  168.220758]  copy_process+0xe35/0x2bf0
>>> [  168.220942]  _do_fork+0xd8/0x550
>>> [  168.221102]  __do_sys_clone+0xb5/0xe0
>>> [  168.221282]  do_syscall_64+0x5e/0xe0
>>> [  168.221457]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>> [  168.221729] 
>>> [  168.221848] Freed by task 41759:
>>> [  168.222088]  save_stack+0x1b/0x40
>>> [  168.222336]  __kasan_slab_free+0x12f/0x180
>>> [  168.222632]  slab_free_freelist_hook+0x4d/0x120
>>> [  168.222959]  kmem_cache_free+0x90/0x2e0
>>> [  168.223239]  do_exit+0x5d2/0x12e0
>>> [  168.223482]  do_group_exit+0x6f/0x130
>>> [  168.223754]  __x64_sys_exit_group+0x28/0x30
>>> [  168.224061]  do_syscall_64+0x5e/0xe0
>>> [  168.224326]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>> [  168.224686] 
>>>
>>> which indicates that current->files is no longer valid.
>>
>> Narrowed it down to the test/open-close test, and in particular where
>> it closes the ring itself:
>>
>> ret = test_close(&ring, ring.ring_fd, 1);
>>
>> This seems to be because you do io_req_init_async() after calling
>> io_issue_sqe(), and the command handler may have set something
>> else for ->func at that point. Hence we never call the right
>> handler if the close needs to be deferred, as it needs to for
>> the io_uring as it has ->flush() defined.
>>
>> Why isn't io_req_init_async() just doing:
>>
>> static inline void io_req_init_async(struct io_kiocb *req,
>>                          void (*func)(struct io_wq_work **))
>> {                                                                               
>>         if (!(req->flags & REQ_F_WORK_INITIALIZED)) {
>>                 req->work = (struct io_wq_work){ .func = func };
>>                 req->flags |= REQ_F_WORK_INITIALIZED;
>>         }
>> }
>>
>> ?
> 
> I guess that won't always work, if the request has been deferred and
> we're now setting a new work func. So we really want the 'reset to
> io_wq_submit_work' to only happen if the opcode hasn't already set
> a private handler. Can you make that change?
> 
> Also please fix up missing braces. The cases of:
> 
> if (something) {
> 	line 1
> 	line 2
> } else
> 	line 3
> 
> should always includes braces, if one clause has it.
> 
> A v5 with those two things would be ready to commit.
> 

There is another thing:

io_submit_sqes()
    -> io_close() (let ->flush == NULL)
        -> __io_close_finish()
            -> filp_close(req->close.put_file, *req->work.files*);

where req->work.files is garbage.

-- 
Pavel Begunkov
