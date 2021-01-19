Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB7D2FAE8D
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 02:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbhASB70 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 20:59:26 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34682 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387895AbhASB70 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 20:59:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UMCGcwm_1611021522;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UMCGcwm_1611021522)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Jan 2021 09:58:42 +0800
Subject: Re: [PATCH] io_uring: fix NULL pointer dereference for async cancel
 close
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
 <4f1a8b42-8440-0e9a-ca01-497ccd438b56@gmail.com>
 <ae6fa12a-155b-cf43-7702-b8bb5849a858@gmail.com>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <58b25063-7047-e656-18df-c1240fab3f8d@linux.alibaba.com>
Date:   Tue, 19 Jan 2021 09:58:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <ae6fa12a-155b-cf43-7702-b8bb5849a858@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/18/21 11:08 PM, Pavel Begunkov wrote:
> On 18/01/2021 12:23, Pavel Begunkov wrote:
>> On 18/01/2021 09:50, Joseph Qi wrote:
>>> Abaci reported the following crash:
>>>
>>> [   31.252589] BUG: kernel NULL pointer dereference, address: 00000000000000d8
>>> [   31.253942] #PF: supervisor read access in kernel mode
>>> [   31.254945] #PF: error_code(0x0000) - not-present page
>>> [   31.255964] PGD 800000010b76f067 P4D 800000010b76f067 PUD 10b462067 PMD 0
>>> [   31.257221] Oops: 0000 [#1] SMP PTI
>>> [   31.257923] CPU: 1 PID: 1788 Comm: io_uring-sq Not tainted 5.11.0-rc4 #1
>>> [   31.259175] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>> [   31.260232] RIP: 0010:__lock_acquire+0x19d/0x18c0
>>> [   31.261144] Code: 00 00 8b 1d fd 56 dd 08 85 db 0f 85 43 05 00 00 48 c7 c6 98 7b 95 82 48 c7 c7 57 96 93 82 e8 9a bc f5 ff 0f 0b e9 2b 05 00 00 <48> 81 3f c0 ca 67 8a b8 00 00 00 00 41 0f 45 c0 89 04 24 e9 81 fe
>>> [   31.264297] RSP: 0018:ffffc90001933828 EFLAGS: 00010002
>>> [   31.265320] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
>>> [   31.266594] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000d8
>>> [   31.267922] RBP: 0000000000000246 R08: 0000000000000001 R09: 0000000000000000
>>> [   31.269262] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>>> [   31.270550] R13: 0000000000000000 R14: ffff888106e8a140 R15: 00000000000000d8
>>> [   31.271760] FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
>>> [   31.273269] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   31.274330] CR2: 00000000000000d8 CR3: 0000000106efa004 CR4: 00000000003706e0
>>> [   31.275613] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [   31.276855] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> [   31.278065] Call Trace:
>>> [   31.278649]  lock_acquire+0x31a/0x440
>>> [   31.279404]  ? close_fd_get_file+0x39/0x160
>>> [   31.280276]  ? __lock_acquire+0x647/0x18c0
>>> [   31.281112]  _raw_spin_lock+0x2c/0x40
>>> [   31.281821]  ? close_fd_get_file+0x39/0x160
>>> [   31.282586]  close_fd_get_file+0x39/0x160
>>> [   31.283338]  io_issue_sqe+0x1334/0x14e0
>>> [   31.284053]  ? lock_acquire+0x31a/0x440
>>> [   31.284763]  ? __io_free_req+0xcf/0x2e0
>>> [   31.285504]  ? __io_free_req+0x175/0x2e0
>>> [   31.286247]  ? find_held_lock+0x28/0xb0
>>> [   31.286968]  ? io_wq_submit_work+0x7f/0x240
>>> [   31.287733]  io_wq_submit_work+0x7f/0x240
>>> [   31.288486]  io_wq_cancel_cb+0x161/0x580
>>> [   31.289230]  ? io_wqe_wake_worker+0x114/0x360
>>> [   31.290020]  ? io_uring_get_socket+0x40/0x40
>>> [   31.290832]  io_async_find_and_cancel+0x3b/0x140
>>> [   31.291676]  io_issue_sqe+0xbe1/0x14e0
>>> [   31.292405]  ? __lock_acquire+0x647/0x18c0
>>> [   31.293207]  ? __io_queue_sqe+0x10b/0x5f0
>>> [   31.293986]  __io_queue_sqe+0x10b/0x5f0
>>> [   31.294747]  ? io_req_prep+0xdb/0x1150
>>> [   31.295485]  ? mark_held_locks+0x6d/0xb0
>>> [   31.296252]  ? mark_held_locks+0x6d/0xb0
>>> [   31.297019]  ? io_queue_sqe+0x235/0x4b0
>>> [   31.297774]  io_queue_sqe+0x235/0x4b0
>>> [   31.298496]  io_submit_sqes+0xd7e/0x12a0
>>> [   31.299275]  ? _raw_spin_unlock_irq+0x24/0x30
>>> [   31.300121]  ? io_sq_thread+0x3ae/0x940
>>> [   31.300873]  io_sq_thread+0x207/0x940
>>> [   31.301606]  ? do_wait_intr_irq+0xc0/0xc0
>>> [   31.302396]  ? __ia32_sys_io_uring_enter+0x650/0x650
>>> [   31.303321]  kthread+0x134/0x180
>>> [   31.303982]  ? kthread_create_worker_on_cpu+0x90/0x90
>>> [   31.304886]  ret_from_fork+0x1f/0x30
>>>
>>> This is caused by NULL files when async cancel close, which has
>>> IO_WQ_WORK_NO_CANCEL set and continue to do work. Fix it by also setting
>>> needs_files for IORING_OP_ASYNC_CANCEL.
>>
>> Looks good enough for a quick late-rc fix,
>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Hmm, I hastened, for files we need IO_WQ_WORK_FILES,
> +IO_WQ_WORK_BLKCG for same reasons. needs_file would make 
> it to grab a struct file, that is wrong.
> Probably worked out because it just grabbed fd=0/stdin.
> 

I think IO_WQ_WORK_FILES can work since it will acquire
files when initialize async cancel request.
Don't quite understand why we should have IO_WQ_WORK_BLKCG.

Thanks,
Joseph
