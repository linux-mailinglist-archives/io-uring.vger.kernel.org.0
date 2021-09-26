Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06794186D1
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 08:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhIZG66 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Sep 2021 02:58:58 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:38053 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229829AbhIZG66 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Sep 2021 02:58:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UpbMDYz_1632639440;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpbMDYz_1632639440)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Sep 2021 14:57:21 +0800
Subject: Re: [PATCH v2 04/24] io_uring: use slist for completion batching
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1632516769.git.asml.silence@gmail.com>
 <a666826f2854d17e9fb9417fb302edfeb750f425.1632516769.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <c4b3163b-fc75-059e-1cc9-2b5ed9ce93a3@linux.alibaba.com>
Date:   Sun, 26 Sep 2021 14:57:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a666826f2854d17e9fb9417fb302edfeb750f425.1632516769.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/25 上午4:59, Pavel Begunkov 写道:
> Currently we collect requests for completion batching in an array.
> Replace them with a singly linked list. It's as fast as arrays but
> doesn't take some much space in ctx, and will be used in future patches.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 52 +++++++++++++++++++++++++--------------------------
>   1 file changed, 25 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9c14e9e722ba..9a76c4f84311 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -322,8 +322,8 @@ struct io_submit_state {
>   	/*
>   	 * Batch completion logic
>   	 */
> -	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
> -	unsigned int		compl_nr;
> +	struct io_wq_work_list	compl_reqs;
Will it be better to rename struct io_wq_work_list to something more
generic, io_wq_work_list is a bit confused, we are now using this
type of linked list (stack as well) for various aim, not just to link
iowq works.
> +
>   	/* inline/task_work completion list, under ->uring_lock */
>   	struct list_head	free_list;
>   };
> @@ -883,6 +883,8 @@ struct io_kiocb {
>   	struct io_wq_work		work;
>   	const struct cred		*creds;
>   
> +	struct io_wq_work_node		comp_list;
> +
>   	/* store used ubuf, so we can prevent reloading */
>   	struct io_mapped_ubuf		*imu;
>   };
> @@ -1169,7 +1171,7 @@ static inline void req_ref_get(struct io_kiocb *req)
>   
>   static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
>   {
> -	if (ctx->submit_state.compl_nr)
> +	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>   		__io_submit_flush_completions(ctx);
>   }
>   
> @@ -1326,6 +1328,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	INIT_LIST_HEAD(&ctx->submit_state.free_list);
>   	INIT_LIST_HEAD(&ctx->locked_free_list);
>   	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
> +	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
>   	return ctx;
>   err:
>   	kfree(ctx->dummy_ubuf);
> @@ -1831,11 +1834,16 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
>   static void io_req_complete_state(struct io_kiocb *req, long res,
>   				  unsigned int cflags)
>   {
> +	struct io_submit_state *state;
> +
>   	if (io_req_needs_clean(req))
>   		io_clean_op(req);
>   	req->result = res;
>   	req->compl.cflags = cflags;
>   	req->flags |= REQ_F_COMPLETE_INLINE;
> +
> +	state = &req->ctx->submit_state;
> +	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
>   }
>   
>   static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
> @@ -2324,13 +2332,14 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
>   static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	__must_hold(&ctx->uring_lock)
>   {
> +	struct io_wq_work_node *node, *prev;
>   	struct io_submit_state *state = &ctx->submit_state;
> -	int i, nr = state->compl_nr;
>   	struct req_batch rb;
>   
>   	spin_lock(&ctx->completion_lock);
> -	for (i = 0; i < nr; i++) {
> -		struct io_kiocb *req = state->compl_reqs[i];
> +	wq_list_for_each(node, prev, &state->compl_reqs) {
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    comp_list);
>   
>   		__io_cqring_fill_event(ctx, req->user_data, req->result,
>   					req->compl.cflags);
> @@ -2340,15 +2349,18 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	io_cqring_ev_posted(ctx);
>   
>   	io_init_req_batch(&rb);
> -	for (i = 0; i < nr; i++) {
> -		struct io_kiocb *req = state->compl_reqs[i];
> +	node = state->compl_reqs.first;
> +	do {
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    comp_list);
>   
> +		node = req->comp_list.next;
>   		if (req_ref_put_and_test(req))
>   			io_req_free_batch(&rb, req, &ctx->submit_state);
> -	}
> +	} while (node);
>   
>   	io_req_free_batch_finish(ctx, &rb);
> -	state->compl_nr = 0;
> +	INIT_WQ_LIST(&state->compl_reqs);
>   }
>   
>   /*
> @@ -2668,17 +2680,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
>   	unsigned int cflags = io_put_rw_kbuf(req);
>   	long res = req->result;
>   
> -	if (*locked) {
> -		struct io_ring_ctx *ctx = req->ctx;
> -		struct io_submit_state *state = &ctx->submit_state;
> -
> +	if (*locked)
>   		io_req_complete_state(req, res, cflags);
> -		state->compl_reqs[state->compl_nr++] = req;
> -		if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
> -			io_submit_flush_completions(ctx);
> -	} else {
> +	else
>   		io_req_complete_post(req, res, cflags);
> -	}
>   }
>   
>   static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
> @@ -6969,15 +6974,8 @@ static void __io_queue_sqe(struct io_kiocb *req)
>   	 * doesn't support non-blocking read/write attempts
>   	 */
>   	if (likely(!ret)) {
> -		if (req->flags & REQ_F_COMPLETE_INLINE) {
> -			struct io_ring_ctx *ctx = req->ctx;
> -			struct io_submit_state *state = &ctx->submit_state;
> -
> -			state->compl_reqs[state->compl_nr++] = req;
> -			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
> -				io_submit_flush_completions(ctx);
> +		if (req->flags & REQ_F_COMPLETE_INLINE)
>   			return;
> -		}
>   
>   		linked_timeout = io_prep_linked_timeout(req);
>   		if (linked_timeout)
> 

