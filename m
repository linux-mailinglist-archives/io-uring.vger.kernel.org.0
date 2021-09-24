Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A45416AFC
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 06:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhIXE3m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 00:29:42 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:43987 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229853AbhIXE3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 00:29:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UpOMucm_1632457688;
Received: from legedeMacBook-Pro.local(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UpOMucm_1632457688)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Sep 2021 12:28:08 +0800
Subject: Re: [RFC 3/3] io_uring: try to batch poll request completion
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
 <20210922123417.2844-4-xiaoguang.wang@linux.alibaba.com>
 <a6806f4e-de9f-81b5-2c5e-3e59a6a6d318@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <61f88377-9950-7b7f-c350-693c2305449e@linux.alibaba.com>
Date:   Fri, 24 Sep 2021 12:28:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a6806f4e-de9f-81b5-2c5e-3e59a6a6d318@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,


> On 9/22/21 1:34 PM, Xiaoguang Wang wrote:
>> For an echo-server based on io_uring's IORING_POLL_ADD_MULTI feature,
>> only poll request are completed in task work, normal read/write
>> requests are issued when user app sees cqes on corresponding poll
>> requests, and they will mostly read/write data successfully, which
>> don't need task work. So at least for echo-server model, batching
>> poll request completion properly will give benefits.
>>
>> Currently don't find any appropriate place to store batched poll
>> requests, put them in struct io_submit_state temporarily, which I
>> think it'll need rework in future.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6fdfb688cf91..14118388bfc6 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -321,6 +321,11 @@ struct io_submit_state {
>>   	 */
>>   	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
>>   	unsigned int		compl_nr;
>> +
>> +	struct io_kiocb		*poll_compl_reqs[IO_COMPL_BATCH];
>> +	bool			poll_req_status[IO_COMPL_BATCH];
>> +	unsigned int		poll_compl_nr;
>> +
>>   	/* inline/task_work completion list, under ->uring_lock */
>>   	struct list_head	free_list;
>>   
>> @@ -2093,6 +2098,8 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
>>   	percpu_ref_put(&ctx->refs);
>>   }
>>   
>> +static void io_poll_flush_completions(struct io_ring_ctx *ctx, bool *locked);
>> +
>>   static void tctx_task_work(struct callback_head *cb)
>>   {
>>   	bool locked = false;
>> @@ -2103,8 +2110,11 @@ static void tctx_task_work(struct callback_head *cb)
>>   	while (1) {
>>   		struct io_wq_work_node *node;
>>   
>> -		if (!tctx->task_list.first && locked && ctx->submit_state.compl_nr)
>> +		if (!tctx->task_list.first && locked && (ctx->submit_state.compl_nr ||
>> +		    ctx->submit_state.poll_compl_nr)) {
> io_submit_flush_completions() shouldn't be called if there are no requests... And the
> check is already inside for-next, will be
>
> if (... && locked) {
> 	io_submit_flush_completions();
> 	if (poll_compl_nr)
> 		io_poll_flush_completions();

OK, thanks for pointing this, and I have dropped the poll request 
completion batching patch, since

it shows performance fluctuations, hard to say whether it's useful.


Regards,

Xiaoguang Wang


> }
>
>>   			io_submit_flush_completions(ctx);
>> +			io_poll_flush_completions(ctx, &locked);
>> +		}
>>   
>>   		spin_lock_irq(&tctx->task_lock);
>>   		node = tctx->task_list.first;
>> @@ -5134,6 +5144,49 @@ static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
>>   static bool __io_poll_remove_one(struct io_kiocb *req,
>>   				 struct io_poll_iocb *poll, bool do_cancel);
>>   
>> +static void io_poll_flush_completions(struct io_ring_ctx *ctx, bool *locked)
>> +	__must_hold(&ctx->uring_lock)
>> +{
>> +	struct io_submit_state *state = &ctx->submit_state;
>> +	struct io_kiocb *req, *nxt;
>> +	int i, nr = state->poll_compl_nr;
>> +	bool done, skip_done = true;
>> +
>> +	spin_lock(&ctx->completion_lock);
>> +	for (i = 0; i < nr; i++) {
>> +		req = state->poll_compl_reqs[i];
>> +		done = __io_poll_complete(req, req->result);
> I believe we first need to fix all the poll problems and lay out something more intuitive
> than the current implementation, or it'd be pure hell to do afterwards.
>
> Can be a nice addition, curious about numbers as well.
>
>
