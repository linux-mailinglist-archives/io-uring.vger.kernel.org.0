Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB52E1D5FF3
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2020 11:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgEPJUw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 May 2020 05:20:52 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:58144 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgEPJUw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 May 2020 05:20:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Tyh2mEi_1589620846;
Received: from 30.39.188.132(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tyh2mEi_1589620846)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 16 May 2020 17:20:46 +0800
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e25b1599-e93e-d828-f45c-79e62356910d@linux.alibaba.com>
Date:   Sat, 16 May 2020 17:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

>> For the latter, it's totally feasible to just have the io_kiocb on
>> stack. The downside is if we need to go the slower path, then we need to
>> alloc an io_kiocb then and copy it. But maybe that's OK... I'll play
>> with it.
> 
> Can you try this with your microbenchmark? Just curious what it looks
> like for that test case if we completely take slab alloc+free out of it.
I run two rounds, every runs 300 seconds:
1st IOPS:      6231528, about 15% improvement
2nd IOPS:      6173959  about 14% improvement.
Looks better for nop tests :)

Regards,
Xiaoguang Wang

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d2e37215d05a..4ecd6bd38f02 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -525,6 +525,7 @@ enum {
>   	REQ_F_POLLED_BIT,
>   	REQ_F_BUFFER_SELECTED_BIT,
>   	REQ_F_NO_FILE_TABLE_BIT,
> +	REQ_F_STACK_REQ_BIT,
>   
>   	/* not a real bit, just to check we're not overflowing the space */
>   	__REQ_F_LAST_BIT,
> @@ -580,6 +581,8 @@ enum {
>   	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
>   	/* doesn't need file table for this request */
>   	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
> +	/* on-stack req */
> +	REQ_F_STACK_REQ		= BIT(REQ_F_STACK_REQ_BIT),
>   };
>   
>   struct async_poll {
> @@ -695,10 +698,14 @@ struct io_op_def {
>   	unsigned		pollout : 1;
>   	/* op supports buffer selection */
>   	unsigned		buffer_select : 1;
> +	/* op can use stack req */
> +	unsigned		stack_req : 1;
>   };
>   
>   static const struct io_op_def io_op_defs[] = {
> -	[IORING_OP_NOP] = {},
> +	[IORING_OP_NOP] = {
> +		.stack_req		= 1,
> +	},
>   	[IORING_OP_READV] = {
>   		.async_ctx		= 1,
>   		.needs_mm		= 1,
> @@ -1345,7 +1352,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
>   	if (req->flags & REQ_F_NEED_CLEANUP)
>   		io_cleanup_req(req);
>   
> -	kfree(req->io);
> +	if (req->io)
> +		kfree(req->io);
>   	if (req->file)
>   		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
>   	if (req->task)
> @@ -1370,6 +1378,8 @@ static void __io_free_req(struct io_kiocb *req)
>   	}
>   
>   	percpu_ref_put(&req->ctx->refs);
> +	if (req->flags & REQ_F_STACK_REQ)
> +		return;
>   	if (likely(!io_is_fallback_req(req)))
>   		kmem_cache_free(req_cachep, req);
>   	else
> @@ -5784,12 +5794,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   	 * link list.
>   	 */
>   	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
> -	req->opcode = READ_ONCE(sqe->opcode);
>   	req->user_data = READ_ONCE(sqe->user_data);
>   	req->io = NULL;
>   	req->file = NULL;
>   	req->ctx = ctx;
> -	req->flags = 0;
>   	/* one is dropped after submission, the other at completion */
>   	refcount_set(&req->refs, 2);
>   	req->task = NULL;
> @@ -5839,6 +5847,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>   {
>   	struct io_submit_state state, *statep = NULL;
>   	struct io_kiocb *link = NULL;
> +	struct io_kiocb stack_req;
>   	int i, submitted = 0;
>   
>   	/* if we have a backlog and couldn't flush it all, return BUSY */
> @@ -5865,20 +5874,31 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>   	for (i = 0; i < nr; i++) {
>   		const struct io_uring_sqe *sqe;
>   		struct io_kiocb *req;
> -		int err;
> +		int err, op;
>   
>   		sqe = io_get_sqe(ctx);
>   		if (unlikely(!sqe)) {
>   			io_consume_sqe(ctx);
>   			break;
>   		}
> -		req = io_alloc_req(ctx, statep);
> -		if (unlikely(!req)) {
> -			if (!submitted)
> -				submitted = -EAGAIN;
> -			break;
> +
> +		op = READ_ONCE(sqe->opcode);
> +
> +		if (io_op_defs[op].stack_req) {
> +			req = &stack_req;
> +			req->flags = REQ_F_STACK_REQ;
> +		} else {
> +			req = io_alloc_req(ctx, statep);
> +			if (unlikely(!req)) {
> +				if (!submitted)
> +					submitted = -EAGAIN;
> +				break;
> +			}
> +			req->flags = 0;
>   		}
>   
> +		req->opcode = op;
> +
>   		err = io_init_req(ctx, req, sqe, statep, async);
>   		io_consume_sqe(ctx);
>   		/* will complete beyond this point, count as submitted */
> 
