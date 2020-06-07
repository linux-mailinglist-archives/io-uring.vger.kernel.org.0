Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25A71F0B1F
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 14:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgFGMhF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 08:37:05 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:57586 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgFGMhF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 08:37:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-pXPed_1591533420;
Received: from 30.15.203.104(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-pXPed_1591533420)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Jun 2020 20:37:01 +0800
Subject: Re: [PATCH] io_uring: execute task_work_run() before dropping mm
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
 <350132ea-aade-27f4-1fcc-ba0539a459a1@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <96f61793-3b44-6de1-c3b6-b54e86d4c203@linux.alibaba.com>
Date:   Sun, 7 Jun 2020 20:37:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <350132ea-aade-27f4-1fcc-ba0539a459a1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 06/06/2020 18:12, Xiaoguang Wang wrote:
>> While testing io_uring in our internal kernel, note it's not upstream
>> kernel, we see below panic:
>> [  872.498723] x29: ffff00002d553cf0 x28: 0000000000000000
>> [  872.508973] x27: ffff807ef691a0e0 x26: 0000000000000000
>> [  872.519116] x25: 0000000000000000 x24: ffff0000090a7980
>> [  872.529184] x23: ffff000009272060 x22: 0000000100022b11
>> [  872.539144] x21: 0000000046aa5668 x20: ffff80bee8562b18
>> [  872.549000] x19: ffff80bee8562080 x18: 0000000000000000
>> [  872.558876] x17: 0000000000000000 x16: 0000000000000000
>> [  872.568976] x15: 0000000000000000 x14: 0000000000000000
>> [  872.578762] x13: 0000000000000000 x12: 0000000000000000
>> [  872.588474] x11: 0000000000000000 x10: 0000000000000c40
>> [  872.598324] x9 : ffff000008100c00 x8 : 000000007ffff000
>> [  872.608014] x7 : ffff80bee8562080 x6 : ffff80beea862d30
>> [  872.617709] x5 : 0000000000000000 x4 : ffff80beea862d48
>> [  872.627399] x3 : ffff80bee8562b18 x2 : 0000000000000000
>> [  872.637044] x1 : ffff0000090a7000 x0 : 0000000000208040
>> [  872.646575] Call trace:
>> [  872.653139]  task_numa_work+0x4c/0x310
>> [  872.660916]  task_work_run+0xb0/0xe0
>> [  872.668400]  io_sq_thread+0x164/0x388
>> [  872.675829]  kthread+0x108/0x138
>>
>> The reason is that once io_sq_thread has a valid mm, schedule subsystem
>> may call task_tick_numa() adding a task_numa_work() callback, which will
>> visit mm, then above panic will happen.
>>
>> To fix this bug, only call task_work_run() before dropping mm.
> 
> So, the problem is that poll/async paths re-issue requests with
> __io_queue_sqe(), which doesn't care about current->mm, and which
> can be NULL for io_sq_thread(). Right?
No, above panic is not triggered by poll/async paths.
See below code path:
==> task_tick_fair()
====> task_tick_numa()
======> task_work_add, work is task_numa_work, which will visit mm.

In sqpoll mode, there maybe are sqes that need mm, then above codes
maybe executed by schedule subsystem. In io_sq_thread, we drop mm before
task_work_run, if there is a task_numa_work, panic occurs.

Regards,
Xiaoguang Wang
> 
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 15 ++++++++-------
>>   1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6391a00ff8b7..32381984b2a6 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6134,6 +6134,13 @@ static int io_sq_thread(void *data)
>>   		 * to enter the kernel to reap and flush events.
>>   		 */
>>   		if (!to_submit || ret == -EBUSY) {
>> +			/*
>> +			 * Current task context may already have valid mm, that
>> +			 * means some works that visit mm may have been queued,
>> +			 * so we must execute the works before dropping mm.
>> +			 */
>> +			if (current->task_works)
>> +				task_work_run();
> 
> Even though you're not dropping mm, the thread might not have it in the first
> place. see how it's done in io_init_req(). How about setting mm either lazily
> in io_poll_task_func()/io_async_task_func(), or before task_work_run() in
> io_sq_thread().
> 
>>   			/*
>>   			 * Drop cur_mm before scheduling, we can't hold it for
>>   			 * long periods (or over schedule()). Do this before
>> @@ -6152,8 +6159,6 @@ static int io_sq_thread(void *data)
>>   			if (!list_empty(&ctx->poll_list) ||
>>   			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
>>   			    !percpu_ref_is_dying(&ctx->refs))) {
>> -				if (current->task_works)
>> -					task_work_run();
>>   				cond_resched();
>>   				continue;
>>   			}
>> @@ -6185,11 +6190,7 @@ static int io_sq_thread(void *data)
>>   					finish_wait(&ctx->sqo_wait, &wait);
>>   					break;
>>   				}
>> -				if (current->task_works) {
>> -					task_work_run();
>> -					finish_wait(&ctx->sqo_wait, &wait);
>> -					continue;
>> -				}
>> +
>>   				if (signal_pending(current))
>>   					flush_signals(current);
>>   				schedule();
>>
> 
