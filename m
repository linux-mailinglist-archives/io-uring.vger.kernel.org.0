Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67213F03AA
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhHRMXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 08:23:23 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:59947 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234896AbhHRMXW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 08:23:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UjituuT_1629289366;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UjituuT_1629289366)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Aug 2021 20:22:46 +0800
Subject: Re: [PATCH 2/3] io_uring: fix failed linkchain code logic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210818074316.22347-1-haoxu@linux.alibaba.com>
 <20210818074316.22347-3-haoxu@linux.alibaba.com>
 <d23478e6-2d2f-dbc1-91c0-b091b3c6cbc9@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <9a27608b-bb14-e3e8-09e3-08f182260937@linux.alibaba.com>
Date:   Wed, 18 Aug 2021 20:22:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d23478e6-2d2f-dbc1-91c0-b091b3c6cbc9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/18 下午6:20, Pavel Begunkov 写道:
> On 8/18/21 8:43 AM, Hao Xu wrote:
>> Given a linkchain like this:
>> req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)
>>
>> There is a problem:
>>   - if some intermediate linked req like req1 's submittion fails, reqs
>>     after it won't be cancelled.
>>
>>     - sqpoll disabled: maybe it's ok since users can get the error info
>>       of req1 and stop submitting the following sqes.
>>
>>     - sqpoll enabled: definitely a problem, the following sqes will be
>>       submitted in the next round.
>>
>> The solution is to refactor the code logic to:
>>   - link a linked req to the chain first, no matter its submittion fails
>>     or not.
>>   - if a linked req's submittion fails, just mark head as
>>     failed. leverage req->result to indicate whether the req is a failed
>>     one or cancelled one.
>>   - submit or fail the whole chain
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 86 ++++++++++++++++++++++++++++++++++-----------------
>>   1 file changed, 58 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c0b841506869..383668e07417 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1920,11 +1920,13 @@ static void io_fail_links(struct io_kiocb *req)
>>   
>>   	req->link = NULL;
>>   	while (link) {
>> +		int res = link->result ? link->result : -ECANCELED;
> 
> btw, we don't properly initialise req->result, and don't want to.
I see, req->result is cleaned to 0 in io_preinit_req() but not the same
when move it back to the free list.
> Perhaps, can be more like
> 
> res = -ECANCELLED;
> if (req->flags & FAIL)
> 	res = req->result;
Agree.

> 
> 
>> +
>>   		nxt = link->link;
>>   		link->link = NULL;
>>   
>>   		trace_io_uring_fail_link(req, link);
>> -		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
>> +		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
>>   		io_put_req_deferred(link);
>>   		link = nxt;
>>   	}
>> @@ -5698,7 +5700,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>>   	if (is_timeout_link) {
>>   		struct io_submit_link *link = &req->ctx->submit_state.link;
>>   
>> -		if (!link->head)
>> +		if (!link->head || link->head == req)
>>   			return -EINVAL;
>>   		if (link->last->opcode == IORING_OP_LINK_TIMEOUT)
>>   			return -EINVAL;
>> @@ -6622,17 +6624,38 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>   	__must_hold(&ctx->uring_lock)
>>   {
>>   	struct io_submit_link *link = &ctx->submit_state.link;
>> +	bool is_link = sqe->flags & (IOSQE_IO_LINK | IOSQE_IO_HARDLINK);
>> +	struct io_kiocb *head;
>>   	int ret;
>>   
>> +	/*
>> +	 * we don't update link->last until we've done io_req_prep()
>> +	 * since linked timeout uses old link->last
>> +	 */
>> +	if (link->head)
>> +		link->last->link = req;
>> +	else if (is_link)
>> +		link->head = req;
>> +	head = link->head;
> 
> It's a horrorsome amount of overhead. How about to set the fail flag
> if failed early and actually fail on io_queue_sqe(), as below. It's
> not tested and a couple more bits added, but hopefully gives the idea.
I get the idea, it's truely with less change. But why do you think the
above code bring in more overhead, since anyway we have to link the req
to the linkchain. I tested it with 
fio-direct-4k-read-with/without-sqpoll, didn't see performance regression.

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ba087f395507..3fd0730655d0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6530,8 +6530,10 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>   	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
>   		return;
>   
> -	if (likely(!(req->flags & REQ_F_FORCE_ASYNC))) {
> +	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC|REQ_F_FAIL)))) {
>   		__io_queue_sqe(req);
> +	} else if (req->flags & REQ_F_FAIL) {
> +		io_req_complete_failed(req, ret);
>   	} else {
>   		int ret = io_req_prep_async(req);
>   
> @@ -6640,19 +6642,17 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   	ret = io_init_req(ctx, req, sqe);
>   	if (unlikely(ret)) {
>   fail_req:
> -		if (link->head) {
> -			/* fail even hard links since we don't submit */
> +		/* fail even hard links since we don't submit */
> +		if (link->head)
>   			req_set_fail(link->head);
> -			io_req_complete_failed(link->head, -ECANCELED);
> -			link->head = NULL;
> -		}
> -		io_req_complete_failed(req, ret);
> -		return ret;
> +		req_set_fail(req);
> +		req->result = ret;
> +	} else {
> +		ret = io_req_prep(req, sqe);
> +		if (unlikely(ret))
> +			goto fail_req;
>   	}
>   
> -	ret = io_req_prep(req, sqe);
> -	if (unlikely(ret))
> -		goto fail_req;
>   
>   	/* don't need @sqe from now on */
>   	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
> @@ -6670,8 +6670,10 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   		struct io_kiocb *head = link->head;
>   
maybe better to add an if(head & FAIL) here, since we don't need to
prep_async if we know it will be cancelled.
>   		ret = io_req_prep_async(req);
> -		if (unlikely(ret))
> -			goto fail_req;
> +		if (unlikely(ret)) {
> +			req->result = ret;
> +			req_set_fail(link->head);
> +		}
>   		trace_io_uring_link(ctx, req, head);
>   		link->last->link = req;
>   		link->last = req;
> 

