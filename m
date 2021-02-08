Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C4E312915
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 03:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBHCyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 21:54:13 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57176 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhBHCyM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 21:54:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UO6SIG5_1612752779;
Received: from 30.89.237.89(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UO6SIG5_1612752779)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 10:53:00 +0800
Subject: Re: [PATCH] io_uring: don't issue reqs in iopoll mode when ctx is
 dying
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20210206150006.1945-1-xiaoguang.wang@linux.alibaba.com>
 <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <3e3cb8da-d925-7ebd-11a0-f9e145861962@linux.alibaba.com>
Date:   Mon, 8 Feb 2021 10:50:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e4220bf0-2d60-cdd8-c738-cf48236073fa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 06/02/2021 15:00, Xiaoguang Wang wrote:
>> Abaci Robot reported following panic:
>> ------------[ cut here ]------------
>> refcount_t: underflow; use-after-free.
>> WARNING: CPU: 1 PID: 195 at lib/refcount.c:28 refcount_warn_saturate+0x137/0x140
>> Modules linked in:
>> CPU: 1 PID: 195 Comm: kworker/u4:2 Not tainted 5.11.0-rc3+ #70
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.or4
>> Workqueue: events_unbound io_ring_exit_work
>> RIP: 0010:refcount_warn_saturate+0x137/0x140
>> Code: 05 ad 63 49 08 01 e8 45 0f 6f 00 0f 0b e9 16 ff ff ff e8 4c ba ae ff 48 c7 c7 28 2e 7c 82 c6 05 90 63 40
>> RSP: 0018:ffffc900002e3cc8 EFLAGS: 00010282
>> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
>> RDX: ffff888102918000 RSI: ffffffff81150a34 RDI: ffff88813bd28570
>> RBP: ffff8881075cd348 R08: 0000000000000001 R09: 0000000000000001
>> R10: 0000000000000001 R11: 0000000000080000 R12: ffff8881075cd308
>> R13: ffff8881075cd348 R14: ffff888122d33ab8 R15: ffff888104780300
>> FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000108 CR3: 0000000107636005 CR4: 0000000000060ee0
>> Call Trace:
>>   io_dismantle_req+0x3f3/0x5b0
>>   __io_free_req+0x2c/0x270
>>   io_put_req+0x4c/0x70
>>   io_wq_cancel_cb+0x171/0x470
>>   ? io_match_task.part.0+0x80/0x80
>>   __io_uring_cancel_task_requests+0xa0/0x190
>>   io_ring_exit_work+0x32/0x3e0
>>   process_one_work+0x2f3/0x720
>>   worker_thread+0x5a/0x4b0
>>   ? process_one_work+0x720/0x720
>>   kthread+0x138/0x180
>>   ? kthread_park+0xd0/0xd0
>>   ret_from_fork+0x1f/0x30
>>
>> Later system will panic for some memory corruption.
>>
>> The io_identity's count is underflowed. It's because in io_put_identity,
>> first argument tctx comes from req->task->io_uring, the second argument
>> comes from the task context that calls io_req_init_async, so the compare
>> in io_put_identity maybe meaningless. See below case:
>>      task context A issue one polled req, then req->task = A.
>>      task context B do iopoll, above req returns with EAGAIN error.
>>      task context B re-issue req, call io_queue_async_work for req.
>>      req->task->io_uring will set to task context B's identity, or cow new one.
>> then for above case, in io_put_identity(), the compare is meaningless.
>>
>> IIUC, req->task should indicates the initial task context that issues req,
>> then if it gets EAGAIN error, we'll call io_prep_async_work() in req->task
>> context, but iopoll reqs seems special, they maybe issued successfully and
>> got re-issued in other task context because of EAGAIN error.
> 
> Looks as you say, but the patch doesn't solve the issue completely.
> 1. We must not do io_queue_async_work() under a different task context,
> because of it potentially uses a different set of resources. So, I just
> thought that it would be better to punt it to the right task context
> via task_work. But...
> 
> 2. ...iovec import from io_resubmit_prep() might happen after submit ends,
> i.e. when iovec was freed in userspace. And that's not great at all.
Yes, agree, that's why I say we neeed to re-consider the io identity codes
more in commit message :) I'll have a try to prepare a better one.

Regards,
Xiaoguang Wang
> 
>> Currently for this panic, we can disable issuing reqs that are returned
>> with EAGAIN error in iopoll mode when ctx is dying, but we may need to
>> re-consider the io identity codes more.
>>
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 9db05171a774..e3b90426d72b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2467,7 +2467,12 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>>   		int cflags = 0;
>>   
>>   		req = list_first_entry(done, struct io_kiocb, inflight_entry);
>> -		if (READ_ONCE(req->result) == -EAGAIN) {
>> +		/*
>> +		 * If ctx is dying, don't need to issue reqs that are returned
>> +		 * with EAGAIN error, since there maybe no users to reap them.
>> +		 */
>> +		if ((READ_ONCE(req->result) == -EAGAIN) &&
>> +		    !percpu_ref_is_dying(&ctx->refs)) {
>>   			req->result = 0;
>>   			req->iopoll_completed = 0;
>>   			list_move_tail(&req->inflight_entry, &again);
>>
> 
