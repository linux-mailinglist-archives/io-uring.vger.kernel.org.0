Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9BF3F6DA0
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 05:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhHYDUX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 23:20:23 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:43892 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230021AbhHYDUW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 23:20:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ulgw7LG_1629861573;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ulgw7LG_1629861573)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 Aug 2021 11:19:34 +0800
Subject: Re: [PATCH 2/2] io_uring: add irq completion work to the head of
 task_list
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
 <20210823183648.163361-3-haoxu@linux.alibaba.com>
 <50876fd1-9e8a-baf4-e76e-7232eaae45d9@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <edd2c9c4-774b-6aa2-c871-df8312067f3e@linux.alibaba.com>
Date:   Wed, 25 Aug 2021 11:19:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <50876fd1-9e8a-baf4-e76e-7232eaae45d9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/24 下午8:57, Pavel Begunkov 写道:
> On 8/23/21 7:36 PM, Hao Xu wrote:
>> Now we have a lot of task_work users, some are just to complete a req
>> and generate a cqe. Let's put the work at the head position of the
>> task_list, so that it can be handled quickly and thus to reduce
>> avg req latency. an explanatory case:
>>
>> origin timeline:
>>      submit_sqe-->irq-->add completion task_work
>>      -->run heavy work0~n-->run completion task_work
>> now timeline:
>>      submit_sqe-->irq-->add completion task_work
>>      -->run completion task_work-->run heavy work0~n
> 
> Might be good. There are not so many hot tw users:
> poll, queuing linked requests, and the new IRQ. Could be
> BPF in the future.
async buffered reads as well, regarding buffered reads is
hot operation.
> 
> So, for the test case I'd think about some heavy-ish
> submissions linked to your IRQ req. For instance,
> keeping a large QD of
> 
> read(IRQ-based) -> linked read_pipe(PAGE_SIZE);
> 
> and running it for a while, so they get completely
> out of sync and tw works really mix up. It reads
> from pipes size<=PAGE_SIZE, so it completes inline,
> but the copy takes enough of time.
Thanks Pavel, previously I tried
direct read-->buffered read(async buffered read)
didn't see much difference. I'll try the above case
you offered.
> 
> One thing is that Jens specifically wanted tw's to
> be in FIFO order, where IRQ based will be in LIFO.
> I don't think it's a real problem though, the
> completion handler should be brief enough.In my latest code, the IRQ based tw are also FIFO,
only LIFO between IRQ based tw and other tw:
timeline: tw1 tw2 irq1 irq2
task_list: irq1 irq2 tw1 tw2
> 
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.h    |  9 +++++++++
>>   fs/io_uring.c | 21 ++++++++++++---------
>>   2 files changed, 21 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io-wq.h b/fs/io-wq.h
>> index 308af3928424..51b4408fd177 100644
>> --- a/fs/io-wq.h
>> +++ b/fs/io-wq.h
>> @@ -41,6 +41,15 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>>   		list->last = node;
>>   }
>>   
>> +static inline void wq_list_add_head(struct io_wq_work_node *node,
>> +				    struct io_wq_work_list *list)
>> +{
>> +	node->next = list->first;
>> +	list->first = node;
>> +	if (!node->next)
>> +		list->last = node;
>> +}
>> +
>>   static inline void wq_list_add_tail(struct io_wq_work_node *node,
>>   				    struct io_wq_work_list *list)
>>   {
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8172f5f893ad..954cd8583945 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2050,7 +2050,7 @@ static void tctx_task_work(struct callback_head *cb)
>>   	ctx_flush_and_put(ctx);
>>   }
>>   
>> -static void io_req_task_work_add(struct io_kiocb *req)
>> +static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
>>   {
>>   	struct task_struct *tsk = req->task;
>>   	struct io_uring_task *tctx = tsk->io_uring;
>> @@ -2062,7 +2062,10 @@ static void io_req_task_work_add(struct io_kiocb *req)
>>   	WARN_ON_ONCE(!tctx);
>>   
>>   	spin_lock_irqsave(&tctx->task_lock, flags);
>> -	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>> +	if (emergency)
>> +		wq_list_add_head(&req->io_task_work.node, &tctx->task_list);
>> +	else
>> +		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>>   	running = tctx->task_running;
>>   	if (!running)
>>   		tctx->task_running = true;
>> @@ -2122,19 +2125,19 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>>   {
>>   	req->result = ret;
>>   	req->io_task_work.func = io_req_task_cancel;
>> -	io_req_task_work_add(req);
>> +	io_req_task_work_add(req, true);
>>   }
>>   
>>   static void io_req_task_queue(struct io_kiocb *req)
>>   {
>>   	req->io_task_work.func = io_req_task_submit;
>> -	io_req_task_work_add(req);
>> +	io_req_task_work_add(req, false);
>>   }
>>   
>>   static void io_req_task_queue_reissue(struct io_kiocb *req)
>>   {
>>   	req->io_task_work.func = io_queue_async_work;
>> -	io_req_task_work_add(req);
>> +	io_req_task_work_add(req, false);
>>   }
>>   
>>   static inline void io_queue_next(struct io_kiocb *req)
>> @@ -2249,7 +2252,7 @@ static inline void io_put_req_deferred(struct io_kiocb *req)
>>   {
>>   	if (req_ref_put_and_test(req)) {
>>   		req->io_task_work.func = io_free_req;
>> -		io_req_task_work_add(req);
>> +		io_req_task_work_add(req, false);
>>   	}
>>   }
>>   
>> @@ -2564,7 +2567,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
>>   		return;
>>   	req->result = res;
>>   	req->io_task_work.func = io_req_task_complete;
>> -	io_req_task_work_add(req);
>> +	io_req_task_work_add(req, true);
>>   }
>>   
>>   static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>> @@ -4881,7 +4884,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
>>   	 * of executing it. We can't safely execute it anyway, as we may not
>>   	 * have the needed state needed for it anyway.
>>   	 */
>> -	io_req_task_work_add(req);
>> +	io_req_task_work_add(req, false);
>>   	return 1;
>>   }
>>   
>> @@ -6430,7 +6433,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>>   	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
>>   
>>   	req->io_task_work.func = io_req_task_link_timeout;
>> -	io_req_task_work_add(req);
>> +	io_req_task_work_add(req, false);
>>   	return HRTIMER_NORESTART;
>>   }
>>   
>>
> 

