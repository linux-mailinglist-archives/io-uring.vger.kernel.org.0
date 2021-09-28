Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1261441B483
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 18:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbhI1Q5T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 12:57:19 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:48696 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241849AbhI1Q5R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 12:57:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpxbUAZ_1632848135;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpxbUAZ_1632848135)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 00:55:36 +0800
Subject: Re: [PATCH 3/8] io_uring: add a limited tw list for irq completion
 work
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-4-haoxu@linux.alibaba.com>
 <aaabb037-01a6-0775-b5b1-2ff67cbfbe53@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <6d1aa3e2-3dc7-3ff3-abb7-2ddc744f6f18@linux.alibaba.com>
Date:   Wed, 29 Sep 2021 00:55:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <aaabb037-01a6-0775-b5b1-2ff67cbfbe53@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/28 下午7:29, Pavel Begunkov 写道:
> On 9/27/21 7:17 AM, Hao Xu wrote:
>> Now we have a lot of task_work users, some are just to complete a req
>> and generate a cqe. Let's put the work to a new tw list which has a
>> higher priority, so that it can be handled quickly and thus to reduce
>> avg req latency. an explanatory case:
>>
>> origin timeline:
>>      submit_sqe-->irq-->add completion task_work
>>      -->run heavy work0~n-->run completion task_work
>> now timeline:
>>      submit_sqe-->irq-->add completion task_work
>>      -->run completion task_work-->run heavy work0~n
>>
>> One thing to watch out is sometimes irq completion TWs comes
>> overwhelmingly, which makes the new tw list grows fast, and TWs in
>> the old list are starved. So we have to limit the length of the new
>> tw list. A practical value is 1/3:
>>      len of new tw list < 1/3 * (len of new + old tw list)
>>
>> In this way, the new tw list has a limited length and normal task get
>> there chance to run.
>>
>> Tested this patch(and the following ones) by manually replace
>> __io_queue_sqe() to io_req_task_complete() to construct 'heavy' task
>> works. Then test with fio:
>>
>> ioengine=io_uring
>> thread=1
>> bs=4k
>> direct=1
>> rw=randread
>> time_based=1
>> runtime=600
>> randrepeat=0
>> group_reporting=1
>> filename=/dev/nvme0n1
>>
>> Tried various iodepth.
>> The peak IOPS for this patch is 314K, while the old one is 249K.
>> For avg latency, difference shows when iodepth grow:
>> depth and avg latency(usec):
>> 	depth      new          old
>> 	 1        22.80        23.77
>> 	 2        23.48        24.54
>> 	 4        24.26        25.57
>> 	 8        29.21        32.89
>> 	 16       53.61        63.50
>> 	 32       106.29       131.34
>> 	 64       217.21       256.33
>> 	 128      421.59       513.87
>> 	 256      815.15       1050.99
>>
>> 95%, 99% etc more data in cover letter.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 44 +++++++++++++++++++++++++++++++-------------
>>   1 file changed, 31 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8317c360f7a4..9272b2cfcfb7 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -461,6 +461,7 @@ struct io_ring_ctx {
>>   	};
>>   };
>>   
>> +#define MAX_EMERGENCY_TW_RATIO	3
>>   struct io_uring_task {
>>   	/* submission side */
>>   	int			cached_refs;
>> @@ -475,6 +476,9 @@ struct io_uring_task {
>>   	spinlock_t		task_lock;
>>   	struct io_wq_work_list	task_list;
>>   	struct callback_head	task_work;
>> +	struct io_wq_work_list	prior_task_list;
>> +	unsigned int		nr;
>> +	unsigned int		prior_nr;
>>   	bool			task_running;
>>   };
>>   
>> @@ -2132,12 +2136,16 @@ static void tctx_task_work(struct callback_head *cb)
>>   	while (1) {
>>   		struct io_wq_work_node *node;
>>   
>> -		if (!tctx->task_list.first && locked)
>> +		if (!tctx->prior_task_list.first &&
>> +		    !tctx->task_list.first && locked)
>>   			io_submit_flush_completions(ctx);
>>   
>>   		spin_lock_irq(&tctx->task_lock);
>> -		node = tctx->task_list.first;
>> +		wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
>> +		node = tctx->prior_task_list.first;
> 
> I find all this accounting expensive, sure I'll see it for my BPF tests.
> 
> How about
> 1) remove MAX_EMERGENCY_TW_RATIO and all the counters,
> prior_nr and others.
> 
> 2) rely solely on list merging
> 
> So, when it enters an iteration of the loop it finds a set of requests
> to run, it first executes all priority ones of that set and then the
> rest (just by the fact that you merged the lists and execute all from
> them).
> 
> It solves the problem of total starvation of non-prio requests, e.g.
> if new completions coming as fast as you complete previous ones. One
> downside is that prio requests coming while we execute a previous
> batch will be executed only after a previous batch of non-prio
> requests, I don't think it's much of a problem but interesting to
> see numbers.
Actually this was one of my implementation, I splited it to two lists
explicitly most because the convience of 8/8 batch the tw in prior list.
I'll evaluate the overhead tomorrow.
> 
> 
>>   		INIT_WQ_LIST(&tctx->task_list);
>> +		INIT_WQ_LIST(&tctx->prior_task_list);
>> +		tctx->nr = tctx->prior_nr = 0;
>>   		if (!node)
>>   			tctx->task_running = false;
>>   		spin_unlock_irq(&tctx->task_lock);
>> @@ -2166,7 +2174,7 @@ static void tctx_task_work(struct callback_head *cb)
>>   	ctx_flush_and_put(ctx, &locked);
>>   }
>>   
>> -static void io_req_task_work_add(struct io_kiocb *req)
>> +static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
> 
> It think "priority" instead of "emergency" will be more accurate
> 
>>   {
>>   	struct task_struct *tsk = req->task;
>>   	struct io_uring_task *tctx = tsk->io_uring;
>> @@ -2178,7 +2186,13 @@ static void io_req_task_work_add(struct io_kiocb *req)
>>   	WARN_ON_ONCE(!tctx);
>>   
>>   	spin_lock_irqsave(&tctx->task_lock, flags);
>> -	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>> +	if (emergency && tctx->prior_nr * MAX_EMERGENCY_TW_RATIO < tctx->nr) {
>> +		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
>> +		tctx->prior_nr++;
>> +	} else {
>> +		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>> +	}
>> +	tctx->nr++;
>>   	running = tctx->task_running;
>>   	if (!running)
>>   		tctx->task_running = true;
> 
> 
> 

