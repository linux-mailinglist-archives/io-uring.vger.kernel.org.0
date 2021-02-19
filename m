Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0824731F426
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 04:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBSDRL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 22:17:11 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:57365 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhBSDRK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 22:17:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UOw4jlG_1613704586;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UOw4jlG_1613704586)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Feb 2021 11:16:27 +0800
Subject: Re: [PATCH] io_uring: don't recursively hold ctx->uring_lock in
 io_wq_submit_work()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1611394824-73078-1-git-send-email-haoxu@linux.alibaba.com>
 <45a0221a-bd2b-7183-e35d-2d2550f687b5@kernel.dk>
 <d5ff7e3d-db29-ea00-9be5-50b65c69769c@linux.alibaba.com>
 <da91697b-9f7e-2258-9ecc-fb19fc945042@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <3c9c851b-ec14-3683-91b7-527032044c85@linux.alibaba.com>
Date:   Fri, 19 Feb 2021 11:16:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <da91697b-9f7e-2258-9ecc-fb19fc945042@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/19 上午3:15, Pavel Begunkov 写道:
> On 18/02/2021 17:16, Hao Xu wrote:
>> 在 2021/1/25 下午12:31, Jens Axboe 写道:
>>> On 1/23/21 2:40 AM, Hao Xu wrote:
>>>> Abaci reported the following warning:
>>>>
>>>> [   97.862205] ============================================
>>>> [   97.863400] WARNING: possible recursive locking detected
>>>> [   97.864640] 5.11.0-rc4+ #12 Not tainted
>>>> [   97.865537] --------------------------------------------
>>>> [   97.866748] a.out/2890 is trying to acquire lock:
>>>> [   97.867829] ffff8881046763e8 (&ctx->uring_lock){+.+.}-{3:3}, at:
>>>> io_wq_submit_work+0x155/0x240
>>>> [   97.869735]
>>>> [   97.869735] but task is already holding lock:
>>>> [   97.871033] ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
>>>> __x64_sys_io_uring_enter+0x3f0/0x5b0
>>>> [   97.873074]
>>>> [   97.873074] other info that might help us debug this:
>>>> [   97.874520]  Possible unsafe locking scenario:
>>>> [   97.874520]
>>>> [   97.875845]        CPU0
>>>> [   97.876440]        ----
>>>> [   97.877048]   lock(&ctx->uring_lock);
>>>> [   97.877961]   lock(&ctx->uring_lock);
>>>> [   97.878881]
>>>> [   97.878881]  *** DEADLOCK ***
>>>> [   97.878881]
>>>> [   97.880341]  May be due to missing lock nesting notation
>>>> [   97.880341]
>>>> [   97.881952] 1 lock held by a.out/2890:
>>>> [   97.882873]  #0: ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
>>>> __x64_sys_io_uring_enter+0x3f0/0x5b0
>>>> [   97.885108]
>>>> [   97.885108] stack backtrace:
>>>> [   97.886209] CPU: 0 PID: 2890 Comm: a.out Not tainted 5.11.0-rc4+ #12
>>>> [   97.887683] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS
>>>> rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>>>> [   97.890457] Call Trace:
>>>> [   97.891121]  dump_stack+0xac/0xe3
>>>> [   97.891972]  __lock_acquire+0xab6/0x13a0
>>>> [   97.892940]  lock_acquire+0x2c3/0x390
>>>> [   97.893853]  ? io_wq_submit_work+0x155/0x240
>>>> [   97.894894]  __mutex_lock+0xae/0x9f0
>>>> [   97.895785]  ? io_wq_submit_work+0x155/0x240
>>>> [   97.896816]  ? __lock_acquire+0x782/0x13a0
>>>> [   97.897817]  ? io_wq_submit_work+0x155/0x240
>>>> [   97.898867]  ? io_wq_submit_work+0x155/0x240
>>>> [   97.899916]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
>>>> [   97.901101]  io_wq_submit_work+0x155/0x240
>>>> [   97.902112]  io_wq_cancel_cb+0x162/0x490
>>>> [   97.903084]  ? io_uring_get_socket+0x40/0x40
>>>> [   97.904126]  io_async_find_and_cancel+0x3b/0x140
>>>> [   97.905247]  io_issue_sqe+0x86d/0x13e0
>>>> [   97.906186]  ? __lock_acquire+0x782/0x13a0
>>>> [   97.907195]  ? __io_queue_sqe+0x10b/0x550
>>>> [   97.908175]  ? lock_acquire+0x2c3/0x390
>>>> [   97.909122]  __io_queue_sqe+0x10b/0x550
>>>> [   97.910080]  ? io_req_prep+0xd8/0x1090
>>>> [   97.911044]  ? mark_held_locks+0x5a/0x80
>>>> [   97.912042]  ? mark_held_locks+0x5a/0x80
>>>> [   97.913014]  ? io_queue_sqe+0x235/0x470
>>>> [   97.913971]  io_queue_sqe+0x235/0x470
>>>> [   97.914894]  io_submit_sqes+0xcce/0xf10
>>>> [   97.915842]  ? xa_store+0x3b/0x50
>>>> [   97.916683]  ? __x64_sys_io_uring_enter+0x3f0/0x5b0
>>>> [   97.917872]  __x64_sys_io_uring_enter+0x3fb/0x5b0
>>>> [   97.918995]  ? lockdep_hardirqs_on_prepare+0xde/0x180
>>>> [   97.920204]  ? syscall_enter_from_user_mode+0x26/0x70
>>>> [   97.921424]  do_syscall_64+0x2d/0x40
>>>> [   97.922329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> [   97.923538] RIP: 0033:0x7f0b62601239
>>>> [   97.924437] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00
>>>> 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f
>>>>      05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01
>>>>         48
>>>> [   97.928628] RSP: 002b:00007f0b62cc4d28 EFLAGS: 00000246 ORIG_RAX:
>>>> 00000000000001aa
>>>> [   97.930422] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
>>>> 00007f0b62601239
>>>> [   97.932073] RDX: 0000000000000000 RSI: 0000000000006cf6 RDI:
>>>> 0000000000000005
>>>> [   97.933710] RBP: 00007f0b62cc4e20 R08: 0000000000000000 R09:
>>>> 0000000000000000
>>>> [   97.935369] R10: 0000000000000000 R11: 0000000000000246 R12:
>>>> 0000000000000000
>>>> [   97.937008] R13: 0000000000021000 R14: 0000000000000000 R15:
>>>> 00007f0b62cc5700
>>>>
>>>> This is caused by try to hold uring_lock in io_wq_submit_work() without
>>>> checking if we are in io-wq thread context or not. It can be in original
>>>> context when io_wq_submit_work() is called from IORING_OP_ASYNC_CANCEL
>>>> code path, where we already held uring_lock.
>>>
>>> Looks like another fallout of the split CLOSE handling. I've got the
>>> right fixes pending for 5.12:
>>>
>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.12/io_uring&id=6bb0079ef3420041886afe1bcd8e7a87e08992e1
>>>
>>> (and the prep patch before that in the tree). But that won't really
>>> help us for 5.11 and earlier, though we probably should just queue
>>> those two patches for 5.11 and get them into stable. I really don't
>>> like the below patch, though it should fix it. But the root cause
>>> is really the weird open cancelation...
>>>
>> Hi Jens,
>> I've repro-ed this issue on branch for-5.12/io_uring-2021-02-17
>> which contains the patch you give, the issue still exists.
>> I think this one is not an async close specifical problem.
>> The rootcause is we try to run an iowq work in the original
>> context(queue an iowq work, then async cancel it).
> If you mean cancellation executed from task_work or inline (during
> submission), then yes, I agree.
> 
Yea, that's what I mean.
> Can you try a diff below?
Tested, it works well, thanks Pavel.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2fdfe5fa00b0..8dab07f42b34 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2337,7 +2337,9 @@ static void io_req_task_cancel(struct callback_head *cb)
>   	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
>   	struct io_ring_ctx *ctx = req->ctx;
>   
> +	mutex_lock(&ctx->uring_lock);
>   	__io_req_task_cancel(req, -ECANCELED);
> +	mutex_unlock(&ctx->uring_lock);
>   	percpu_ref_put(&ctx->refs);
>   }
>   
> @@ -6426,8 +6428,13 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   	if (timeout)
>   		io_queue_linked_timeout(timeout);
>   
> -	if (work->flags & IO_WQ_WORK_CANCEL)
> -		ret = -ECANCELED;
> +	if (work->flags & IO_WQ_WORK_CANCEL) {
> +		/* io-wq is going to take down one */
> +		refcount_inc(&req->refs);
> +		percpu_ref_get(&req->ctx->refs);
> +		io_req_task_work_add_fallback(req, io_req_task_cancel);
> +		return;
> +	}
>   
>   	if (!ret) {
>   		do {
> 

