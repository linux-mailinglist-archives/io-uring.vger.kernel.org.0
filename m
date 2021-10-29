Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED3943F6E8
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 07:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhJ2GBt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 02:01:49 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:36763 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231925AbhJ2GBt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 02:01:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uu6JKwx_1635487159;
Received: from legedeMacBook-Pro.local(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Uu6JKwx_1635487159)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 13:59:19 +0800
Subject: Re: [PATCH v3 3/3] io_uring: don't get completion_lock in
 io_poll_rewait()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
 <20211025053849.3139-4-xiaoguang.wang@linux.alibaba.com>
 <af6423ee-134c-007e-44bc-6f43a22e1e5d@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e989d607-f4d3-bf90-767d-90c7716df895@linux.alibaba.com>
Date:   Fri, 29 Oct 2021 13:59:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <af6423ee-134c-007e-44bc-6f43a22e1e5d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 10/25/21 06:38, Xiaoguang Wang wrote:
>> In current implementation, if there are not available events,
>> io_poll_rewait() just gets completion_lock, and unlocks it in
>> io_poll_task_func() or io_async_task_func(), which isn't necessary.
>>
>> Change this logic to let io_poll_task_func() or io_async_task_func()
>> get the completion_lock lock.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 58 
>> ++++++++++++++++++++++++++--------------------------------
>>   1 file changed, 26 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index e4c779dac953..41ff8fdafe55 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5248,10 +5248,7 @@ static inline int __io_async_wake(struct 
>> io_kiocb *req, struct io_poll_iocb *pol
>>   }
>>     static bool io_poll_rewait(struct io_kiocb *req, struct 
>> io_poll_iocb *poll)
>> -    __acquires(&req->ctx->completion_lock)
>>   {
>> -    struct io_ring_ctx *ctx = req->ctx;
>> -
>>       /* req->task == current here, checking PF_EXITING is safe */
>>       if (unlikely(req->task->flags & PF_EXITING))
>>           WRITE_ONCE(poll->canceled, true);
>> @@ -5262,7 +5259,6 @@ static bool io_poll_rewait(struct io_kiocb 
>> *req, struct io_poll_iocb *poll)
>>           req->result = vfs_poll(req->file, &pt) & poll->events;
>>       }
>>   -    spin_lock(&ctx->completion_lock);
>
> Don't remember poll sync too well but this was synchronising with the
> final section of __io_arm_poll_handler(), and I'm afraid it may go
> completely loose with races.
Yeah, I understand your concerns, and the final section of 
__io_arm_poll_handler() sees
very complicated, it maybe need better cleanup.

After checking my patch and __io_arm_poll_handler() again, I think the 
race which maybe
introduced in my patch is that:
   1)  __io_arm_poll_handler() calls list_del_init(&poll->wait.entry) 
under completion_lock.
   2) io_poll_rewait calls add_wait_queue() without completion_lock.

But __io_arm_poll_handler() only calls list_del_init(&poll->wait.entry)  
when mask isn't zero.
and io_poll_rewait() only calls add_wait_queue when no real event 
happens(mask is zero).
So 1) and 2) should not happen at the same time, seems that there's no race.

Regards,
Xiaoguang Wang

>
>
>>       if (!req->result && !READ_ONCE(poll->canceled)) {
>>           if (req->opcode == IORING_OP_POLL_ADD)
>>               WRITE_ONCE(poll->active, true);

